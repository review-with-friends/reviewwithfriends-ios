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
    //var navigationManager: NavigationManager
    
    @State var mapView: MapView
    @State private var showFriendsReviews = false
    @State private var searchText = ""
    
    @State private var isVisible = false
    
    @State private var task: Task<Void, Error>?
    
    @EnvironmentObject var auth: Authentication
    
    func applyFilter() {
        if self.showFriendsReviews {
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
            self.mapView.mapDelegate.showUserReviews = true
            self.mapView.mapDelegate.boundaryManager.resetManager()
            self.mapView.mapDelegate.loadAnnotationsForCurrentView(mapView: self.mapView.mapDelegate.mapView)
        } else {
            self.mapView.mapDelegate.showUserReviews = false
            self.mapView.mapDelegate.mapView.removeAnnotations(self.mapView.mapDelegate.mapView.annotations)
        }
    }
    
    var body: some View {
        ZStack {
            mapView.ignoresSafeArea(.all)
            VStack{
                HStack {
                    Spacer()
                    VStack {
                        VStack{
                            FriendsOnlyToggle(isOn: $showFriendsReviews).onChange(of: showFriendsReviews) { showFriends in
                                self.applyFilter()
                            }
                            Rectangle().frame(height: 1)
                            LocateButton(mapDelegate: mapView.mapDelegate)
                        }.background(.thinMaterial).frame(alignment: .center).cornerRadius(8).shadow(radius: 4).foregroundColor(.secondary)
                    }.frame(width: 44, height: 144)
                }.padding(.trailing)
                Spacer()
            }
        }.onAppear {
            self.isVisible = true
            self.startBackgroundTask()
            
            self.applyFilter()
            self.mapView.mapDelegate.updateLocationState()
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
                        self.mapView.mapDelegate.mapView.addAnnotation(ReviewAnnotation(coordinate: CLLocationCoordinate2D(latitude: review.latitude, longitude: review.longitude), title: review.locationName, picId: review.picId))
                    }

                    try await Task.sleep(for: Duration.milliseconds(100)) // wait for 1 second before running the task again
                }
        }
    }

    func stopBackgroundTask() {
        task?.cancel()
    }
}


