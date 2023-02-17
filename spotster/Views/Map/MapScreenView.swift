//
//  MapScreenView.swift
//  spotster
//
//  Created by Colton Lathrop on 12/12/22.
//

import Foundation
import SwiftUI
import MapKit

struct MapScreenView: View {
    @Binding var path: NavigationPath
    
    @State var mapView: MapView
    
    @State private var hideDefaultAnnotations = false
    
    @State private var showUserReviewsOnly = false
    
    @State private var showAreaSearchResults = false
    @State private var searchText = ""
    
    @State private var isVisible = false
    
    @State private var userReviewCategory = "none"
    
    @State private var task: Task<Void, Error>?
    
    @EnvironmentObject var auth: Authentication
    
    func updatePath(uniqueLocation: UniqueLocation) {
        self.path.append(uniqueLocation)
    }
    
    func applyFilter() {
        if self.hideDefaultAnnotations {
            self.setMapFilter(.excludingAll)
        } else {
            self.setMapFilter(.includingAll)
        }
    }
    
    func setMapFilter(_ filter: MKPointOfInterestFilter) {
        if let config = self.mapView.mapDelegate.mapView.preferredConfiguration as? MKStandardMapConfiguration {
            config.pointOfInterestFilter = filter
        } else {}
        
        if filter == .excludingAll {
            if self.showUserReviewsOnly {
                self.mapView.mapDelegate.showUserReviews = true
                self.mapView.mapDelegate.boundaryManager.resetManager()
                self.mapView.mapDelegate.loadAnnotationsForCurrentView(mapView: self.mapView.mapDelegate.mapView)
            }
            
            if self.showAreaSearchResults {
                self.mapView.mapDelegate.showUserReviews = false
            }
        } else {
            self.mapView.mapDelegate.showUserReviews = false
            self.mapView.mapDelegate.mapView.removeAnnotations(self.mapView.mapDelegate.mapView.annotations)
        }
    }
    
    func handleSearchRequest(searchText: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = self.searchText
        
        searchRequest.region = self.mapView.mapDelegate.mapView.region
        
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { (response, error) in
            guard let response = response else {
                return
            }
            
            self.mapView.mapDelegate.mapView.setRegion(response.boundingRegion, animated: true)
            
            for item in response.mapItems {
                if let name = item.name,
                   let location = item.placemark.location {
                    self.mapView.mapDelegate.mapView.addAnnotation(SearchResultAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), title: name, category: item.pointOfInterestCategory?.getString()))
                }
            }
        }
    }
    
    func submitAreaSearch() {
        self.showAreaSearchResults = true
        self.hideDefaultAnnotations = true
        self.showUserReviewsOnly = false
        self.mapView.mapDelegate.mapView.removeAnnotations(self.mapView.mapDelegate.mapView.annotations)
        
        self.applyFilter()
        self.handleSearchRequest(searchText: self.searchText)
    }
    
    func resetSearchResults() {
        self.showAreaSearchResults = false
        self.hideDefaultAnnotations = false
        self.searchText = ""
        self.mapView.mapDelegate.mapView.removeAnnotations(self.mapView.mapDelegate.mapView.annotations)
        self.applyFilter()
    }
    
    func setUserReviewsOnly() {
        self.showUserReviewsOnly.toggle()
        
        self.searchText = ""
        
        self.showAreaSearchResults = false
        self.hideDefaultAnnotations = showUserReviewsOnly
        if self.showUserReviewsOnly {
            self.mapView.mapDelegate.mapView.removeAnnotations(self.mapView.mapDelegate.mapView.annotations)
        }
        self.applyFilter()
    }
    
    var body: some View {
        ZStack {
            mapView.ignoresSafeArea(.all)
            VStack{
                VStack {
                    HStack {
                        TextField("Search for nearby spots", text: self.$searchText).onSubmit {
                            self.submitAreaSearch()
                        }.padding(.leading, 4)
                        Image(systemName: "magnifyingglass").foregroundColor(.secondary)
                    }.padding(8).background(APP_BACKGROUND).cornerRadius(8).shadow(radius: 3)
                    HStack {
                        Spacer()
                        if self.showAreaSearchResults {
                            HStack {
                                Button(action: {
                                    self.resetSearchResults()
                                }){
                                    Text("Clear").foregroundColor(.secondary)
                                }
                            }.padding(8).background(APP_BACKGROUND).cornerRadius(8).shadow(radius: 3)
                        }
                        if self.showUserReviewsOnly {
                            HStack {
                                Picker("Filter", selection: $userReviewCategory) {
                                    Text("Filter").tag("none")
                                    Text("Food").tag("restaurant")
                                    Text("Coffee").tag("cafe")
                                    Text("Bars").tag("brewery")
                                    Text("Parks").tag("park")
                                    Text("Beaches").tag("beach")
                                }.accentColor(.secondary)
                            }.padding(1).background(APP_BACKGROUND).cornerRadius(8).shadow(radius: 3).onChange(of: self.userReviewCategory) { cat in
                                self.applyFilter()
                                self.mapView.mapDelegate.mapView.removeAnnotations(self.mapView.mapDelegate.mapView.annotations)
                            }
                        }
                    }
                }.padding(.horizontal)
                Spacer()
                HStack {
                    Spacer()
                    VStack {
                        VStack{
                            FriendsOnlyToggle(isOn: $showUserReviewsOnly, callBack: self.setUserReviewsOnly)
                            Rectangle().frame(height: 0.5)
                            LocateButton(mapDelegate: mapView.mapDelegate)
                        }.background(APP_BACKGROUND).frame(alignment: .center).cornerRadius(8).shadow(radius: 4).foregroundColor(.secondary)
                    }.frame(width: 44, height: 144)
                }.padding(.trailing)
            }
        }.onAppear {
            self.isVisible = true
            self.startBackgroundTask()
            
            self.applyFilter()
            self.mapView.mapDelegate.updateLocationState()
            self.mapView.mapDelegate.navigate = self.updatePath
        }.onDisappear {
            self.isVisible = false
            self.stopBackgroundTask()
        }
    }
    
    func startBackgroundTask() {
        self.task = Task {
            while self.isVisible {
                // Perform background task here
                let reviews = await self.mapView.mapDelegate.boundaryQueue.process(token: auth.token)
                
                for review in reviews {
                    if self.userReviewCategory == "none" || self.userReviewCategory == review.category {
                        self.mapView.mapDelegate.mapView.addAnnotation(ReviewAnnotation(coordinate: CLLocationCoordinate2D(latitude: review.latitude, longitude: review.longitude), title: review.locationName, picId: review.picId, category: review.category))
                    }
                }
                
                try await Task.sleep(for: Duration.milliseconds(100)) // wait for 1 second before running the task again
            }
        }
    }
    
    func stopBackgroundTask() {
        task?.cancel()
    }
}


