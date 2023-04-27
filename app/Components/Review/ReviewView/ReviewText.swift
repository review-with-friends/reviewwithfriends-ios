//
//  ReviewText.swift
//  app
//
//  Created by Colton Lathrop on 1/4/23.
//

import Foundation
import SwiftUI

struct ReviewText: View {
    @Binding var path: NavigationPath
    
    var fullReview: FullReview
    var reloadCallback: () async -> Void
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var feedRefreshManager: FeedRefreshManager
    
    func isAlreadyFavorited() -> Bool {
        return self.fullReview.likes.filter({$0.userId == auth.user?.id ?? ""}).count >= 1
    }
    
    func toggleFavorite() async {
        var result: Result<(), RequestError>
        if self.isAlreadyFavorited() {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            result = await app.unlikeReview(token: auth.token, reviewId: self.fullReview.review.id)
        } else {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
            result = await app.likeReview(token: auth.token, reviewId: self.fullReview.review.id)
        }
        
        switch result {
        case .success():
            feedRefreshManager.push(review_id: self.fullReview.review.id)
            await reloadCallback()
            break
        case .failure(_):
            break
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                ReviewLikedBy(path: self.$path, fullReview: self.fullReview)
                Spacer()
                let alreadyFavorited = self.isAlreadyFavorited()
                Button(action: {
                    Task {
                        await self.toggleFavorite()
                    }
                }){
                    if alreadyFavorited {
                        Image(systemName: "heart.fill").foregroundColor(.red).font(.system(size: 28))
                    } else {
                        Image(systemName: "heart").foregroundColor(.primary).font(.system(size: 28))
                    }
                }
            }.padding(.bottom, 12)
            HStack {
                Text(self.fullReview.review.text)
                Spacer()
            }
        }.padding(8)
    }
}

struct ReviewText_Preview: PreviewProvider {
    static func callback() -> Void {}
    
    static var previews: some View {
        VStack{
            ReviewText(path: .constant(NavigationPath()), fullReview: generateFullReviewPreviewData(), reloadCallback: callback)
                .preferredColorScheme(.dark)
                .environmentObject(Authentication.initPreview())
                .environmentObject(UserCache())
        }
    }
}

