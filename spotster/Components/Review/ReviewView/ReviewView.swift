//
//  ReviewView.swift
//  spotster
//
//  Created by Colton Lathrop on 1/4/23.
//

import Foundation
import SwiftUI

struct ReviewView: View {
    @Binding var path: NavigationPath
    
    var reloadCallback: () async -> Void
    var user: User
    var fullReview: FullReview
    var showLocation = true
    
    @EnvironmentObject var auth: Authentication
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack {
                    ReviewHeader(path: self.$path, user: user, review: fullReview.review)
                    if let pic = self.fullReview.pics.first {
                        ReviewPicLoader(path: self.$path, pic: pic).overlay {
                            ReviewPicOverlay(path: self.$path, likes: fullReview.likes, reviewId: fullReview.review.id, reloadCallback: reloadCallback)
                        }
                    }
                    ReviewText(path: self.$path, fullReview: self.fullReview)
                        .padding(.top, 3.0)
                    ReviewAddReply(reloadCallback: reloadCallback, fullReview: fullReview, scrollProxy: proxy)
                    ReviewReplies(path: self.$path, reloadCallback: self.reloadCallback, fullReview: self.fullReview)
                }.padding()
            }.scrollDismissesKeyboard(.immediately)
                .refreshable {
                    Task {
                        await self.reloadCallback()
                    }
                }.navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ReviewView_Previews: PreviewProvider {
    static func dummyCallback() async {}
    
    static var previews: some View {
        ReviewView(path: .constant(NavigationPath()), reloadCallback: dummyCallback, user: generateUserPreviewData(), fullReview: generateFullReviewPreviewData()).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
    }
}
