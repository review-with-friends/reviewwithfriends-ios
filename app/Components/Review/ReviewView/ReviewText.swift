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
            await reloadCallback()
            break
        case .failure(_):
            break
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                let alreadyFavorited = self.isAlreadyFavorited()
                SmallPrimaryButton(title:"\(self.fullReview.likes.count)", icon: "heart", action: {
                    self.path.append(self.fullReview.likes)
                })
                SmallPrimaryButton(title: alreadyFavorited ? "Favorited" : "Favorite", icon: alreadyFavorited ? "heart.fill" : "heart", action: {
                    Task {
                        await self.toggleFavorite()
                    }
                })
            }.padding(.bottom, 12)
            HStack {
                Text(self.fullReview.review.text)
                Spacer()
            }
        }
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

