//
//  LatestReviewsView.swift
//  spotster
//
//  Created by Colton Lathrop on 1/5/23.
//

import Foundation
import SwiftUI

struct LatestReviewsView: View {
    @State var loading = true
    
    @State var failed = false
    @State var error = ""
    
    @State var nextPage = 0
    @State var noMorePages = false
    @State var reviews: [Review] = []
    
    @State var wholeSize: CGSize = .zero
    @State var scrollViewSize: CGSize = .zero
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var notificationManager: NotificationManager
    
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
        self.loading = true
        self.resetError()
        
        let reviews_res = await spotster.getLatestReviews(token: auth.token, page: nextPage)
        
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
        self.navigationManager.recentlyUpdatedReviews.append(contentsOf:self.reviews.prefix(5).map({$0.id}))
        
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
    
    func getAverageStars() -> Int {
        if reviews.count == 0 {
            return 0
        }
        
        return reviews.reduce(0) { (result, item) -> Int in
            return result + item.stars
        } / reviews.count
    }
    
    var body: some View {
        ScrollView {
            HStack {
                Spacer()
                NotificationNavButton()
            }.padding()
            LazyVStack {
                ForEach(reviews) { review in
                    let reviewDestination = ReviewDestination(id: review.id, userId: review.userId)
                    ReviewLoader(review: reviewDestination, showListItem: true, showLocation: true)
                        .padding(.bottom.union(.horizontal))
                        .onAppear {
                            Task {
                                await self.onItemAppear(review: review)
                            }
                        }
                }
            }.listStyle(.plain)
            if self.loading {
                ProgressView()
            }
            if self.failed {
                Text(self.error)
                
                Button(action: {
                    
                }){
                    Text("Retry Loading")
                }
            }
        }.refreshable {
            Task {
                await self.hardLoadReviews()
                await self.notificationManager.getNotifications(token: self.auth.token)
            }
        }
        .onFirstAppear {
            Task {
                await self.loadReviews()
            }
        }
        .environmentObject(ChildViewReloadCallback(callback: loadReviews))
    }
}
