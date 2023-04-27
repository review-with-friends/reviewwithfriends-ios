//
//  mapBoundaryTests.swift
//  appTests
//
//  Created by Colton Lathrop on 1/12/23.
//

import XCTest
@testable import app

final class mapBoundaryTests: XCTestCase {
    func testBoundaryManager() throws {
        // Arrange
        let boundaryManager = MapBoundaryManager()
        
        let initialBoundary = MapBoundary(minX: 5, maxX: 10, minY: 2, maxY: 6)
        
        // Act
        
        let (initialCheck, _) = boundaryManager.isBoundaryLoadNeccessary(boundary: initialBoundary)
        
        let (insertUnneccesaryLoad, shouldBeNil) = boundaryManager.isBoundaryLoadNeccessary(boundary: MapBoundary(minX: 6, maxX: 9, minY: 3, maxY: 5))
        
        let (insertNeccessaryLoad, culled) = boundaryManager.isBoundaryLoadNeccessary(boundary: MapBoundary(minX: 1, maxX: 16, minY: 0, maxY: 9))
        
        // Assert
        
        XCTAssert(initialCheck)
        XCTAssert(!insertUnneccesaryLoad)
        XCTAssert(insertNeccessaryLoad)
        XCTAssert(boundaryManager.boundaries.count == 1)
        XCTAssert(culled != nil)
        XCTAssert(shouldBeNil == nil)
    }
    
    func testMapBoundaryOverlap() throws {
        let initialBoundary = MapBoundary(minX: 5, maxX: 10, minY: 2, maxY: 6)
        
        let incomingBoundary = MapBoundary(minX: 5, maxX: 10, minY: 1, maxY: 3)
        
        XCTAssertTrue(initialBoundary.isWithin(boundary: incomingBoundary))
    }
    
    func testMapBoundaryOverlapPrime() throws {
        let initialBoundary = MapBoundary(minX: 5, maxX: 10, minY: 2, maxY: 6)
        
        let incomingBoundary = MapBoundary(minX: 11, maxX: 13, minY: 1, maxY: 3)
        
        XCTAssertTrue(!initialBoundary.isWithin(boundary: incomingBoundary))
    }
    
    func testMapBoundaryContainsPrime() throws {
        let initialBoundary = MapBoundary(minX: 5, maxX: 10, minY: 2, maxY: 6)
        
        let incomingBoundary = MapBoundary(minX: 5, maxX: 10, minY: 1, maxY: 3)
        
        XCTAssertTrue(!initialBoundary.entirelyContains(boundary: incomingBoundary))
    }
    
    func testMapBoundaryContains() throws {
        let initialBoundary = MapBoundary(minX: 5, maxX: 10, minY: 2, maxY: 6)
        
        let incomingBoundary = MapBoundary(minX: 6, maxX: 9, minY: 3, maxY: 4)
        
        XCTAssertTrue(initialBoundary.entirelyContains(boundary: incomingBoundary))
    }
    
    func testMapBoundaryArea() throws {
        XCTAssert(MapBoundary(minX: -4, maxX: -2, minY: -3, maxY: -1).getArea() == 4.0)
    }
}
