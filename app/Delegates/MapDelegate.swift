//
//  MapDelegate.swift
//  app
//
//  Created by Colton Lathrop on 12/8/22.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation
import SDWebImageMapKit

class MapDelegate: NSObject, MKMapViewDelegate, CLLocationManagerDelegate, ObservableObject {
    public var mapView = MKMapView()
    public var locationManager = CLLocationManager()
    public var movedToUserLocation = false
    
    var boundaryManager = MapBoundaryManager()
    public var boundaryQueue = MapBoundaryQueue()
    
    public var navigate: ((_: UniqueLocation) -> Void)?
    
    override init() {}
    
    @Published var showingUserLocation = false
    @Published var showUserReviews = false
    
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
        if self.locationManager.authorizationStatus == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func updateLocationState(){
        if self.locationManager.authorizationStatus == .authorizedAlways || self.locationManager.authorizationStatus == .authorizedWhenInUse {
            self.showingUserLocation = true
        }
    }
    
    func mapViewWillStartRenderingMap(_ mapView: MKMapView){
        if self.locationManager.authorizationStatus == .authorizedWhenInUse || self.locationManager.authorizationStatus == .authorizedAlways {
            self.mapView.showsUserLocation = true
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation){
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return // Don't navigation to user location annotation
        }
        
        // Deselect the selected annotation as it's annoying :D
        mapView.deselectAnnotation(annotation, animated: false)
        
        if let titleOpt = annotation.title {
            if let title = titleOpt {
                let category = app.extractCategoryFromAnnotation(annotation: annotation)
                let uniqueLocation = UniqueLocation(locationName: title, category: category, latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                let generator = UISelectionFeedbackGenerator()
                generator.selectionChanged()
                DispatchQueue.main.async {
                    if let navigate = self.navigate {
                        navigate(uniqueLocation)
                    }
                }
            }
        }
    }
    
    /// Moves center to the user location changing. Won't move if we've already done it once.
    /// This is mostly called when the map first loads with Location Access.
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
    
    /// Handles an Annotation being added to create a view.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            // Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize.
            return nil
        }
        
        var annotationView: MKAnnotationView?
        
        if let annotation = annotation as? ReviewAnnotation {
            annotationView = setupReviewAnnotationView(for: annotation, on: mapView)
        }
        
        if let annotation = annotation as? SearchResultAnnotation {
            let markerAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
            
            if let category = annotation.category {
                if let mkCategory = MKPointOfInterestCategory.getCategory(category: category) {
                    if let categorySystemImage = mkCategory.getSystemImageString() {
                        markerAnnotationView.glyphImage = UIImage(systemName: categorySystemImage)
                        markerAnnotationView.glyphTintColor = .black
                        markerAnnotationView.markerTintColor = MKPointOfInterestCategory.getCategoryColor(category: category)
                    }
                }
            }
            
            return markerAnnotationView as MKAnnotationView?
        }
        
        return annotationView
    }
    
    /// Controls how we render the Annotation from the given ReviewAnnotation.
    private func setupReviewAnnotationView(for annotation: ReviewAnnotation, on mapView: MKMapView) -> MKAnnotationView {        
        let view = ReviewAnnotationView(annotation: annotation, reuseIdentifier: nil)
        if let picId = annotation.picId {
            view.photo = "https://bout.sfo3.cdn.digitaloceanspaces.com/" + picId
        }
        
        if let category = annotation.category {
            view.category = category
        }
        view.canShowCallout = true
        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        view.displayPriority = .defaultHigh
        return view
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if self.showUserReviews {
            self.loadAnnotationsForCurrentView(mapView: mapView)
        }
    }
    
    func loadAnnotationsForCurrentView(mapView: MKMapView) {
        let mapBoundary = mapView.region.mapBoundary
        
        let (load, exclusionBoundary) = self.boundaryManager.isBoundaryLoadNeccessary(boundary: mapBoundary)
        
        if load {
            self.boundaryManager.lastLoad = Date.now
            self.boundaryQueue.enqueue(mapBoundary: mapBoundary, boundaryExclusion: exclusionBoundary)
        }
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

func extractCategoryFromAnnotation(annotation: MKAnnotation) -> String {
    if let annotation = annotation as? MKMapFeatureAnnotation {
        if let category = annotation.pointOfInterestCategory {
            return category.getString()
        }
    }
    
    if let annotation = annotation as? SearchResultAnnotation {
        if let category = annotation.category {
            return category
        }
    }
    
    return ""
}
