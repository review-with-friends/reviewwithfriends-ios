//
//  ReviewView.swift
//  belocal
//
//  Created by Colton Lathrop on 1/3/23.
//

import Foundation
import SwiftUI

struct ReviewListItem: View {
    @Binding var path: NavigationPath
    
    var reloadCallback: () async -> Void
    var user: User
    @State var fullReview: FullReview
    var showLocation = true
    
    @EnvironmentObject var auth: Authentication
    
    func loadFullReview() async -> Void {
        let fullReviewResult = await getFullReviewById(token: auth.token, reviewId: self.fullReview.review.id)
        
        switch fullReviewResult {
        case .success(let fullReview):
            self.fullReview = fullReview
        case .failure(_):
            return
        }
    }
    
    var body: some View {
        VStack {
            if let pic = self.fullReview.pics.first {
                ReviewPicLoader(path: self.$path, pic: pic).overlay {
                    ZStack {
                        LinearGradient(gradient: Gradient(colors: [.black.opacity(0.75), .clear, .clear, .clear, .black.opacity(0.75)]), startPoint: .top, endPoint: .bottom)
                        VStack {
                            ReviewListItemHeader(path: self.$path, user: user, review: fullReview.review, showLocation: showLocation).padding(.bottom, 4)
                            Spacer()
                            ReviewPicOverlay(path: self.$path, likes: fullReview.likes, reviewId: fullReview.review.id, reloadCallback: self.loadFullReview)
                            ReviewListItemText(path: self.$path, fullReview: self.fullReview)
                        }.padding()
                    }
                }
            }
        }
    }
}

struct ReviewListItem_Previews: PreviewProvider {
    static func dummyCallback() async {}
    
    static var previews: some View {
        ReviewListItem(path: .constant(NavigationPath()),reloadCallback: dummyCallback, user: generateUserPreviewData(), fullReview: generateFullReviewPreviewData()).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
    }
}
