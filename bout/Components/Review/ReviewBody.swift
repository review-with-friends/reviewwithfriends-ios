//
//  ReviewBody.swift
//  bout
//
//  Created by Colton Lathrop on 12/23/22.
//

import Foundation
import SwiftUI

struct ReviewBody: View {
    var fullReview: FullReview
    
    @State var expanded = false
    
    func toggleExpand() -> Void {
        self.expanded.toggle()
    }
    
    var body: some View {
        VStack{
            HStack{
                ReviewText(fullReview: self.fullReview, expanded: self.expanded, callback: self.toggleExpand)
            }
            if expanded {
                ReviewReplies(fullReview: fullReview)
            }
        }
    }
}

struct ReviewBody_Preview: PreviewProvider {
    static var previews: some View {
        ReviewBody(fullReview: generateFullReviewPreviewData()).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
    }
}
