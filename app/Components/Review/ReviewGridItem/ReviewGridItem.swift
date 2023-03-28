//
//  ReviewGridItem.swift
//  app
//
//  In honor of Jaleesa Mooney
//
//  Created by Colton Lathrop on 2/14/23.
//

import Foundation
import SwiftUI

struct ReviewGridItem: View {
    @Binding var path: NavigationPath
    @State var fullReview: FullReview
    
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
            Spacer()
            if let pic = self.fullReview.pics.first {
                ReviewPicLoader(path: self.$path, pic: pic).overlay {
                    ZStack {
                        LinearGradient(gradient: Gradient(colors: [.clear, .clear, .clear, .clear, .black.opacity(0.75)]), startPoint: .top, endPoint: .bottom)
                        VStack {
                            Spacer()
                            ReviewGridItemText(fullReview: self.fullReview)
                        }.padding(4)
                    }.background(.black.opacity(0.0001))
                }
                .onTapGesture {
                    let reviewDestination = ReviewDestination(id: fullReview.review.id, userId: fullReview.review.userId)
                    self.path.append(reviewDestination)
                }.buttonStyle(PlainButtonStyle())
            }
            Spacer()
        }
    }
}


struct ReviewGridItemText: View {
    var fullReview: FullReview
    
    @State var animation = 1.0
    
    @EnvironmentObject var auth: Authentication
    
    var body: some View {
        VStack {
            HStack {
                let alreadyLiked = self.fullReview.likes.filter({$0.userId == auth.user?.id ?? ""}).count >= 1
                Label("\(self.fullReview.likes.count)", systemImage: alreadyLiked ? "heart.fill" : "heart").font(.caption).padding(.trailing, 4)
                Label("\(self.fullReview.replies.count)", systemImage: "ellipsis.message.fill").font(.caption)
            }.padding(.top, 1)
        }
    }
}

struct ReviewGridItem_Previews: PreviewProvider {
    static var previews: some View {
        ReviewGridItem(path: .constant(NavigationPath()), fullReview: generateFullReviewPreviewData()).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
    }
}
