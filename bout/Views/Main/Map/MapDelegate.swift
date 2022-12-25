//
//  MapDelegate.swift
//  bout
//
//  Created by Colton Lathrop on 12/8/22.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation

class MapDelegate: NSObject, MKMapViewDelegate, CLLocationManagerDelegate, ObservableObject {
    public var mapView = MKMapView()
    public var locationManager = CLLocationManager()
    public var overlayManager: OverlayManager?
    public var movedToUserLocation = false
    
    @Published var showingUserLocation = false
    
    /// Setup the MapView for rendering.
    /// These settings can be updated at runtime by the delegate or anything that holds a reference to the delegate.
    func setupMapView(){
        mapView.delegate = self
        
        mapView.selectableMapFeatures = .physicalFeatures.union(.pointsOfInterest).union(.territories)
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        
        let mapConfig = MKStandardMapConfiguration()
        mapConfig.pointOfInterestFilter = .includingAll
        mapView.preferredConfiguration = mapConfig
        
        // CLLocationCoordinate2D(latitude: 45.50799861088908, longitude: -122.67417359177271)
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(ReviewAnnotation.self))
        //mapView.addAnnotation(ReviewAnnotation(coordinate: CLLocationCoordinate2D(latitude: 45.50799861088908, longitude: -122.67417359177271), title: "bussy"))
    }
    
    /// Setup the Location Manager.
    /// The Location Manager can be updated by anything with a reference to it.
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func mapViewWillStartRenderingMap(_ mapView: MKMapView){
            if self.locationManager.authorizationStatus == .authorizedWhenInUse || self.locationManager.authorizationStatus == .authorizedAlways {
                    self.mapView.showsUserLocation = true
            }
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation){
        if let manager = overlayManager {
            if let title_opt = annotation.title {
                if let title = title_opt {
                    manager.openOverlay(view: AnyView(LocationOverlayView(location_name: title, latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)))
                }
            }
        }
        // CLLocationCoordinate2D(latitude: 45.50911607691467, longitude: -122.67359334393403)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation){
        if !movedToUserLocation {
            self.moveMapViewToUserLocation(userLocation: userLocation, zoom: 2000)
        }
    }
    
    func moveMapViewToUserLocation(userLocation: MKUserLocation, zoom: CLLocationDistance) {
        let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: zoom, longitudinalMeters: zoom)
        mapView.setRegion(viewRegion, animated: true)
        movedToUserLocation = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else {
            // Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize.
            return nil
        }
        
        var annotationView: MKAnnotationView?
        
        if let annotation = annotation as? ReviewAnnotation {
            annotationView = setupReviewAnnotationView(for: annotation, on: mapView)
        }
        
        return annotationView
    }
    
    private func setupReviewAnnotationView(for annotation: ReviewAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        let reuseIdentifier = NSStringFromClass(ReviewAnnotation.self)
        let flagAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation)
        
        flagAnnotationView.canShowCallout = true
        
        // Provide the annotation view's image.
        let image = UIImage(systemName:"mappin.circle.fill")!
        flagAnnotationView.image = image
        
        // Provide the left image icon for the annotation.
        flagAnnotationView.leftCalloutAccessoryView = UIImageView(image: UIImage(systemName:"house.fill"))
        
        // Offset the flag annotation so that the flag pole rests on the map coordinate.
        let offset = CGPoint(x: image.size.width / 2, y: -(image.size.height / 2) )
        flagAnnotationView.centerOffset = offset
        flagAnnotationView.displayPriority = .defaultHigh
        
        return flagAnnotationView
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
        
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            self.showingUserLocation = true
            self.mapView.showsUserLocation = true
        }
        
        manager.startUpdatingLocation()
    }

}
