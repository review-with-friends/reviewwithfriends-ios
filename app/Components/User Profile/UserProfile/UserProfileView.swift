//
//  UserProfileView.swift
//  app
//
//  Created by Colton Lathrop on 1/30/23.
//

import Foundation
import SwiftUI


struct UserProfileView: View {
    @Binding var path: NavigationPath
    var user: User
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @StateObject var model = PaginatedReviewModel()
    
    @State var showGrid = getCachedGridPreference()
    @State var showReportSheet: Bool = false
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var userCache: UserCache
    @EnvironmentObject var friendsCache: FriendsCache
    
    func createActionCallback(page: Int) async -> Result<[FullReview], RequestError> {
        return await app.getRecommendedReviewsForUser(token: self.auth.token, userId: self.user.id, page: page)
    }
    
    static func getCachedGridPreference() -> Bool {
        let value = AppStorage.init(wrappedValue: false, "GRID_PREFERENCE")
        return value.wrappedValue
    }
    
    func setCachedGridPreference() {
        var value = AppStorage.init(wrappedValue: false, "GRID_PREFERENCE")
        value.wrappedValue = self.showGrid
        value.update()
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if let loggedInUser = self.auth.user {
                    if loggedInUser.id != self.user.id {
                        HStack {
                            Spacer()
                            UserProfileCommandBar(path: self.$path, showReportSheet: self.$showReportSheet, userId: self.user.id)
                        }.padding()
                    } else {
                        HStack {
                            Spacer()
                            IconButton(icon: "square.and.arrow.up.fill", action: {
                                let urlResult = app.generateUniqueUserURL(userId: self.user.id)
                                
                                switch urlResult {
                                case .success(let url):
                                    let AV = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                                    let scenes = UIApplication.shared.connectedScenes
                                    let windowScene = scenes.first as? UIWindowScene
                                    windowScene?.keyWindow?.rootViewController?.present(AV, animated: true, completion: nil)
                                case .failure(_):
                                    return
                                }
                            }).padding(8)
                            IconButton(icon: "person.2.fill", action: {
                                self.path.append(ManageFriendsDestination())
                            }).padding(8).overlay {
                                VStack {
                                    if self.friendsCache.fullFriends.incomingRequests.count > 0 {
                                        VStack {
                                            Circle().foregroundColor(.red).frame(width: 16).overlay {
                                                Text(self.friendsCache.getIncomingFriendRequestCountString()).font(.caption)
                                            }.offset(x: 16, y: -10)
                                        }
                                    }
                                }
                            }
                            IconButton(icon: "gearshape.fill", action: {
                                self.path.append(SettingsDestination())
                            }).padding(8)
                        }.padding()
                    }
                }
                HStack {
                    Spacer()
                    VStack {
                        ProfilePicLoader(path: self.$path, userId: user.id, profilePicSize: .large, navigatable: false, ignoreCache: true)
                        HStack {
                            VStack {
                                Text(user.displayName).padding(4)
                                Text("@" + user.name).font(.caption)
                                    .padding(.bottom)
                                UserActions(path: self.$path, user: user).padding(.bottom)
                            }
                        }
                    }
                    Spacer()
                }
                HStack {
                    SmallPrimaryButton(title: "All Reviews", action: {
                        self.path.append(UserReviewDestination(userId: self.user.id))
                    })
                    SmallPrimaryButton(title: "Bookmarks", action: {
                        self.path.append(UserBookmarksDestination(userId: self.user.id))
                    })
                    Spacer()
                }
                HStack {
                    Text("Recommended:").font(.title2).bold().padding()
                    Spacer()
                }
                if self.friendsCache.areFriends(userId: self.user.id) {
                    ForEach(self.model.reviewsToRender) { review in
                        ReviewLoaderA(path: self.$path, review: review, showListItem: true, showLocation: true)
                    }
                    VStack {
                        if self.model.noMorePages && self.model.reviewsToRender.count == 0 {
                            VStack {
                                Text("\(self.user.displayName) has no recommended places yet.").foregroundColor(.secondary)
                                HStack {
                                    SmallPrimaryButton(title: "See All Reviews", action: {
                                        self.path.append(UserReviewDestination(userId: self.user.id))
                                    })
                                }
                            }.padding()
                        }
                        else if self.model.noMorePages {
                            ThatsIt().padding(50)
                        }
                        else {
                            ProgressView().padding()
                        }
                    }.onAppear {
                        Task {
                            await self.model.onItemAppear(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
                        }
                    }
                }
            }
            if self.model.failed {
                Text(self.model.error)
                
                Button(action: {
                    Task {
                        await self.model.hardLoadReviews(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
                    }
                }){
                    Text("Retry Loading")
                }
            }
        }.scrollIndicators(.hidden).refreshable {
            Task {
                await self.model.hardLoadReviews(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
            }
        }.onAppear {
            Task {
                await self.model.loadReviews(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
                if self.showGrid {
                    await self.model.onItemAppear(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
                }
                // ignore errors here, its fine and best effort
                let _ = await self.friendsCache.refreshFriendsCache(token: self.auth.token)
            }
        }.sheet(isPresented: self.$showReportSheet) {
            ReportUser(showReportSheet: self.$showReportSheet, userId: self.user.id)
                .presentationDetents([.fraction(0.33)])
                .presentationDragIndicator(.visible)
        }.navigationBarTitle("", displayMode: .inline)
    }
}
