//
//  ReviewHeader.swift
//  spotster
//
//  Created by Colton Lathrop on 12/20/22.
//

import Foundation
import SwiftUI

struct ReviewHeader: View {
    var user: User
    var review: Review
    var showLocation = true
    
    @State var showDeleteConfirmation = false
    @State var showDeleteError = false
    @State var deleteErrorMessage = ""
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var reloadCallback: ChildViewReloadCallback
    
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
                            self.navigationManager.path.append(UniqueLocation(locationName: review.locationName, category: review.category, latitude: review.latitude, longitude: review.longitude))
                        }) {
                            Image(systemName:"mappin.and.ellipse").foregroundColor(.secondary).font(.caption)
                            Text(review.locationName).font(.caption).foregroundColor(.secondary).lineLimit(1)
                        }
                        Spacer()
                        if let loggedInUser = auth.user {
                            if self.review.userId == loggedInUser.id {
                                Menu {
                                    Button("Edit", action: {})
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
                        presenting: self.review
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
        let result = await spotster.deleteReview(token: self.auth.token, reviewId: self.review.id)
        
        switch result {
        case .success(_):
            await self.reloadCallback.callIfExists()
            self.navigationManager.path.removeLast()
        case .failure(let error):
            self.deleteErrorMessage = error.description
            self.showDeleteError = true
        }
    }
}

struct ReviewHeader_Preview: PreviewProvider {
    static func dummyCallback() async {
        print("reload parent")
    }
    
    static var previews: some View {
        VStack{
            ReviewHeader(user: generateUserPreviewData(), review: generateReviewPreviewData())
                .preferredColorScheme(.dark)
                .environmentObject(Authentication.initPreview())
                .environmentObject(UserCache())
                .environmentObject(ChildViewReloadCallback(callback: dummyCallback))
        }
    }
}
