//
//  MapBoundary.swift
//  spotster
//
//  Created by Colton Lathrop on 1/12/23.
//

import Foundation

struct MapBoundary {
    /// Minimum Latitude for the given MapBoundary
    let minX: Double
    
    /// Max Latitude for the given MapBoundary
    let maxX: Double
    
    /// Minimum Longitude for the given MapBoundary
    let minY: Double
    
    /// Max Longitude for the given MapBoundary
    let maxY: Double
    
    func getArea() -> Double {
        return (self.minX - self.maxX) * (self.minY - self.maxY)
    }
    
    /// Checks if self entirely contains the given MapBoundary
    func entirelyContains(boundary: MapBoundary) -> Bool {
        return boundary.minX >= self.minX && boundary.minY >= self.minY && boundary.maxX <= self.maxX && boundary.maxY <= self.maxY
    }
    
    /// Checks if self is within the passed Boundary on any side
    func isWithin(boundary: MapBoundary) -> Bool {
        return self.isBetweenEitherX(boundary: boundary) && self.isBetweenEitherY(boundary: boundary)
    }
    
    private func isBetweenEitherX(boundary: MapBoundary) -> Bool {
        return ((self.minX >= boundary.minX) && (self.minX <= boundary.maxX)) || ((self.maxX >= boundary.minX) && (self.maxX <= boundary.maxX))
    }
    
    private func isBetweenEitherY(boundary: MapBoundary) -> Bool {
        return ((self.minY >= boundary.minY) && (self.minY <= boundary.maxY)) || ((self.maxY >= boundary.minY) && (self.maxY <= boundary.maxY))
    }
    
}
