//
//  MapDelegate.swift
//  spotster
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
    public var locationManager: CLLocationManager
    public var navigationManager: NavigationManager
    public var movedToUserLocation = false
    
    var boundaryManager = MapBoundaryManager()
    public var boundaryQueue = MapBoundaryQueue()
    
    init(navigationManager: NavigationManager) {
        self.navigationManager = navigationManager
        self.locationManager = CLLocationManager()
    }
    
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
                let category = extractCategoryFromAnnotation(annotation: annotation)
                let uniqueLocation = UniqueLocation(locationName: title, category: category, latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                navigationManager.path.append(uniqueLocation)
            }
        }
    }
    
    func extractCategoryFromAnnotation(annotation: MKAnnotation) -> String {
        if let annotation = annotation as? MKMapFeatureAnnotation {
            if let category = annotation.pointOfInterestCategory {
                return category.getString()
            }
        }
        return ""
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
    
    /// Handles an Annotation being added to create  a view.
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
    
    /// Controls how we render the Annotation from the given ReviewAnnotation.
    private func setupReviewAnnotationView(for annotation: ReviewAnnotation, on mapView: MKMapView) -> MKAnnotationView {        
        let view = ReviewAnnotationView(annotation: annotation, reuseIdentifier: nil)
        if let picId = annotation.picId {
            view.photo = "https://bout.sfo3.cdn.digitaloceanspaces.com/" + picId
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

class ReviewAnnotationView: MKAnnotationView {
    static let reuseId = "quickEventUser"
    var photo: String?
    override var annotation: MKAnnotation? {
        didSet {
            if let ann = annotation as? ReviewAnnotationView {
                self.photo = ann.photo
            }
        }
    }
    
    override var isHidden: Bool {
        didSet {
            if isHidden {
                for subview in subviews {
                    subview.removeFromSuperview()
                }
            }
        }
    }

    let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.layer.cornerRadius = 25.0
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        addSubview(imageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        if let photoURL = photo {
            let url = URL(string: photoURL)
            imageView.sd_setImage(with: url)
        } else {
            imageView.image = nil
        }
    }
}
