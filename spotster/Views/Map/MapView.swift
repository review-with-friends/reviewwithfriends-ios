//
//  MapView.swift
//  spotster
//
//  Created by Colton Lathrop on 12/7/22.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    public var mapDelegate: MapDelegate
    public var path: NavigationPath
    
    private var showingFriends = false
    
    init(path: NavigationPath) {
        self.path = path
        self.mapDelegate = MapDelegate(path: path)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        mapDelegate.setupLocationManager()
        mapDelegate.setupMapView()
        
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
    
    var picId: String?
    
    var category: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String? = nil, subtitle: String? = nil, picId: String?, category: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.picId = picId
        self.category = category
    }
}
