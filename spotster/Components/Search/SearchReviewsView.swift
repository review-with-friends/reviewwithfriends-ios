//
//  SearchReviewsView.swift
//  spotster
//
//  Created by Colton Lathrop on 2/9/23.
//

import Foundation
import SwiftUI


struct SearchReviewsView: View {
    @Binding var path: NavigationPath
    
    @State var searchText = ""
    
    @State var loading = false
    
    @State var failed = false
    @State var error = ""
    
    @State var nextPage = 0
    @State var noMorePages = false
    @State var reviews: [Review] = []
    
    @State var lastSearch = ""
    
    @EnvironmentObject var auth: Authentication
    
    func onItemAppear(review: Review) async {
        guard let index = reviews.firstIndex(of: review) else {
            return
        }
        
        if reviews.count == 0 {
            return
        }
        
        if noMorePages {
            return
        }
        
        if index >= reviews.count - 1 {
            await loadReviews()
        }
    }
    
    func removeExisting(incomingReviews: [Review]) -> [Review] {
        var incomingReviews = incomingReviews
        for review in self.reviews {
            incomingReviews.removeAll(where: {$0.id == review.id})
        }
        return incomingReviews
    }
    
    func loadReviews() async {
        if self.loading == true {
            return
        }
        
        self.loading = true
        self.resetError()
        
        do {
            try await Task.sleep(for: Duration.milliseconds(750))
        } catch {
            self.loading = false
            return
        }
        
        let lockedSearchText = self.searchText
        
        if lockedSearchText.isEmpty {
            self.reviews = []
            self.loading = false
            return
        }
        
        if lastSearch != lockedSearchText {
            self.nextPage = 0
        }
        
        self.lastSearch = lockedSearchText
        
        let reviews_res = await spotster.searchLatestReviews(token: self.auth.token, searchTerm: lockedSearchText, page: self.nextPage)
        
        switch reviews_res {
        case .success(var reviews):
            if reviews.count == 0 {
                self.noMorePages = true
            }
            
            reviews = removeExisting(incomingReviews: reviews)
            
            self.reviews += reviews
            self.nextPage += 1
        case .failure(let error):
            self.setError(error: error.description)
        }
        
        self.loading = false
    }
    
    func hardLoadReviews() async {
        self.nextPage = 0
        self.reviews = []
        self.noMorePages = false
        
        await self.loadReviews()
    }
    
    func resetError() {
        self.error = ""
        self.failed = false
    }
    
    func setError(error: String) {
        self.error = error
        self.failed = true
    }
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    TextField("Search", text: $searchText).onChange(of: searchText, perform: { text in
                        Task {
                            await self.loadReviews()
                        }
                    })
                    if self.loading {
                        ProgressView()
                    } else {
                        Image(systemName: "magnifyingglass").foregroundColor(.secondary)
                    }
                }.padding(8)
            }.background(.quaternary).cornerRadius(8).padding()
            if self.failed {
                VStack {
                    Spacer()
                    Text(self.error)
                    
                    Button(action: {
                        
                    }){
                        Text("Retry Loading")
                    }
                    Spacer()
                }
            }
            List {
                ForEach(reviews) { review in
                    let reviewDestination = ReviewDestination(id: review.id, userId: review.userId)
                    ReviewLoader(path: self.$path, review: reviewDestination, showListItem: true, showLocation: true)
                        .onAppear {
                            Task {
                                await self.onItemAppear(review: review)
                            }
                        }.buttonStyle(BorderlessButtonStyle())
                }
            }
        }
        .navigationTitle("Search for Locations")
        .navigationBarTitleDisplayMode(.inline)
        .environmentObject(ChildViewReloadCallback(callback: loadReviews))
    }
}
