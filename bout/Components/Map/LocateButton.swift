//
//  Locate.swift
//  bout
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
                if mapDelegate.showingUserLocation {
                    Image(systemName:"location.fill.viewfinder").resizable()
                } else {
                    Image(systemName:"location.viewfinder").resizable()
                }
            }.foregroundColor(.blue)
        }.frame(width: 36.0, height: 36.0)
    }
}

struct LocateButton_Previews: PreviewProvider {
    static var previews: some View {
        LocateButton(mapDelegate: MapDelegate()).preferredColorScheme(.dark)
    }
}
