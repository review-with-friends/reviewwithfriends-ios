//
//  ReviewLikes.swift
//  bout
//
//  Created by Colton Lathrop on 12/23/22.
//

import Foundation
import SwiftUI

struct ReviewText: View {
    var fullReview: FullReview
    var expanded: Bool
    var callback: () -> Void
    
    func makeReplyText() -> String {
        if self.fullReview.replies.count == 1 {
            return String(fullReview.replies.count) + " reply"
        }
        
        if self.fullReview.replies.count == 0 {
            return "no replies"
        }
        
        return String(fullReview.replies.count) + " replies"
    }
    
    var body: some View {
        if expanded {
            VStack {
                HStack{
                    Text(self.fullReview.review.text).font(.caption)
                    Spacer()
                    Button(action: {
                        withAnimation {
                            callback()
                        }
                    }){
                        Image(systemName: "chevron.compact.up")
                            .padding(.trailing.union(.leading))
                            .font(.title)
                            .animation(.easeInOut(duration: 0.5), value: 1.0)
                    }.foregroundColor(.primary)
                }
            }
        } else {
            VStack {
                HStack{
                    Text(self.fullReview.review.text).lineLimit(2).font(.caption)
                    Spacer()
                    Button(action: {
                        withAnimation {
                            callback()
                        }
                    }){
                        Image(systemName: "chevron.compact.down")
                            .padding(.trailing.union(.leading))
                            .font(.title)
                            .animation(.easeInOut(duration: 0.5), value: 1.0)
                    }.foregroundColor(.primary)
                }
                HStack {
                    Text(makeReplyText()).font(.caption).foregroundColor(.secondary)
                    Spacer()
                }
            }
        }
    }
}

struct ReviewText_Preview: PreviewProvider {
    static func callback() -> Void {
        
    }
    
    static var previews: some View {
        VStack{
            Spacer()
            ReviewText(fullReview: generateFullReviewPreviewData(), expanded: false, callback: callback
            ).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
            Spacer()
            ReviewText(fullReview: generateFullReviewPreviewData(), expanded: true, callback: callback
            ).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
            Spacer()
        }
    }
}
