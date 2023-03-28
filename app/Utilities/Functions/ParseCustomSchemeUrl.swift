//
//  ParseCustomSchemeUrl.swift
//  app
//
//  Created by Colton Lathrop on 2/6/23.
//

import Foundation

/// app://?navType="location"&category="restaurant"&locationName="Dough Zone Dumpling House"&latitude=45.50810561611561&longitude=-122.67250289238291
func getUniqueLocationFromURL(url: URLComponents) -> UniqueLocation? {
    guard let locationName = url.queryItems?.first(where: { $0.name == "locationName" })?.value
        else { return nil }
    
    guard let category = url.queryItems?.first(where: { $0.name == "category" })?.value
        else { return nil }
    
    guard let latitudeString = url.queryItems?.first(where: { $0.name == "latitude" })?.value
        else { return nil }
    
    guard let longitudeString = url.queryItems?.first(where: { $0.name == "longitude" })?.value
        else { return nil }
    
    guard let latitude = Double(latitudeString) else { return nil }
    guard let longitude = Double(longitudeString) else { return nil }
    
    return UniqueLocation(locationName: locationName, category: category, latitude: latitude, longitude: longitude)
}

func getReviewDestinationFromUrl(url: URLComponents) -> ReviewDestination? {
    guard let id = url.queryItems?.first(where: { $0.name == "id" })?.value
        else { return nil }
    
    guard let userId = url.queryItems?.first(where: { $0.name == "userId" })?.value
        else { return nil }
    
    return ReviewDestination(id: id, userId: userId)
}
