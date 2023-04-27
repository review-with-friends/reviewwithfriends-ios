//
//  GroupedReplies.swift
//  app
//
//  Created by Colton Lathrop on 4/25/23.
//

import Foundation

class GroupedReplies: Identifiable {
    public let id: String
    public let parent: Reply?
    public var children: [Reply]
    
    init(id: String, parent: Reply?, children: [Reply]) {
        self.id = id
        self.parent = parent
        self.children = children.sorted { $0.created < $1.created }
    }
    
    public static func buildGroupedReplies(replies: [Reply]) -> [GroupedReplies] {
        var groupedReplies: [GroupedReplies] = []
        
        for reply in replies {
            if reply.replyToId == nil {
                // if no replyTo, it's a group.
                groupedReplies.append(GroupedReplies(id: reply.id, parent: reply, children: []))
            }
        }
        
        var orphanedReplies: [Reply] = []
        
        homedPlacementLoop: for reply in replies {
            if let replyToId = reply.replyToId {
                searchLoop: for groupedReply in groupedReplies {
                    if replyToId == groupedReply.id {
                        groupedReply.children.append(reply)
                        continue homedPlacementLoop
                    }
                    
                    for childReply in groupedReply.children {
                        if childReply.id == replyToId {
                            groupedReply.children.append(reply)
                            continue homedPlacementLoop
                        }
                    }
                }
                
                // if we get here without continuing, this is an orphaned reply.
                orphanedReplies.append(reply)
            }
        }
        
        orphanLoop: for orphanedReply in orphanedReplies {
            searchLoop: for groupedReply in groupedReplies {
                if orphanedReply.replyToId == groupedReply.id {
                    groupedReply.children.append(orphanedReply)
                    continue orphanLoop
                }
                
                for childReply in groupedReply.children {
                    if childReply.id == orphanedReply.replyToId || orphanedReply.replyToId == childReply.replyToId {
                        groupedReply.children.append(orphanedReply)
                        continue orphanLoop
                    }
                }
            }
            // if we make it all they way through, create it
            groupedReplies.append(GroupedReplies(id: "", parent: nil, children: [orphanedReply]))
        }
        
        return groupedReplies.sorted {
            if let date0 = $0.parent?.created, let date1 = $1.parent?.created {
                return date0 > date1
            } else {
                if $0.parent?.created == nil {
                    return false
                } else {
                    return true
                }
            }
        }
    }
}
