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
                ReviewListItemHeader(user: user, review: fullReview.review, showLocation: showLocation).padding(.bottom, 4)
                if let picId = self.fullReview.review.picId {
                    ReviewPicLoader(picId: picId).overlay {
                        ReviewPicOverlay(likes: fullReview.likes, reviewId: fullReview.review.id, reloadCallback: reloadCallback)
                    }
                }
                ReviewListItemText(fullReview: self.fullReview)
                    .padding(4.0)
            }.padding(4.0)
        }
    }
}

struct ReviewListItem_Previews: PreviewProvider {
    static func dummyCallback() async {}
    
    static var previews: some View {
        ReviewListItem(reloadCallback: dummyCallback, user: generateUserPreviewData(), fullReview: generateFullReviewPreviewData()).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
    }
}
