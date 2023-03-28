//
//  FeedForceRefreshManager.swift
//  app
//
//  Created by Colton Lathrop on 3/28/23.
//

import Foundation

/// Shared observable for child components to force a feed refresh when needed.
class FeedRefreshManager: ObservableObject {
    private var refreshList: [String] = []
    private var pendingHardReload: Bool = false
    
    /// Essentially tells the feed to hard reload next time it appears.
    func pushHardReload() {
        self.pendingHardReload = true
    }
    
    /// Used to check for a hard reload, and resets the manager if so.
    func popHardReload() -> Bool {
        if self.pendingHardReload {
            self.pendingHardReload = false
            self.refreshList = []
            return true
        } else {
            return false
        }
    }
    
    /// Pushes a review_id on the queue to be refresh when needed.
    func push(review_id: String) {
        if !self.refreshList.contains(where: {id in id == review_id }) {
            self.refreshList.append(review_id)
        }
    }
    
    /// Given a specific id, return true if something was removed from the list
    func pop(review_id: String) -> Bool {
        if self.refreshList.contains(where: {id in id == review_id }) {
            self.refreshList.removeAll(where: {id in id == review_id })
            return true
        } else {
            return false
        }
    }
}
