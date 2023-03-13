//
//  ReviewLikes.swift
//  belocal
//
//  Created by Colton Lathrop on 12/23/22.
//

import Foundation
import SwiftUI

struct ReviewListItemText: View {
    @Binding var path: NavigationPath
    
    var fullReview: FullReview
    
    @State var animation = 1.0
    
    @EnvironmentObject var auth: Authentication
    
    var body: some View {
        VStack {
            Button(action:{
                let reviewDestination = ReviewDestination(id: fullReview.review.id, userId: fullReview.review.userId)
                self.path.append(reviewDestination)
            }){
                VStack {
                    HStack {
                        Text(self.fullReview.review.text).lineLimit(2).font(.caption)
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .padding(.trailing.union(.leading))
                            .animation(.easeInOut(duration: 0.5), value: 1.0)
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        let alreadyLiked = self.fullReview.likes.filter({$0.userId == auth.user?.id ?? ""}).count >= 1
                        Label("\(self.fullReview.likes.count)", systemImage: alreadyLiked ? "heart.fill" : "heart").font(.callout).padding(.trailing)
                        Label("\(self.fullReview.replies.count)", systemImage: "ellipsis.message.fill").font(.callout).padding(.trailing)
                        if self.fullReview.pics.count > 1 {
                            Label("\(self.fullReview.pics.count)", systemImage: "photo.on.rectangle.angled").font(.callout)
                        }
                        Spacer()
                    }.padding(.top, 1)
                }.background(.black.opacity(0.0001))
            }.buttonStyle(PlainButtonStyle())
        }
    }
}

struct ReviewListItemText_Preview: PreviewProvider {
    static func callback() -> Void {
        
    }
    
    static var previews: some View {
        VStack{
            ReviewListItemText(path: .constant(NavigationPath()), fullReview: generateFullReviewPreviewData()).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
        }
    }
}

