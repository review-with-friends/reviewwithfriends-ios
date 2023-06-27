//
//  BookmarkCache.swift
//  app
//
//  Created by Colton Lathrop on 6/27/23.
//

import Foundation

@MainActor
class BookmarkCache: ObservableObject {
    @Published var bookmarks: [Bookmark] = []
    @Published var userId: String? = nil
    
    func setAndRefreshCache(token: String, userId: String) async {
        self.userId = userId
        await self.refresh(token: token)
    }
    
    func refresh(token: String) async {
        if let userId = self.userId {
            let result = await app.getAllBookmarksForUser(token: token, userId: userId)
            
            switch result {
            case .success(let bookmarks):
                self.bookmarks = bookmarks
            case .failure(_):
                break
            }
        }
    }
}
