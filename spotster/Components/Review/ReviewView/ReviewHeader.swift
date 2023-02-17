//
//  ReviewHeader.swift
//  spotster
//
//  Created by Colton Lathrop on 12/20/22.
//

import Foundation
import SwiftUI

struct ReviewHeader: View {
    @Binding var path: NavigationPath
    
    var user: User
    var fullReview: FullReview
    var showLocation = true
    
    @State var showDeleteConfirmation = false
    @State var showDeleteError = false
    @State var deleteErrorMessage = ""
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var reloadCallback: ChildViewReloadCallback
    
    var body: some View {
        HStack{
            VStack{
                ProfilePicLoader(path: self.$path, userId: user.id, profilePicSize: .medium, navigatable: true, ignoreCache: false)
            }
            VStack {
                HStack {
                    Text(user.displayName).lineLimit(1)
                    SlimDate(date: self.fullReview.review.created)
                    Spacer()
                    ReviewStars(stars: self.fullReview.review.stars)
                }
                if showLocation {
                    HStack {
                        Button(action: {
                            self.path.append(UniqueLocation(locationName: self.fullReview.review.locationName, category: self.fullReview.review.category, latitude: self.fullReview.review.latitude, longitude: self.fullReview.review.longitude))
                        }) {
                            Image(systemName:"mappin.and.ellipse").foregroundColor(.secondary).font(.caption)
                            Text(self.fullReview.review.locationName).font(.caption).foregroundColor(.secondary).lineLimit(1)
                        }
                        Spacer()
                        if let loggedInUser = auth.user {
                            if self.fullReview.review.userId == loggedInUser.id {
                                Menu {
                                    Button("Edit", action: {
                                        self.path.append(EditReviewDestination(fullReview: self.fullReview))
                                    })
                                    Button("Delete", role: .destructive)
                                    {
                                        showDeleteConfirmation = true
                                    }
                                } label: {
                                    Image(systemName: "ellipsis").font(.title)
                                }
                            }
                        }
                    }.alert(
                        "Are you sure you want to delete this review?",
                        isPresented: $showDeleteConfirmation,
                        presenting: self.fullReview.review
                    ) { review in
                        Button(role: .destructive) {
                            Task {
                                await self.deleteReview()
                            }
                        } label: {
                            Text("Delete Review")
                        }
                    }.alert(
                        "Delete Failed. Do you want to retry?",
                        isPresented: $showDeleteError,
                        presenting: self.deleteErrorMessage
                    ) { message in
                        Button("Cancel", role: nil){
                            self.deleteErrorMessage = ""
                        }
                        Button("Retry", role: nil) {
                            Task {
                                await self.deleteReview()
                            }
                        }
                    } message: { message in
                        Text(message)
                    }
                }
            }.padding(.leading, 4.0)
        }.padding(.bottom, 4.0).accentColor(.primary)
    }
    
    func deleteReview() async {
        let result = await spotster.deleteReview(token: self.auth.token, reviewId: self.fullReview.review.id)
        
        switch result {
        case .success(_):
            await self.reloadCallback.callIfExists()
            self.path.removeLast()
        case .failure(let error):
            self.deleteErrorMessage = error.description
            self.showDeleteError = true
        }
    }
}

struct ReviewHeader_Preview: PreviewProvider {
    static func dummyCallback() async {
    }
    
    static var previews: some View {
        VStack{
            ReviewHeader(path: .constant(NavigationPath()), user: generateUserPreviewData(), fullReview: generateFullReviewPreviewData())
                .preferredColorScheme(.dark)
                .environmentObject(Authentication.initPreview())
                .environmentObject(UserCache())
                .environmentObject(ChildViewReloadCallback(callback: dummyCallback))
        }
    }
}
