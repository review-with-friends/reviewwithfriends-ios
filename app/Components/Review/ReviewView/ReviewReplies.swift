//
//  ReviewReplies.swift
//  app
//
//  Created by Colton Lathrop on 12/23/22.
//

import Foundation
import SwiftUI

struct ReviewReplies: View {
    @Binding var path: NavigationPath
    @Binding var showReplyOverlay: Bool
    
    var setReplyingTo: (String) -> Void
    var reloadCallback: () async -> Void
    var fullReview: FullReview
    
    var body: some View {
        VStack{
            ForEach(GroupedReplies.buildGroupedReplies(replies: self.fullReview.replies)) { groupedReply in
                if let reply = groupedReply.parent {
                    ReviewReply(path: self.$path, showReplyOverlay: self.$showReplyOverlay, setReplyingTo: self.setReplyingTo, reloadCallback: reloadCallback, reply: reply)
                } else {
                    HStack {
                        Text("<Deleted Reply>").foregroundColor(.secondary).font(.caption)
                        Spacer()
                    }.padding(.top, 16)
                }
                ForEach(groupedReply.children.sorted { $0.created < $1.created }) { reply in
                    HStack {
                        ReviewReply(path: self.$path, showReplyOverlay: self.$showReplyOverlay, setReplyingTo: self.setReplyingTo, reloadCallback: reloadCallback, reply: reply).padding(.leading, 8)
                    }.padding(.leading, 24).padding(.top, -6)
                }
            }
        }.padding(.top)
    }
}

struct ReviewReply: View {
    @Binding var path: NavigationPath
    @Binding var showReplyOverlay: Bool
    
    var setReplyingTo: (String) -> Void
    var reloadCallback: () async -> Void
    var reply: Reply
    
    @State var showDeleteConfirmation = false
    @State var showDeleteError = false
    @State var deleteErrorMessage = ""
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var feedRefreshManager: FeedRefreshManager
    
    func deleteReply() async {
        let result = await app.removeReplyFromReview(token: self.auth.token, reviewId: self.reply.reviewId, replyId: self.reply.id)
        
        switch result {
        case .success(_):
            await reloadCallback()
            self.feedRefreshManager.push(review_id: self.reply.reviewId)
        case .failure(let error):
            self.deleteErrorMessage = error.description
            self.showDeleteError = true
        }
    }
    
    var profilePic: some View {
        VStack {
            ProfilePicLoader(path: self.$path, userId: reply.userId, profilePicSize: .mediumSmall, navigatable: true, ignoreCache: false)
        }.padding(8).frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
    }
    
    var text: some View {
        VStack {
            HStack {
                SlimDate(date: reply.created)
                Spacer()
            }
            HStack {
                Text(reply.text).font(.caption)
                Spacer()
            }
        }.frame(minHeight: 0, maxHeight: .infinity, alignment: .top).padding(.top, 8)
    }
    
    var delete: some View {
        VStack {
            VStack {
                if let user = auth.user {
                    if reply.userId == user.id {
                        HStack {
                            Button(action:{
                                self.showDeleteConfirmation = true
                            }){
                                Image(systemName: "trash")
                            }.padding(.top, 1).accentColor(.secondary)
                        }
                    }
                }
            }.fixedSize().alert(
                "Are you sure you want to delete this reply?",
                isPresented: $showDeleteConfirmation
            ) {
                Button(role: .destructive) {
                    Task {
                        await self.deleteReply()
                    }
                } label: {
                    Text("Delete Reply")
                }
            }.alert(
                "Delete Failed. Do you want to retry?",
                isPresented: $showDeleteError,
                presenting: self.deleteErrorMessage
            ) { message in
                Button("Cancel", role: nil){
                    self.deleteErrorMessage = ""
                }
                Button("Retry", role: nil) {
                    Task {
                        await self.deleteReply()
                    }
                }
            } message: { message in
                Text(message)
            }
        }
    }
    
    var replyButton: some View {
        VStack {
            if let user = auth.user {
                if reply.userId != user.id {
                    HStack {
                        Button(action:{
                            withAnimation {
                                self.setReplyingTo(self.reply.id)
                                self.showReplyOverlay = true;
                            }
                        }){
                            Image(systemName: "arrowshape.turn.up.left.fill").font(.caption)
                        }.padding(.top, 1).accentColor(.secondary)
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                self.profilePic
                self.text
                HStack {
                    self.delete
                    self.replyButton
                }
            }
        }
    }
}

struct ReviewReplies_Preview: PreviewProvider {
    static func dummyCallback() async {
        
    }
    
    static func dummyReplyTo(id: String) {
        
    }
    
    static var previews: some View {
        VStack {
            ReviewReplies(path: .constant(NavigationPath()), showReplyOverlay: .constant(true), setReplyingTo: dummyReplyTo, reloadCallback: dummyCallback, fullReview: generateFullReviewPreviewData()).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
        }
    }
}
