//
//  LocationReviewHeader.swift
//  app
//
//  Created by Colton Lathrop on 3/6/23.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation

struct LocationReviewHeader: View {
    @Binding var path: NavigationPath
    
    var locationName: String
    var latitude: Double
    var longitude: Double
    var category: String
    
    var locationManager = CLLocationManager()
    @State var locationDelegate: LocationDelegate?
    @State var distance: Double?
    
    @State var placemark: CLPlacemark?
    @State var showingMapsConfirmation: Bool = false
    @State var installedMapsApps: [(String, URL)] = []
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var bookmarkCache: BookmarkCache
    
    func lookupAddress() {
        let geocoder = CLGeocoder()

        let location = CLLocation(latitude: self.latitude, longitude: self.longitude)

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let _ = error {
                return
            }
            
            if let placemarkList = placemarks {
                if let targetPlacemark = placemarkList.first {
                    self.placemark = targetPlacemark
                }
            }
        }
    }
    
    func updateDistance(location: CLLocation) {
        self.distance = location.distance(from: CLLocation(latitude: self.latitude, longitude: self.longitude)) * 0.000621371
    }
    
    func isBookmarked() -> Bool {
        bookmarkCache.bookmarks.contains(where: { bookmark in
            bookmark.locationName == self.locationName &&
            bookmark.latitude <= self.latitude + 0.001 &&
            bookmark.latitude >= self.latitude - 0.001 &&
            bookmark.longitude <= self.longitude + 0.001 &&
            bookmark.longitude >= self.longitude - 0.001
        })
    }
    
    func toggleBookmarked() async {
        var result: Result<(), RequestError>
        if self.isBookmarked() {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            result = await app.removeBookmark(token: auth.token, cache: self.bookmarkCache, locationName: self.locationName, latitude: self.latitude, longitude: self.longitude)
        } else {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
            result = await app.addBookmark(token: auth.token, cache: self.bookmarkCache, locationName: self.locationName, category: self.category, latitude: self.latitude, longitude: self.longitude)
        }
        
        switch result {
        case .success():
            break
        case .failure(let error):
            print(error)
            break
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(self.locationName).font(.title3.bold())
                    Spacer()
                    if let mkCategory = MKPointOfInterestCategory.getCategory(category: self.category){
                        if let image = mkCategory.getSystemImageString() {
                            Image(systemName: image)
                        }
                    }
                }
                HStack {
                    if let placemark = self.placemark {
                        if let postalAddress = placemark.postalAddress {
                            Text("\(postalAddress.street), \(postalAddress.city), \(postalAddress.state) \(postalAddress.postalCode)").font(.caption).textSelection(.enabled)
                        }
                    }
                    Spacer()
                }
                if let distanceFrom = self.distance {
                    HStack {
                        Text(String(format: "%.2f miles away", distanceFrom)).font(.caption)
                        Spacer()
                    }
                }
                HStack {
                    Spacer()
                    Button(action: {
                        self.path.append(UniqueLocationCreateReview(locationName: self.locationName, category: self.category, latitude: self.latitude, longitude: self.longitude))
                    }) {
                            Image(systemName: "square.and.pencil").foregroundColor(.primary).font(.system(size: 28))
                    }
                    Button(action: {
                        self.showingMapsConfirmation = true
                    }) {
                        Image(systemName: "map.fill").foregroundColor(.primary).font(.system(size: 28))
                    }.padding(.horizontal)
                    Button(action: {
                        Task {
                            await self.toggleBookmarked()
                        }
                    }) {
                        if self.isBookmarked() {
                            Image(systemName: "bookmark.fill").foregroundColor(.yellow).font(.system(size: 28))
                        } else {
                            Image(systemName: "bookmark").foregroundColor(.primary).font(.system(size: 28))
                        }
                    }
                }
            }.padding()
        }.background(APP_BACKGROUND).listRowSeparator(.hidden).cornerRadius(8)
            .onChange(of: self.showingMapsConfirmation){ toggle in
                self.setInstalledApps()
            }.confirmationDialog("Open in maps", isPresented: $showingMapsConfirmation) {
                if let apple = self.installedMapsApps.first {
                    Button(action: {
                        UIApplication.shared.open(apple.1, options: [:], completionHandler: nil)
                    }) {
                        Text(apple.0)
                    }
                }
                if let google = self.installedMapsApps[safe: 1] {
                    Button(action: {
                        UIApplication.shared.open(google.1, options: [:], completionHandler: nil)
                    }) {
                        Text(google.0)
                    }
                }
            }.onAppear {
                self.lookupAddress()
                
                let delegate = LocationDelegate(latitude: self.latitude, longitude: self.longitude, callback: self.updateDistance)
                
                self.locationDelegate = delegate
                
                locationManager.delegate = delegate
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                
                if self.locationManager.authorizationStatus == .notDetermined {
                    self.locationManager.requestWhenInUseAuthorization()
                } else {
                    locationManager.startUpdatingLocation()
                }
            }
    }
    
    func setInstalledApps() {
        let latitude = self.latitude
        let longitude = self.longitude
        
        let appleURL = "http://maps.apple.com/?daddr=\(latitude),\(longitude)"
        let googleURL = "comgooglemaps://?q=\(self.locationName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&center=\(latitude),\(longitude)"
        
        let googleItem = ("Google Maps", URL(string:googleURL)!)
        
        self.installedMapsApps = []
        
        self.installedMapsApps = [("Apple Maps", URL(string:appleURL)!)]
        
        if UIApplication.shared.canOpenURL(googleItem.1) {
            self.installedMapsApps.append(googleItem)
        }
    }
}

class LocationDelegate: NSObject, CLLocationManagerDelegate {
    private var latitude: Double
    private var longitude: Double
    private var callback: (CLLocation) -> Void
    
    init(latitude: Double, longitude: Double, callback: @escaping (CLLocation) -> Void) {
        self.latitude = latitude
        self.longitude = longitude
        self.callback = callback
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.callback(location)
        }
    }
}

struct LocationReviewHeader_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            LocationReviewHeader(path: .constant(NavigationPath()), locationName: "Mcdonalds this is a really long", latitude: 20.0, longitude: 44.0, category: "restaurant").preferredColorScheme(.dark)
        }
    }
}
