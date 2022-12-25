//
//  ReviewHeader.swift
//  bout
//
//  Created by Colton Lathrop on 12/20/22.
//

import Foundation
import SwiftUI

struct ReviewHeader: View {
    
    var user: User
    var review: Review
    
    @EnvironmentObject var auth: Authentication
    
    var body: some View {
        HStack{
            VStack{
                ProfilePicLoader(token: auth.token, userId: user.id, picSize: .medium)
            }
            VStack {
                HStack {
                    Text(user.displayName).lineLimit(1)
                    SlimDate(date: self.review.created)
                    Spacer()
                    ReviewStars(stars: self.review.stars)
                }
                HStack {
                    Image(systemName:"mappin.and.ellipse").foregroundColor(.secondary).font(.caption)
                    Text(review.locationName).font(.caption).foregroundColor(.secondary).lineLimit(1)
                    Spacer()
                }
            }.padding(.leading, 4.0)
        }.padding(.bottom, 4.0)
    }
}

struct ReviewHeader_Preview: PreviewProvider {
    static var previews: some View {
        ReviewHeader(user: generateUserPreviewData(), review: generateReviewPreviewData()).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
    }
}
