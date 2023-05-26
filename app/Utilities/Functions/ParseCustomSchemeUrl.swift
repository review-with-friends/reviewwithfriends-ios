//
//  ParseCustomSchemeUrl.swift
//  app
//
//  Created by Colton Lathrop on 2/6/23.
//

import Foundation

enum UrlGenenerationError: Error {
    case FailedToCreateURL
}

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

func generateUniqueLocationURL(uniqueLocation: UniqueLocation) -> Result<URL, UrlGenenerationError> {
    let urlString = "https://reviewwithfriends.com/universal/location/checkout-location?navType=location&locationName=\(uniqueLocation.locationName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")&category=\(uniqueLocation.category.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")&latitude=\(uniqueLocation.latitude)&longitude=\(uniqueLocation.longitude)"
    if let url = URL(string: urlString) {
        return .success(url)
    } else {
        return .failure(UrlGenenerationError.FailedToCreateURL)
    }
}

func getUserIdFromURL(url: URLComponents) -> UniqueUser? {
    guard let userId = url.queryItems?.first(where: { $0.name == "userId" })?.value
        else { return nil }
    
    return UniqueUser(userId: userId)
}

func generateUniqueUserURL(userId: String) -> Result<URL, UrlGenenerationError> {
    let urlString = "https://reviewwithfriends.com/universal/user/add-me?userId=\(userId)&navType=user"
    if let url = URL(string: urlString) {
        return .success(url)
    } else {
        return .failure(UrlGenenerationError.FailedToCreateURL)
    }
}

func getReviewDestinationFromUrl(url: URLComponents) -> ReviewDestination? {
    guard let id = url.queryItems?.first(where: { $0.name == "id" })?.value
        else { return nil }
    
    guard let userId = url.queryItems?.first(where: { $0.name == "userId" })?.value
        else { return nil }
    
    return ReviewDestination(id: id, userId: userId)
}
