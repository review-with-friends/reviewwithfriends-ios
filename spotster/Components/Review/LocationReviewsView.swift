//
//  LocationOverlayView.swift
//  spotster
//
//  Created by Colton Lathrop on 12/13/22.
//

import Foundation
import SwiftUI

struct LocationReviewsView: View {
    var uniqueLocation: UniqueLocation
    
    @State var loading = true
    @State var loaded = false
    @State var failed = false
    @State var error = ""
    @State var reviews: [Review] = []
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var navigationManager: NavigationManager
    
    func loadReviews() async {
        if !self.loaded {
            self.loading = true
        }
        self.resetError()
        
        let reviews_res = await spotster.getReviewsForLocation(token: auth.token, location_name: self.uniqueLocation.locationName, latitude: self.uniqueLocation.latitude, longitude: self.uniqueLocation.longitude)
        
        switch reviews_res {
        case .success(let reviews):
            withAnimation{
                self.loaded = true
                self.reviews = reviews
            }
        case .failure(let error):
            self.setError(error: error.description)
        }
        
        self.loading = false
    }
    
    func resetError() {
        self.error = ""
        self.failed = false
    }
    
    func setError(error: String) {
        self.error = error
        self.failed = true
    }
    
    func getAverageStars() -> Int {
        if reviews.count == 0 {
            return 0
        }
        
        return reviews.reduce(0) { (result, item) -> Int in
            return result + item.stars
        } / reviews.count
    }
    
    var body: some View {
        VStack {
            if self.loading {
                ProgressView()
            } else if self.failed {
                Text(self.error)
                Button(action: {
                    
                }){
                    Text("Retry Loading")
                }
            } else {
                ScrollView {
                    if reviews.count >= 1 {
                        ForEach(reviews) { review in
                            ReviewLoader(review: review, showListItem: true, showLocation: false).padding(.bottom.union(.horizontal))
                        }
                    } else {
                        Text("No reviews yet.").foregroundColor(.secondary)
                    }
                }.refreshable {
                    Task {
                        await loadReviews()
                    }
                }
            }
        }.toolbar {
            Button(action: {
                self.navigationManager.path.append(UniqueLocationCreateReview(locationName: uniqueLocation.locationName, latitude: uniqueLocation.latitude, longitude: uniqueLocation.longitude))
            }) {
                Image(systemName:"plus.square")
                }
            }.onAppear {
                Task {
                    await loadReviews()
                }
            }.environmentObject(ChildViewReloadCallback(callback: loadReviews)).navigationTitle(uniqueLocation.locationName)
    }
}
