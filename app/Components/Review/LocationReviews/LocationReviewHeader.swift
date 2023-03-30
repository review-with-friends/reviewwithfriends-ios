//
//  LocationReviewHeader.swift
//  app
//
//  Created by Colton Lathrop on 3/6/23.
//

import Foundation
import SwiftUI
import MapKit

struct LocationReviewHeader: View {
    @Binding var path: NavigationPath
    
    var locationName: String
    var latitude: Double
    var longitude: Double
    var category: String
    
    @State var placemark: CLPlacemark?
    
    @State var showingMapsConfirmation: Bool = false
    @State var installedMapsApps: [(String, URL)] = []
    
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
                HStack {
                    Spacer()
                    SmallPrimaryButton(title: "Review", icon: "square.and.pencil", action: {
                        self.path.append(UniqueLocationCreateReview(locationName: self.locationName, category: self.category, latitude: self.latitude, longitude: self.longitude))
                    })
                    SmallPrimaryButton(title: "Directions", icon: "map.fill", action: {self.showingMapsConfirmation = true})
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

struct LocationReviewHeader_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            LocationReviewHeader(path: .constant(NavigationPath()), locationName: "Mcdonalds this is a really long", latitude: 20.0, longitude: 44.0, category: "restaurant").preferredColorScheme(.dark)
        }
    }
}
