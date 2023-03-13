//
//  Locate.swift
//  belocal
//
//  Created by Colton Lathrop on 12/12/22.
//

import Foundation
import SwiftUI
import MapKit

struct LocateButton: View {
    @StateObject var mapDelegate: MapDelegate
    
    var body: some View {
        VStack {
            Button(action: {
                if self.mapDelegate.showingUserLocation {
                    self.mapDelegate.moveMapViewToUserLocation(userLocation: self.mapDelegate.mapView.userLocation, zoom: 1000)
                }
            }){
                VStack{
                    if mapDelegate.showingUserLocation {
                        Image(systemName:"location.fill")
                    } else {
                        Image(systemName:"location")
                    }
                }.padding(.horizontal, 8)
                    .padding(.bottom, 12)
                    .padding(.top, 4)
            }
        }
    }
}
