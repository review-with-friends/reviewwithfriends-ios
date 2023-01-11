//
//  ReviewListItemHeader.swift
//  spotster
//
//  Created by Colton Lathrop on 1/4/23.
//

import Foundation
import SwiftUI

struct ReviewListItemHeader: View {
    var user: User
    var review: Review
    var showLocation = false
    
    @State var showDeleteConfirmation = false
    @State var showDeleteError = false
    @State var deleteErrorMessage = ""
    
    @EnvironmentObject var auth: Authentication
    
    var body: some View {
        HStack{
            VStack{
                ProfilePicLoader(userId: user.id, profilePicSize: .medium, navigatable: true, ignoreCache: false)
            }
            VStack {
                HStack {
                    Text(user.displayName).lineLimit(1)
                    SlimDate(date: self.review.created)
                    Spacer()
                    ReviewStars(stars: self.review.stars)
                }
                if showLocation {
                    HStack {
                        Button(action: {
                            // take user to location view
                        }) {
                            Image(systemName:"mappin.and.ellipse").foregroundColor(.secondary).font(.caption)
                            Text(review.locationName).font(.caption).foregroundColor(.secondary).lineLimit(1)
                        }
                        Spacer()
                    }
                }
            }.padding(.leading, 4.0)
        }.padding(.bottom, 4.0).accentColor(.primary)
    }
}

struct ReviewListItemHeader_Preview: PreviewProvider {
    static var previews: some View {
        VStack{
            ReviewListItemHeader(user: generateUserPreviewData(), review: generateReviewPreviewData())
                .preferredColorScheme(.dark)
                .environmentObject(Authentication.initPreview())
                .environmentObject(UserCache())
            ReviewListItemHeader(user: generateUserPreviewData(), review: generateReviewPreviewData(), showLocation: true)
                .preferredColorScheme(.dark)
                .environmentObject(Authentication.initPreview())
                .environmentObject(UserCache())
        }
    }
}
