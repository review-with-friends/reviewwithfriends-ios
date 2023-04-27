//
//  GroupedReplyTests.swift
//  appTests
//
//  Created by Colton Lathrop on 4/25/23.
//

import XCTest
@testable import app

final class GroupedReplyTests: XCTestCase {
    func testNilLotsNil() throws {
        // Arrange
        var replies: [Reply] = []
        
        replies.append(Reply(id: "1", created: Date(), userId: "", reviewId: "", text: "", replyToId: nil))
        replies.append(Reply(id: "2", created: Date(), userId: "", reviewId: "", text: "", replyToId: "1"))
        replies.append(Reply(id: "3", created: Date(), userId: "", reviewId: "", text: "", replyToId: "1"))
        replies.append(Reply(id: "4", created: Date(), userId: "", reviewId: "", text: "", replyToId: "1"))
        replies.append(Reply(id: "5", created: Date(), userId: "", reviewId: "", text: "", replyToId: "2"))
        replies.append(Reply(id: "6", created: Date(), userId: "", reviewId: "", text: "", replyToId: "3"))
        replies.append(Reply(id: "7", created: Date(), userId: "", reviewId: "", text: "", replyToId: "3"))
        replies.append(Reply(id: "8", created: Date(), userId: "", reviewId: "", text: "", replyToId: "3"))
        replies.append(Reply(id: "9", created: Date(), userId: "", reviewId: "", text: "", replyToId: "0"))
        replies.append(Reply(id: "10", created: Date(), userId: "", reviewId: "", text: "", replyToId: "0"))
        replies.append(Reply(id: "11", created: Date(), userId: "", reviewId: "", text: "", replyToId: nil))
        replies.append(Reply(id: "12", created: Date(), userId: "", reviewId: "", text: "", replyToId: nil))
        replies.append(Reply(id: "13", created: Date(), userId: "", reviewId: "", text: "", replyToId: nil))
        
        // Act
        
        let groups = GroupedReplies.buildGroupedReplies(replies: replies)
        
        // Assert
        print(groups.count)
        XCTAssert(groups.count == 5)
    }
    
    func testAllNil() throws {
        // Arrange
        var replies: [Reply] = []
        
        replies.append(Reply(id: "11", created: Date(), userId: "", reviewId: "", text: "", replyToId: nil))
        replies.append(Reply(id: "12", created: Date(), userId: "", reviewId: "", text: "", replyToId: nil))
        replies.append(Reply(id: "13", created: Date(), userId: "", reviewId: "", text: "", replyToId: nil))
        
        // Act
        
        let groups = GroupedReplies.buildGroupedReplies(replies: replies)
        
        // Assert
        print(groups.count)
        XCTAssert(groups.count == 2)
    }
    
    func testNilLotsOfOrphaned() throws {
        // Arrange
        var replies: [Reply] = []
        
        replies.append(Reply(id: "9", created: Date(), userId: "", reviewId: "", text: "", replyToId: "0"))
        replies.append(Reply(id: "10", created: Date(), userId: "", reviewId: "", text: "", replyToId: "0"))
        replies.append(Reply(id: "11", created: Date(), userId: "", reviewId: "", text: "", replyToId: "0"))
        replies.append(Reply(id: "12", created: Date(), userId: "", reviewId: "", text: "", replyToId: "0"))
        replies.append(Reply(id: "13", created: Date(), userId: "", reviewId: "", text: "", replyToId: "0"))
        
        // Act
        
        let groups = GroupedReplies.buildGroupedReplies(replies: replies)
        
        // Assert
        print(groups.count)
        XCTAssert(groups.count == 1)
    }
    
    func testNilLotsNilOrphansNil() throws {
        // Arrange
        var replies: [Reply] = []
        
        replies.append(Reply(id: "1", created: Date(), userId: "", reviewId: "", text: "", replyToId: "19"))
        replies.append(Reply(id: "2", created: Date(), userId: "", reviewId: "", text: "", replyToId: "1"))
        replies.append(Reply(id: "3", created: Date(), userId: "", reviewId: "", text: "", replyToId: "1"))
        replies.append(Reply(id: "4", created: Date(), userId: "", reviewId: "", text: "", replyToId: "1"))
        replies.append(Reply(id: "5", created: Date(), userId: "", reviewId: "", text: "", replyToId: "2"))
        replies.append(Reply(id: "6", created: Date(), userId: "", reviewId: "", text: "", replyToId: "3"))
        replies.append(Reply(id: "7", created: Date(), userId: "", reviewId: "", text: "", replyToId: "3"))
        replies.append(Reply(id: "8", created: Date(), userId: "", reviewId: "", text: "", replyToId: "3"))
        replies.append(Reply(id: "9", created: Date(), userId: "", reviewId: "", text: "", replyToId: "0"))
        replies.append(Reply(id: "10", created: Date(), userId: "", reviewId: "", text: "", replyToId: "0"))
        replies.append(Reply(id: "11", created: Date(), userId: "", reviewId: "", text: "", replyToId: nil))
        replies.append(Reply(id: "12", created: Date(), userId: "", reviewId: "", text: "", replyToId: nil))
        replies.append(Reply(id: "13", created: Date(), userId: "", reviewId: "", text: "", replyToId: nil))
        replies.append(Reply(id: "14", created: Date(), userId: "", reviewId: "", text: "", replyToId: "0"))
        replies.append(Reply(id: "15", created: Date(), userId: "", reviewId: "", text: "", replyToId: "0"))
        replies.append(Reply(id: "16", created: Date(), userId: "", reviewId: "", text: "", replyToId: "0"))
        replies.append(Reply(id: "17", created: Date(), userId: "", reviewId: "", text: "", replyToId: "0"))
        replies.append(Reply(id: "18", created: Date(), userId: "", reviewId: "", text: "", replyToId: "0"))
        replies.append(Reply(id: "19", created: Date(), userId: "", reviewId: "", text: "", replyToId: nil))
        
        // Act
        
        let groups = GroupedReplies.buildGroupedReplies(replies: replies)
        
        // Assert
        var count = 0
        
        for group in groups {
            if group.parent != nil {
                count += 1
            }
            count += group.children.count
        }
        
        print(count)
        XCTAssert(groups.count == 5)
    }
}
