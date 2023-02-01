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
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        HStack{
            VStack{
                ProfilePicLoader(userId: user.id, profilePicSize: .medium, navigatable: true, ignoreCache: false)
            }
            VStack {
                HStack {
                    SlimDate(date: self.review.created)
                    Spacer()
                    ReviewStars(stars: self.review.stars)
                }
                if showLocation {
                    HStack {
                        Button(action: {
                            self.navigationManager.path.append(UniqueLocation(locationName: review.locationName, category: review.category, latitude: review.latitude, longitude: review.longitude))
                        }) {
                            Image(systemName:"mappin.and.ellipse").foregroundColor(.primary).font(.caption)
                            Text(review.locationName).font(.caption).foregroundColor(.primary).lineLimit(1)
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
                .environmentObject(NavigationManager())
                .environmentObject(UserCache())
            ReviewListItemHeader(user: generateUserPreviewData(), review: generateReviewPreviewData(), showLocation: true)
                .preferredColorScheme(.dark)
                .environmentObject(Authentication.initPreview())
                .environmentObject(UserCache())
                .environmentObject(NavigationManager())
        }
    }
}
