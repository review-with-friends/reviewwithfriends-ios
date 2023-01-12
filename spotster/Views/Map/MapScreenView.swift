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
    @State private var mapView: MapView
    @State private var showFriendsReviews = false
    @State private var searchText = ""
    
    var navigationManager: NavigationManager
    
    init(navigationManager: NavigationManager) {
        self.mapView = MapView(navigationManager: navigationManager)
        self.navigationManager = navigationManager
    }
    
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
        } else {
            self.mapView.mapDelegate.showUserReviews = false
            // clear annotations
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
            self.applyFilter()
            self.mapView.mapDelegate.updateLocationState()
        }
    }
}


