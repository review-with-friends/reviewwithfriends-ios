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
    
    @State var showingMapsConfirmation = false
    
    @State var installedMapsApps: [(String, URL)] = []
    
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
    
    func setInstalledApps() {
        let latitude = self.uniqueLocation.latitude
        let longitude = self.uniqueLocation.longitude
        
        let appleURL = "http://maps.apple.com/?daddr=\(latitude),\(longitude)"
        let googleURL = "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving"
        
        let googleItem = ("Google Maps", URL(string:googleURL)!)
        
        self.installedMapsApps = []
        
        self.installedMapsApps = [("Apple Maps", URL(string:appleURL)!)]
        
        if UIApplication.shared.canOpenURL(googleItem.1) {
            self.installedMapsApps.append(googleItem)
        }
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
                List {
                    VStack {
                        Text(uniqueLocation.locationName).font(.largeTitle)
                        HStack {
                            Spacer()
                            Button(action: {
                                self.showingMapsConfirmation = true
                            }) {
                                Image(systemName:"map.fill").font(.title)
                            }
                        }.padding()
                    }
                    if reviews.count >= 1 {
                        ForEach(reviews) { review in
                            let reviewDestination = ReviewDestination(id: review.id, userId: review.userId)
                            ReviewLoader(path: self.$path, review: reviewDestination, showListItem: true, showLocation: false)
                                .padding(.bottom)
                        }
                    } else {
                        Text("No reviews yet.").foregroundColor(.secondary)
                    }
                }.listStyle(.plain)
                    .buttonStyle(BorderlessButtonStyle())
                    .refreshable {
                        Task {
                            await loadReviews()
                        }
                    }.onChange(of: self.showingMapsConfirmation){ toggle in
                        self.setInstalledApps()
                    }.confirmationDialog("Open in maps", isPresented: $showingMapsConfirmation) {
                        if let apple = self.installedMapsApps.first {
                            Button(action: {
                                UIApplication.shared.open(apple.1, options: [:], completionHandler: nil)
                            }) {
                                Text(apple.0)
                            }
                        }
                        if let google = self.installedMapsApps[safe: 1] {
                            Button(action: {
                                UIApplication.shared.open(google.1, options: [:], completionHandler: nil)
                            }) {
                                Text(google.0)
                            }
                        }
                    }
            }
        }.toolbar {
            Button(action: {
                self.path.append(UniqueLocationCreateReview(locationName: uniqueLocation.locationName, category: uniqueLocation.category, latitude: uniqueLocation.latitude, longitude: uniqueLocation.longitude))
            }) {
                HStack {
                    Image(systemName:"plus.square")
                    Text("Review This Spot")
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
