//
//  LatestReviewsView.swift
//  app
//
//  Created by Colton Lathrop on 1/5/23.
//

import Foundation
import SwiftUI

struct LatestReviewsView: View {
    @Binding var path: NavigationPath
    
    @StateObject var model = PaginatedReviewModel()
    
    @State var lastLoad = Date()
    @State var showRecentUpdateDrawer = false
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var userCache: UserCache
    @EnvironmentObject var notificationManager: NotificationManager
    @EnvironmentObject var feedRefreshManager: FeedRefreshManager
    @EnvironmentObject var feedReloadCallbackManager: FeedReloadCallbackManager
    
    @Environment(\.scenePhase) var scenePhase
    
    func createActionCallback(page: Int) async -> Result<[FullReview], RequestError> {
        return await app.getLatestFullReviews(token: auth.token, page: page)
    }
    
    func reloadCallback() {
        Task {
            await self.model.hardLoadReviews(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
        }
    }
    
    func showRecentUpdateDrawerIfNeeded() {
        self.showRecentUpdateDrawer = shouldShowRecentUpdateDrawer()
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    if showRecentUpdateDrawer && !self.model.loading {
                        RecentUpdateView(show: self.$showRecentUpdateDrawer)
                    }
                    ForEach(self.model.reviewsToRender) { review in
                        VStack {
                            ReviewLoaderA(path: self.$path, review: review, showListItem: true, showLocation: true)
                        }
                    }
                    VStack {
                        if self.model.noMorePages && self.model.reviews.isEmpty {
                            FeedZeroReviews(path: self.$path)
                        } else if self.model.noMorePages {
                            FeedEndOfReviews()
                        } else if self.model.reviewsToRender.count > 0 {
                            ProgressView().padding()
                        }
                    }.onAppear {
                        Task {
                            await self.model.onItemAppear(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
                        }
                    }
                }.listStyle(.plain).buttonStyle(BorderlessButtonStyle())
            }.scrollIndicators(.hidden)
            
            if self.model.failed {
                Text(self.model.error)
                
                Button(action: {
                    
                }){
                    Text("Retry Loading")
                }
            }
        }.refreshable {
            Task {
                await self.model.hardLoadReviews(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
                await self.notificationManager.getNotifications(token: self.auth.token)
            }
        }.onAppear {
            // set the callback whenever - this is cheap right?
            self.feedReloadCallbackManager.callback = reloadCallback
            self.showRecentUpdateDrawerIfNeeded()
            
            if self.feedRefreshManager.popHardReload() {
                Task {
                    await self.model.hardLoadReviews(auth:self.auth, userCache: self.userCache, action: self.createActionCallback)
                }
            } else {
                Task {
                    /// The model handles loading correctly. Though a byproduct is several tab navigations can lead to loading more pages.
                    await self.model.loadReviews(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
                }
            }
        }.onChange(of: scenePhase) { newPhase in
            /// When opening the app from the background, an active event is fired here.
            /// We hook onto this and check if the last time we loaded data was. If it was recent, we hard refresh.
            if newPhase == .active {
                if self.lastLoad.addingTimeInterval(TimeInterval(300)) < Date() {
                    self.lastLoad = Date()
                    Task {
                        await self.model.hardLoadReviews(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
                    }
                }
            }
        }
    }
}
