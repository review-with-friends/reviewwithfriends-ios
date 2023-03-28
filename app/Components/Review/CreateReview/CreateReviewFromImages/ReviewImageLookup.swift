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
    
    public var locationManager = CLLocationManager()
    
    func setMapLocation() {
        var potentialCoordinate: CLLocationCoordinate2D? = nil
        for selectedImage in selectedImages {
            if let location = selectedImage.exifData {
                potentialCoordinate = location.coordinate
                break
            }
        }
        
        if let coordinate = potentialCoordinate {
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
    
    var body: some View {
        VStack {
            if let location = self.selectedLocation {
                VStack {
                    Text(location.locationName).font(.title.bold())
                }
            }
            if let region = self.region {
                VStack {
                    LocationLookupMapView(selectedLocation: self.$selectedLocation, region: region)
                }.overlay {
                    VStack {
                        HStack {
                            Spacer()
                            HStack {
                                Button(action: {self.showingHelpSheet = true}) {
                                    Image(systemName: "questionmark.circle").padding(8)
                                }.accentColor(.primary)
                            }.background(.black).cornerRadius(25)
                        }.padding()
                        Spacer()
                    }
                }
            }
        }.onAppear {
            self.setupLocationManager()
            self.setMapLocation()
        }.padding(.vertical).sheet(isPresented: self.$showingHelpSheet) {
            ImageLookupHelp().presentationDetents([.medium]).presentationDragIndicator(.visible)
        }
    }
}

struct LocationLookupMapView: UIViewRepresentable {
    @Binding var selectedLocation: UniqueLocation?
    @State var region: MKCoordinateRegion
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: LocationLookupMapView
        
        init(_ parent: LocationLookupMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation){
            guard !annotation.isKind(of: MKUserLocation.self) else {
                return // Don't navigation to user location annotation
            }
            
            mapView.deselectAnnotation(annotation, animated: false)
            if let titleOpt = annotation.title {
                if let title = titleOpt {
                    let category = app.extractCategoryFromAnnotation(annotation: annotation)
                    self.parent.selectedLocation = UniqueLocation(locationName: title, category: category, latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                    
                    let generator = UISelectionFeedbackGenerator()
                    generator.selectionChanged()
                }
            }
        }
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.region = self.region
        
        mapView.selectableMapFeatures = .physicalFeatures.union(.pointsOfInterest).union(.territories)
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        
        let mapConfig = MKStandardMapConfiguration()
        mapConfig.pointOfInterestFilter = .includingAll
        mapView.preferredConfiguration = mapConfig
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) { }
}
