//
//  ReviewLikes.swift
//  spotster
//
//  Created by Colton Lathrop on 12/23/22.
//

import Foundation
import SwiftUI

struct ReviewListItemText: View {
    @Binding var path: NavigationPath
    
    var fullReview: FullReview
    
    @State var animation = 1.0
    
    func makeReplyText() -> String {
        if self.fullReview.replies.count == 1 {
            return String(fullReview.replies.count) + " Reply"
        }
        
        if self.fullReview.replies.count == 0 {
            return "No Replies"
        }
        
        return String(fullReview.replies.count) + " Replies"
    }
    
    func makeLikeText() -> String {
        if self.fullReview.likes.count == 1 {
            return String(fullReview.likes.count) + " Like"
        }
        
        if self.fullReview.likes.count == 0 {
            return "No Likes"
        }
        
        return String(fullReview.likes.count) + " Likes"
    }
    
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
                        Text(makeReplyText()).font(.caption).foregroundColor(.secondary).padding(.top, 1)
                        Text(makeLikeText()).font(.caption).foregroundColor(.secondary).padding(.top, 1)
                        Spacer()
                    }
                }.background(.black.opacity(0.01))
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

