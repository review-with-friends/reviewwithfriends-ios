//
//  MapKitExtensions.swift
//  app
//
//  Created by Colton Lathrop on 1/13/23.
//

import Foundation
import MapKit

extension MKCoordinateRegion {
    var mapBoundary: MapBoundary {
        return MapBoundary(minX: self.center.longitude - (self.span.longitudeDelta / 2.0), maxX: self.center.longitude + (self.span.longitudeDelta / 2.0), minY: self.center.latitude - (self.span.latitudeDelta / 2.0), maxY: self.center.latitude + (self.span.latitudeDelta / 2.0))
    }
}


