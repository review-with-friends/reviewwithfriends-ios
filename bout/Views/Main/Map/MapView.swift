//
//  MapView.swift
//  bout
//
//  Created by Colton Lathrop on 12/7/22.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    public var mapDelegate =  MapDelegate()
    
    private var showingFriends = false
    
    @EnvironmentObject var overlayManager: OverlayManager
    
    func makeUIView(context: Context) -> MKMapView {
        mapDelegate.setupLocationManager()
        mapDelegate.setupMapView()
        mapDelegate.overlayManager = overlayManager
        
        return mapDelegate.mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // update the map view here, if needed
    }
}

class ReviewAnnotation: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D

    var title: String?

    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String? = nil, subtitle: String? = nil) {
            self.coordinate = coordinate
            self.title = title
            self.subtitle = subtitle
        }
}
