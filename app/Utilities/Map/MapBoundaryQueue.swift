//
//  MapBoundaryQueue.swift
//  app
//
//  Created by Colton Lathrop on 1/13/23.
//

import Foundation

class MapBoundaryQueue: ObservableObject {
    var queue: [MapBoundaryQueueItem] = []
    @Published var failing = false
    
    func process(token: String) async -> [Review] {
        if let nextItem = self.queue.first {
            var result: Result<[Review], RequestError>
            
            if let exclusionBoundary = nextItem.exclusionBoundary {
                result = await app.getReviewFromBoundaryWithExclusion(token: token, boundary: nextItem.mapBoundary, excludedBoundary: exclusionBoundary, page: nextItem.currentPage)
            } else {
                result = await app.getReviewFromBoundary(token: token, boundary: nextItem.mapBoundary, page: nextItem.currentPage)
            }
            
            switch result {
            case .success(let reviews):
                if reviews.count == 0 {
                    if let index = self.queue.firstIndex(of: nextItem) {
                        self.queue.remove(at: index)
                    }
                }
                
                self.failing = false
                
                nextItem.currentPage += 1
                
                return reviews
            case .failure(_):
                self.failing = true
                return []
            }
        }
        
        return []
    }
    
    func enqueue(mapBoundary: MapBoundary, boundaryExclusion: MapBoundary?) {
        self.queue.append(MapBoundaryQueueItem(mapBoundary: mapBoundary, exclusionBoundary: boundaryExclusion))
    }
}

class MapBoundaryQueueItem: Equatable {
    static func == (lhs: MapBoundaryQueueItem, rhs: MapBoundaryQueueItem) -> Bool {
        lhs.mapBoundary == rhs.mapBoundary
    }
    
    var mapBoundary: MapBoundary
    var exclusionBoundary: MapBoundary?
    var currentPage = 0
    
    init(mapBoundary: MapBoundary, exclusionBoundary: MapBoundary? = nil, currentPage: Int = 0) {
        self.mapBoundary = mapBoundary
        self.exclusionBoundary = exclusionBoundary
        self.currentPage = currentPage
    }
}
