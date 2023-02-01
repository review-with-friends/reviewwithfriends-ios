//
//  ReviewView.swift
//  spotster
//
//  Created by Colton Lathrop on 1/3/23.
//

import Foundation
import SwiftUI

struct ReviewListItem: View {
    var reloadCallback: () async -> Void
    var user: User
    var fullReview: FullReview
    var showLocation = true
    
    @EnvironmentObject var auth: Authentication
    
    var body: some View {
        VStack {
            VStack {
                if let pic = self.fullReview.pics.first {
                    ReviewPicLoader(pic: pic).overlay {
                        ZStack {
                            LinearGradient(gradient: Gradient(colors: [.black.opacity(0.75), .clear, .clear, .clear, .black.opacity(0.75)]), startPoint: .top, endPoint: .bottom)
                            VStack {
                                ReviewListItemHeader(user: user, review: fullReview.review, showLocation: showLocation).padding(.bottom, 4)
                                Spacer()
                            }.padding()
                        }
                        VStack {
                            ReviewPicOverlay(likes: fullReview.likes, reviewId: fullReview.review.id, reloadCallback: reloadCallback)
                            ReviewListItemText(fullReview: self.fullReview)
                                .padding(.bottom.union(.horizontal))
                        }
                    }
                }
            }
        }
    }
}

struct ReviewListItem_Previews: PreviewProvider {
    static func dummyCallback() async {}
    
    static var previews: some View {
        ReviewListItem(reloadCallback: dummyCallback, user: generateUserPreviewData(), fullReview: generateFullReviewPreviewData()).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
    }
}
