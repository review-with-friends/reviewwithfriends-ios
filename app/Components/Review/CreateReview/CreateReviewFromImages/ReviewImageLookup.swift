//
//  ReviewImageLookup.swift
//  app
//
//  Created by Colton Lathrop on 3/16/23.
//

import Foundation
import ImageIO
import SwiftUI
import PhotosUI
import MapKit

struct ReviewImageLookup: View {
    @Binding var selectedImages: [ImageSelection]
    @Binding var selectedLocation: UniqueLocation?
    
    @State private var region: MKCoordinateRegion?
    @State private var showingHelpSheet = false
    @State private var mapView: MKMapView?
    @State private var mapDelegate: ReviewImageLookupMapDelegate?
    @State private var searchText = ""
    
    public var locationManager = CLLocationManager()
    
    func setupMapView() {
        if let region = self.region {
            let mapView = MKMapView()
            
            let delegate = ReviewImageLookupMapDelegate(selectCallback: setLocation)
            mapView.delegate = delegate
            self.mapDelegate = delegate
            
            mapView.region = region
            
            mapView.selectableMapFeatures = .physicalFeatures.union(.pointsOfInterest).union(.territories)
            mapView.isPitchEnabled = false
            mapView.isRotateEnabled = false
            
            let mapConfig = MKStandardMapConfiguration()
            mapConfig.pointOfInterestFilter = .includingAll
            mapView.preferredConfiguration = mapConfig
            
            self.mapView = mapView
        }
    }
    
    func setMapLocation() {
        var potentialCoordinate: CLLocationCoordinate2D? = nil
        for selectedImage in selectedImages {
            if let location = selectedImage.exifData {
                potentialCoordinate = location.coordinate
                break
            }
        }
        
        if let location = self.selectedLocation {
            self.region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: location.latitude,
                                               longitude: location.longitude),
                latitudinalMeters: 200,
                longitudinalMeters: 200
            )
        } else if let coordinate = potentialCoordinate {
            self.region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: coordinate.latitude,
                                               longitude: coordinate.longitude),
                latitudinalMeters: 200,
                longitudinalMeters: 200
            )
        } else {
            if let userLocation = self.locationManager.location {
                self.region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,
                                                   longitude: userLocation.coordinate.longitude),
                    latitudinalMeters: 400,
                    longitudinalMeters: 400
                )
            } else {
                self.region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 45.5152,
                                                   longitude: -122.6784),
                    latitudinalMeters: 10000,
                    longitudinalMeters: 10000
                )
            }
        }
    }
    
    func setupLocationManager(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if self.locationManager.authorizationStatus == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func setLocation(location: UniqueLocation) {
        withAnimation {
            self.selectedLocation = location
        }
    }
    
    func handleSearchRequest(searchText: String) {
        if let mapView = self.mapView {
            mapView.removeAnnotations(mapView.annotations)
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = self.searchText
            
            if let region = self.region {
                searchRequest.region = region
                
                let search = MKLocalSearch(request: searchRequest)
                
                search.start { (response, error) in
                    guard let response = response else {
                        return
                    }
                    mapView.setRegion(response.boundingRegion, animated: true)
                    
                    for item in response.mapItems {
                        if let name = item.name,
                           let location = item.placemark.location {
                            mapView.addAnnotation(SearchResultAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), title: name, category: item.pointOfInterestCategory?.getString()))
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            if let location = self.selectedLocation {
                VStack {
                    Text(location.locationName).font(.title.bold()).lineLimit(1)
                }
            }
            if let mapView = self.mapView {
                VStack {
                    ReviewImageLookupMapView(mapView: mapView).ignoresSafeArea(.all).onTapGesture {
                        app.hideKeyboard()
                    }
                }.overlay {
                    VStack {
                        HStack {
                            HStack {
                                TextField("Search for nearby spots", text: self.$searchText).onSubmit {
                                    self.handleSearchRequest(searchText: self.searchText)
                                }.padding(.leading, 4)
                                Image(systemName: "magnifyingglass").foregroundColor(.secondary)
                            }.padding(8).background(APP_BACKGROUND).cornerRadius(8).shadow(radius: 3)
                            HStack {
                                Button(action: {self.showingHelpSheet = true}) {
                                    Image(systemName: "questionmark.circle").padding(8)
                                }.accentColor(.primary)
                            }.background(APP_BACKGROUND).cornerRadius(25)
                        }.padding()
                        Spacer()
                    }
                }
            }
        }.onAppear {
            self.setupLocationManager()
            self.setMapLocation()
            self.setupMapView()
        }.padding(.vertical).sheet(isPresented: self.$showingHelpSheet) {
            ImageLookupHelp().presentationDetents([.medium]).presentationDragIndicator(.visible)
        }
    }
}

struct ReviewImageLookupMapView: UIViewRepresentable {
    private var mapView: MKMapView

    init(mapView: MKMapView) {
        self.mapView = mapView
    }
    
    func makeUIView(context: Context) -> MKMapView {
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // update the map view here, if needed
    }
}

class ReviewImageLookupMapDelegate: NSObject, MKMapViewDelegate {
    public var selectCallback: (UniqueLocation) -> Void
    
    init(selectCallback: @escaping (UniqueLocation) -> Void) {
        self.selectCallback = selectCallback
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation){
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return // Don't navigation to user location annotation
        }
        
        mapView.deselectAnnotation(annotation, animated: false)
        if let titleOpt = annotation.title {
            if let title = titleOpt {
                let category = app.extractCategoryFromAnnotation(annotation: annotation)
                self.selectCallback(UniqueLocation(locationName: title, category: category, latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude))
                
                let generator = UISelectionFeedbackGenerator()
                generator.selectionChanged()
            }
        }
    }
}

