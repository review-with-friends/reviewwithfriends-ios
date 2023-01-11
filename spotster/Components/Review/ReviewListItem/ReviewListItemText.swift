//
//  ReviewLikes.swift
//  spotster
//
//  Created by Colton Lathrop on 12/23/22.
//

import Foundation
import SwiftUI

struct ReviewListItemText: View {
    var fullReview: FullReview
    
    @State var animation = 1.0
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    func makeReplyText() -> String {
        if self.fullReview.replies.count == 1 {
            return String(fullReview.replies.count) + " reply"
        }
        
        if self.fullReview.replies.count == 0 {
            return "no replies"
        }
        
        return String(fullReview.replies.count) + " replies"
    }
    
    func makeLikeText() -> String {
        if self.fullReview.likes.count == 1 {
            return String(fullReview.likes.count) + " like"
        }
        
        if self.fullReview.likes.count == 0 {
            return "no likes"
        }
        
        return String(fullReview.likes.count) + " likes"
    }
    
    var body: some View {
        VStack {
            Button(action:{
                navigationManager.path.append(fullReview.review)
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
                }
            }.buttonStyle(PlainButtonStyle())
        }
    }
}

struct ReviewListItemText_Preview: PreviewProvider {
    static func callback() -> Void {
        
    }
    
    static var previews: some View {
        VStack{
            ReviewListItemText(fullReview: generateFullReviewPreviewData()).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
        }
    }
}

