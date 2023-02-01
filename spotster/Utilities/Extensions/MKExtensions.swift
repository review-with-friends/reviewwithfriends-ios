//
//  MKMapPointOfInterestCategory.swift
//  spotster
//
//  Created by Colton Lathrop on 2/1/23.
//

import Foundation
import MapKit

extension MKPointOfInterestCategory {
    
    /// Gets the string mapped to the common multi-platform string.
    /// Multi-platform in the sense if google maps calls an airport slightly different,
    /// we just map to this same string.
    ///
    /// We should default to empty always.
    func getString() -> String {
        switch self {
        case MKPointOfInterestCategory.airport:
            return "airport"
        case MKPointOfInterestCategory.amusementPark:
            return "amusementPark"
        case MKPointOfInterestCategory.aquarium:
            return "aquarium"
        case MKPointOfInterestCategory.atm:
            return "atm"
        case MKPointOfInterestCategory.bakery:
            return "bakery"
        case MKPointOfInterestCategory.bank:
            return "bank"
        case MKPointOfInterestCategory.beach:
            return "beach"
        case MKPointOfInterestCategory.brewery:
            return "brewery"
        case MKPointOfInterestCategory.cafe:
            return "cafe"
        case MKPointOfInterestCategory.campground:
            return "campground"
        case MKPointOfInterestCategory.carRental:
            return "carRental"
        case MKPointOfInterestCategory.evCharger:
            return "evCharger"
        case MKPointOfInterestCategory.fireStation:
            return "fireStation"
        case MKPointOfInterestCategory.fitnessCenter:
            return "fitnessCenter"
        case MKPointOfInterestCategory.foodMarket:
            return "foodMarket"
        case MKPointOfInterestCategory.gasStation:
            return "gasStation"
        case MKPointOfInterestCategory.hospital:
            return "hospital"
        case MKPointOfInterestCategory.hotel:
            return "hotel"
        case MKPointOfInterestCategory.laundry:
            return "laundry"
        case MKPointOfInterestCategory.marina:
            return "marina"
        case MKPointOfInterestCategory.movieTheater:
            return "movieTheater"
        case MKPointOfInterestCategory.museum:
            return "museum"
        case MKPointOfInterestCategory.nationalPark:
            return "nationalPark"
        case MKPointOfInterestCategory.nightlife:
            return "nightlife"
        case MKPointOfInterestCategory.park:
            return "park"
        case MKPointOfInterestCategory.parking:
            return "parking"
        case MKPointOfInterestCategory.pharmacy:
            return "pharmacy"
        case MKPointOfInterestCategory.police:
            return "police"
        case MKPointOfInterestCategory.postOffice:
            return "postOffice"
        case MKPointOfInterestCategory.publicTransport:
            return "publicTransport"
        case MKPointOfInterestCategory.restaurant:
            return "restaurant"
        case MKPointOfInterestCategory.restroom:
            return "restroom"
        case MKPointOfInterestCategory.school:
            return "school"
        case MKPointOfInterestCategory.stadium:
            return "stadium"
        case MKPointOfInterestCategory.store:
            return "store"
        case MKPointOfInterestCategory.theater:
            return "theater"
        case MKPointOfInterestCategory.university:
            return "university"
        case MKPointOfInterestCategory.winery:
            return "winery"
        case MKPointOfInterestCategory.zoo:
            return "zoo"
        default:
            // Ideally switches are exhaustive and this isn't needed!
            // But MapKit implemented this a struct, not an enum.
            // Thus we can't rely on an exhaustive switch....
            return ""
        }
    }
}
