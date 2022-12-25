//
//  MapScreenView.swift
//  bout
//
//  Created by Colton Lathrop on 12/12/22.
//

import Foundation
import SwiftUI
import MapKit

struct MapScreenView: View {
    @State private var mapView = MapView()
    @State private var showPointsOfInterest = true
    @State private var searchText = ""
    
    @EnvironmentObject var overlayManager: OverlayManager
    
    func setMapFilter(_ filter: MKPointOfInterestFilter) {
        if let config = self.mapView.mapDelegate.mapView.preferredConfiguration as? MKStandardMapConfiguration {
            config.pointOfInterestFilter = filter
        } else {
            
        }
    }
    
    var body: some View {
        ZStack {
            mapView.ignoresSafeArea(.all)
            VStack{
                HStack{
                    HStack {
                        VStack{
                            TextField("Search", text: $searchText).padding(.leading, 8.0)
                        }
                        Toggle(isOn: $showPointsOfInterest){}.tint(.blue).padding(.trailing, 8.0).fixedSize().onChange(of: showPointsOfInterest) { showPOI in
                            if showPOI {
                                self.setMapFilter(.includingAll)
                            } else {
                                self.setMapFilter(.excludingAll)
                            }
                        }
                    }.padding(8.0).background(.quaternary)
                }.background().cornerRadius(16.0).padding()
                HStack{
                    Spacer()
                    LocateButton(mapDelegate: mapView.mapDelegate).padding(.trailing, 8.0)
                }.padding(.trailing)
                Spacer()
            }
        }
    }
}

struct MapScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MapScreenView().preferredColorScheme(.dark)
    }
}
