//
//  LatestReviewsView.swift
//  spotster
//
//  Created by Colton Lathrop on 1/5/23.
//

//
//  LocationOverlayView.swift
//  spotster
//
//  Created by Colton Lathrop on 12/13/22.
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
    
    func onItemAppear(review: Review) async {
        guard let index = reviews.firstIndex(of: review) else {
            print("no index")
            return
        }
        
        if reviews.count == 0 {
            print("count == 0")
            return
        }
        
        if noMorePages {
            print("no more pages")
            return
        }
        
        if index >= reviews.count - 1 {
            print("load more")
            await loadReviews()
        }
    }
    
    func loadReviews() async {
        self.loading = true
        self.resetError()
        
        let reviews_res = await spotster.getLatestReviews(token: auth.token, page: nextPage)
        
        switch reviews_res {
        case .success(let reviews):
            if reviews.count == 0 {
                self.noMorePages = true
            }
            print(reviews.count)
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
            LazyVStack {
                ForEach(reviews) { review in
                    ReviewLoader(review: review, showListItem: true, showLocation: true)
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
