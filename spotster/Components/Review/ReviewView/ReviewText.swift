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
    
    @EnvironmentObject var auth: Authentication
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.path.append(fullReview.likes)
                }) {
                    let alreadyLiked = self.fullReview.likes.filter({$0.userId == auth.user?.id ?? ""}).count >= 1
                    Label("\(self.fullReview.likes.count)", systemImage: alreadyLiked ? "heart.fill" : "heart").font(.title3).padding(.trailing)
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
            ReviewText(path: .constant(NavigationPath()), fullReview: generateFullReviewPreviewData())
                .preferredColorScheme(.dark)
                .environmentObject(Authentication.initPreview())
                .environmentObject(UserCache())
        }
    }
}

