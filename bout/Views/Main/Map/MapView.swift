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

struct MapView: View{

    @State var tracking : MapUserTrackingMode = .follow

    @State var manager = CLLocationManager()

    @StateObject var managerDelegate = locationDelegate()

    var body: some View {
        VStack{
            Map(coordinateRegion: $managerDelegate.region, interactionModes: .all, showsUserLocation: true, userTrackingMode: $tracking, annotationItems: managerDelegate.pins) { pin in
                MapMarker(coordinate: pin.location.coordinate)

            }.edgesIgnoringSafeArea(.all)
        }.onAppear{
            manager.delegate = managerDelegate
        }
    }
}

class locationDelegate: NSObject,ObservableObject,CLLocationManagerDelegate{
    @Published var pins : [Pin] = []

    // From here and down is new
    @Published var location: CLLocation?

    @State var hasSetRegion = false

    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 38.898150, longitude: -77.034340),
        span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
    )

    // Checking authorization status...

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

        if manager.authorizationStatus == .authorizedWhenInUse{
            print("Authorized")
            manager.startUpdatingLocation()
        } else {
            print("not authorized")
            manager.requestWhenInUseAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // pins.append(Pin(location:locations.last!))

        // From here and down is new
        if let location = locations.last {

            self.location = location

            if hasSetRegion == false{
                region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
                hasSetRegion = true
            }
        }
    }
}

// Map pins for update
struct Pin : Identifiable {
    var id = UUID().uuidString
    var location : CLLocation
}
