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
    
    /// Gets the system image name for the given category.
    func getSystemImageString() -> String? {
        switch self {
        case MKPointOfInterestCategory.airport:
            return "airplane"
        case MKPointOfInterestCategory.amusementPark:
            return "party.popper.fill"
        case MKPointOfInterestCategory.aquarium:
            return "fish.fill"
        case MKPointOfInterestCategory.atm:
            return "dollarsign"
        case MKPointOfInterestCategory.bakery:
            return "birthday.cake.fill"
        case MKPointOfInterestCategory.bank:
            return "building.columns.fill"
        case MKPointOfInterestCategory.beach:
            return "beach.umbrella.fill"
        case MKPointOfInterestCategory.brewery:
            return "wineglass.fill"
        case MKPointOfInterestCategory.cafe:
            return "cup.and.saucer.fill"
        case MKPointOfInterestCategory.campground:
            return "tent.2.fill"
        case MKPointOfInterestCategory.carRental:
            return "car.rear.fill"
        case MKPointOfInterestCategory.evCharger:
            return "bolt.car.fill"
        case MKPointOfInterestCategory.fireStation:
            return "flame.fill"
        case MKPointOfInterestCategory.fitnessCenter:
            return "dumbbell.fill"
        case MKPointOfInterestCategory.foodMarket:
            return "carrot.fill"
        case MKPointOfInterestCategory.gasStation:
            return "fuelpump.fill"
        case MKPointOfInterestCategory.hospital:
            return "cross.case.fill"
        case MKPointOfInterestCategory.hotel:
            return "suitcase.rolling.fill"
        case MKPointOfInterestCategory.laundry:
            return "tshirt.fill"
        case MKPointOfInterestCategory.marina:
            return "sailboat.fill"
        case MKPointOfInterestCategory.movieTheater:
            return "popcorn.fill"
        case MKPointOfInterestCategory.museum:
            return "building.columns.fill"
        case MKPointOfInterestCategory.nationalPark:
            return "mountain.2.fill"
        case MKPointOfInterestCategory.nightlife:
            return "party.popper.fill"
        case MKPointOfInterestCategory.park:
            return "tree.fill"
        case MKPointOfInterestCategory.parking:
            return "car.2.fill"
        case MKPointOfInterestCategory.pharmacy:
            return "pills.fill"
        case MKPointOfInterestCategory.police:
            return "12.circle.fill"
        case MKPointOfInterestCategory.postOffice:
            return "envelope.fill"
        case MKPointOfInterestCategory.publicTransport:
            return "train.side.rear.car"
        case MKPointOfInterestCategory.restaurant:
            return "fork.knife.circle.fill"
        case MKPointOfInterestCategory.restroom:
            return "toilet.fill"
        case MKPointOfInterestCategory.school:
            return "graduationcap.fill"
        case MKPointOfInterestCategory.stadium:
            return "sportscourt.fill"
        case MKPointOfInterestCategory.store:
            return "cart.fill"
        case MKPointOfInterestCategory.theater:
            return "theatermasks.fill"
        case MKPointOfInterestCategory.university:
            return "graduationcap.fill"
        case MKPointOfInterestCategory.winery:
            return "wineglass.fill"
        case MKPointOfInterestCategory.zoo:
            return "pawprint.fill"
        default:
            // Ideally switches are exhaustive and this isn't needed!
            // But MapKit implemented this a struct, not an enum.
            // Thus we can't rely on an exhaustive switch....
            return nil
        }
    }
    
    static func getCategory(category: String) -> MKPointOfInterestCategory? {
        switch category {
        case "airport":
            return MKPointOfInterestCategory.airport
        case "amusementPark":
            return MKPointOfInterestCategory.amusementPark
        case "aquarium":
            return MKPointOfInterestCategory.aquarium
        case "atm":
            return MKPointOfInterestCategory.atm
        case "bakery":
            return MKPointOfInterestCategory.bakery
        case "bank":
            return MKPointOfInterestCategory.bank
        case "beach":
            return MKPointOfInterestCategory.beach
        case "brewery":
            return MKPointOfInterestCategory.brewery
        case "cafe":
            return MKPointOfInterestCategory.cafe
        case "campground":
            return MKPointOfInterestCategory.campground
        case "carRental":
            return MKPointOfInterestCategory.carRental
        case "evCharger":
            return MKPointOfInterestCategory.evCharger
        case "fireStation":
            return MKPointOfInterestCategory.fireStation
        case "fitnessCenter":
            return MKPointOfInterestCategory.fitnessCenter
        case "foodMarket":
            return MKPointOfInterestCategory.foodMarket
        case "gasStation":
            return MKPointOfInterestCategory.gasStation
        case "hospital":
            return MKPointOfInterestCategory.hospital
        case "hotel":
            return MKPointOfInterestCategory.hotel
        case "laundry":
            return MKPointOfInterestCategory.laundry
        case "marina":
            return MKPointOfInterestCategory.marina
        case "movieTheater":
            return MKPointOfInterestCategory.movieTheater
        case "museum":
            return MKPointOfInterestCategory.museum
        case "nationalPark":
            return MKPointOfInterestCategory.nationalPark
        case "nightlife":
            return MKPointOfInterestCategory.nightlife
        case "park":
            return MKPointOfInterestCategory.park
        case "parking":
            return MKPointOfInterestCategory.parking
        case "pharmacy":
            return MKPointOfInterestCategory.pharmacy
        case "police":
            return MKPointOfInterestCategory.police
        case "postOffice":
            return MKPointOfInterestCategory.postOffice
        case "publicTransport":
            return MKPointOfInterestCategory.publicTransport
        case "restaurant":
            return MKPointOfInterestCategory.restaurant
        case "restroom":
            return MKPointOfInterestCategory.restroom
        case "school":
            return MKPointOfInterestCategory.school
        case "stadium":
            return MKPointOfInterestCategory.stadium
        case "store":
            return MKPointOfInterestCategory.store
        case "theater":
            return MKPointOfInterestCategory.theater
        case "university":
            return MKPointOfInterestCategory.university
        case "winery":
            return MKPointOfInterestCategory.winery
        case "zoo":
            return MKPointOfInterestCategory.zoo
        default:
            // Ideally switches are exhaustive and this isn't needed!
            // But MapKit implemented this a struct, not an enum.
            // Thus we can't rely on an exhaustive switch....
            return nil
        }
    }
    
    static func getCategoryColor(category: String) -> UIColor {
        switch category {
        default:
            // Ideally switches are exhaustive and this isn't needed!
            // But MapKit implemented this a struct, not an enum.
            // Thus we can't rely on an exhaustive switch....
            return UIColor.white
        }
    }
}
