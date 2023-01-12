//
//  MapBoundaryManager.swift
//  spotster
//
//  Created by Colton Lathrop on 1/12/23.
//

import Foundation
import CoreGraphics


/// Manages an adaptive map boundary store to help MKMapKit MapViews from unneccessarily loading data.
class MapBoundaryManager {
    
    var boundaries: [MapBoundary] = []
    
    /// Reset the manager if neccessary
    func resetManager() {
        self.boundaries = []
    }
    
    /// Takes a target Boundary and returns the boundaries required to fill the gaps.
    func isBoundaryLoadNeccessary(boundary: MapBoundary) -> (Bool, MapBoundary?)
    {
        for existingBoundary in self.boundaries {
            if existingBoundary.entirelyContains(boundary: boundary){
                return (false, nil)
            }
        }
        
        /// Get the largest existing boundary the passed boundary contains
        let culledBoundary = self.getLargestContainingBoundary(boundary: boundary)
        
        /// Make a pass at optimizing out things this new boundary contains
        self.optimizeExistingBoundaries(boundary: boundary)
        
        /// Append this boundary to our list for collapsing later
        self.boundaries.append(boundary)
        return (true, culledBoundary)
    }
    
    /// Collapses the existing boundaries into larger boundaries to optimize boundary calculations.
    func optimizeExistingBoundaries(boundary: MapBoundary) {
        var indexesToRemove: [Int] = []
        
        for (ind, existingBoundary) in self.boundaries.enumerated() {
            if boundary.entirelyContains(boundary: existingBoundary) {
                indexesToRemove.append(ind)
            }
        }
        
        for indx in indexesToRemove {
            self.boundaries.remove(at: indx)
        }
    }
    
    func getLargestContainingBoundary(boundary: MapBoundary) -> MapBoundary? {
        var containedBoundaries: [MapBoundary] = []
        
        for existingBoundary in self.boundaries {
            if boundary.entirelyContains(boundary: existingBoundary) {
                containedBoundaries.append(existingBoundary)
            }
        }
        
        if containedBoundaries.isEmpty {
            return nil
        }
        
        return containedBoundaries.max {a, b in
            a.getArea() < b.getArea()
        }
    }
}
