//
//  LocationOverlayView.swift
//  app
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
        
        let reviews_res = await app.getReviewsForLocation(token: auth.token, location_name: self.uniqueLocation.locationName, latitude: self.uniqueLocation.latitude, longitude: self.uniqueLocation.longitude)
        
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
                    LocationReviewHeader(path: self.$path, locationName: self.uniqueLocation.locationName, latitude: self.uniqueLocation.latitude, longitude: self.uniqueLocation.longitude, category: self.uniqueLocation.category, linkToReviewsPage: false).toolbar {
                        Button(action: {
                            let urlResult = app.generateUniqueLocationURL(uniqueLocation: self.uniqueLocation)
                            
                            switch urlResult {
                            case .success(let url):
                                let AV = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                                let scenes = UIApplication.shared.connectedScenes
                                let windowScene = scenes.first as? UIWindowScene
                                windowScene?.keyWindow?.rootViewController?.present(AV, animated: true, completion: nil)
                            case .failure(_):
                                return
                            }
                        }) {
                            Image(systemName: "square.and.arrow.up")
                        }.accentColor(.primary)
                    }
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
                        NoReviewsYet().listRowSeparator(.hidden)
                        Spacer()
                    }
                }
            }
        }.onAppear {
            Task {
                await loadReviews()
            }
        }.environmentObject(ChildViewReloadCallback(callback: loadReviews)).navigationBarTitle("", displayMode: .inline)
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
