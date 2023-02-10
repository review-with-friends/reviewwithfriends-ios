//
//  ReviewText.swift
//  spotster
//
//  Created by Colton Lathrop on 1/4/23.
//

import Foundation
import SwiftUI

struct ReviewText: View {
    @Binding var path: NavigationPath
    
    var fullReview: FullReview
    
    @State var animation = 1.0
    
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
            HStack {
                Button(action: {
                    self.path.append(fullReview.likes)
                }) {
                    Text(makeLikeText()).foregroundColor(.secondary).padding(.top, 1)
                }.buttonStyle(PlainButtonStyle())
                Spacer()
            }.padding(.bottom, 1)
            HStack {
                Text(self.fullReview.review.text)
                Spacer()
            }
        }
    }
}

struct ReviewText_Preview: PreviewProvider {
    static func callback() -> Void {
        
    }
    
    static var previews: some View {
        VStack{
            ReviewText(path: .constant(NavigationPath()), fullReview: generateFullReviewPreviewData()).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
        }
    }
}

