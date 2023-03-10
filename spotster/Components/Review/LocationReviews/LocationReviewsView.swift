//
//  LocationOverlayView.swift
//  spotster
//
//  Created by Colton Lathrop on 12/13/22.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit

struct LocationReviewsView: View {
    @Binding var path: NavigationPath
    
    var uniqueLocation: UniqueLocation
    
    @State var loading = true
    @State var loaded = false
    @State var failed = false
    @State var error = ""
    @State var reviews: [Review] = []
    
    @EnvironmentObject var auth: Authentication
    
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
                VStack {
                    LocationReviewHeader(path: self.$path, locationName: self.uniqueLocation.locationName, latitude: self.uniqueLocation.latitude, longitude: self.uniqueLocation.longitude, category: self.uniqueLocation.category)
                    if reviews.count >= 1 {
                        List {
                            ForEach(reviews) { review in
                                let reviewDestination = ReviewDestination(id: review.id, userId: review.userId)
                                ReviewLoader(path: self.$path, review: reviewDestination, showListItem: true, showLocation: false)
                                    .padding(.bottom)
                            }
                                .buttonStyle(BorderlessButtonStyle())
                                .refreshable {
                                    Task {
                                        await loadReviews()
                                    }
                                }
                            
                        }.listStyle(.plain)
                    } else {
                        LocationReviewsNoResults()
                    }
                }
            }
        }.onAppear {
            Task {
                await loadReviews()
            }
        }.environmentObject(ChildViewReloadCallback(callback: loadReviews))
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
