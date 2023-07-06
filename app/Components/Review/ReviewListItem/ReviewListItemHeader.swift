//
//  ReviewListItemHeader.swift
//  app
//
//  Created by Colton Lathrop on 1/4/23.
//

import Foundation
import SwiftUI
import MapKit

struct ReviewListItemHeader: View {
    @Binding var path: NavigationPath
    
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
                ProfilePicLoader(path: self.$path, userId: user.id, profilePicSize: .medium, navigatable: true, ignoreCache: false)
            }
            VStack {
                HStack {
                    ReviewStars(stars: self.review.stars)
                    Spacer()
                    if let mkCategory = MKPointOfInterestCategory.getCategory(category: self.review.category){
                        if let image = mkCategory.getSystemImageString() {
                            Image(systemName: image)
                        }
                    }
                    if self.review.delivered {
                        Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                    }
                    if self.review.recommended {
                        Image(systemName: "star.fill").foregroundColor(.yellow)
                    }
                }
                if showLocation {
                    HStack {
                        Button(action: {
                            self.path.append(UniqueLocation(locationName: review.locationName, category: review.category, latitude: review.latitude, longitude: review.longitude))
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
            ReviewListItemHeader(path: .constant(NavigationPath()), user: generateUserPreviewData(), review: generateReviewPreviewData())
                .preferredColorScheme(.dark)
                .environmentObject(Authentication.initPreview())
                .environmentObject(UserCache())
            ReviewListItemHeader(path: .constant(NavigationPath()), user: generateUserPreviewData(), review: generateReviewPreviewData(), showLocation: true)
                .preferredColorScheme(.dark)
                .environmentObject(Authentication.initPreview())
                .environmentObject(UserCache())
        }
    }
}
