//
//  ReviewReplies.swift
//  bout
//
//  Created by Colton Lathrop on 12/23/22.
//

import Foundation
import SwiftUI

struct ReviewReplies: View {
    var fullReview: FullReview
    
    var body: some View {
        VStack{
            ForEach(fullReview.replies) { reply in
                ReviewReply(reply: reply)
            }
        }
    }
}

struct ReviewReply: View {
    var reply: Reply
    
    @EnvironmentObject var auth: Authentication
    
    var body: some View {
        HStack{
            ProfilePicLoader(token: auth.token, userId: reply.userId, picSize: .small)
            Text(reply.text).padding(.top, 7).font(.caption)
            Spacer()
        }
    }
}

struct ReviewReplies_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            ReviewReplies(fullReview: generateFullReviewPreviewData()).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
        }
    }
}
