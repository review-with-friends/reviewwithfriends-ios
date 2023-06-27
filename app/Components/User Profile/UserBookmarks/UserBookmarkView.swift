//
//  UserBookmarkView.swift
//  app
//
//  Created by Colton Lathrop on 6/27/23.
//

import Foundation
import SwiftUI


struct UserBookmarkView: View {
    @Binding var path: NavigationPath
    var userId: String
    
    @State var error: String = ""
    @State var failed = false
    
    @State var loading = false
    
    @State var bookmarks: [Bookmark] = []
    
    @State var searchText = ""
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var userCache: UserCache
    @EnvironmentObject var bookmarkCache: BookmarkCache
    
    func loadBookmarks() async {
        self.failed = false
        self.loading = true
        let result = await app.getAllBookmarksForUser(token: self.auth.token, userId: self.userId)
        
        switch result {
            
        case .success(let bookmarks):
            self.bookmarks = bookmarks
        case .failure(_):
            self.failed = true;
        }
        
        self.loading = false
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if loading {
                    ProgressView()
                } else {
                    HStack {
                        TextField("Search", text: $searchText).onChange(of: searchText, perform: { text in
                        }).padding(8)
                    }.background(.quaternary).cornerRadius(8).padding()
                    ForEach(self.bookmarks.filter({ bookmark in
                        bookmark.locationName.lowercased().contains(self.searchText.lowercased()) || self.searchText == ""
                    })) { bookmark in
                        LocationReviewHeader(path: self.$path, locationName: bookmark.locationName, latitude: bookmark.latitude, longitude: bookmark.longitude, category: bookmark.category)
                    }
                    if self.failed {
                        Button(action: {
                            Task {
                                await self.loadBookmarks();
                            }
                        }){
                            VStack {
                                Image(systemName: "xmark.circle").font(.system(size: 48)).foregroundColor(.red)
                                Text("Tap to retry").font(.system(size: 28)).foregroundColor(.secondary)
                            }
                        }
                    } else {
                        VStack {
                            ThatsIt().padding(50)
                        }
                    }
                }
            }
        }.scrollIndicators(.hidden).refreshable {
            Task {
                await self.loadBookmarks();
            }
        }.onAppear {
            Task {
                await self.loadBookmarks();
                await self.bookmarkCache.refresh(token: self.auth.token)
            }
        }.navigationBarTitle("", displayMode: .inline)
    }
}
