//
//  RecentUpdateView.swift
//  app
//
//  Created by Colton Lathrop on 5/17/23.
//

import Foundation
import SwiftUI

struct RecentUpdateView: View {
    @Binding var show: Bool
    
    @State var selection = 1
    
    @State private var task: Task<Void, Error>?
    
    func moveNext() {
        withAnimation {
            self.selection += 1
            if self.selection > 3 {
                self.selection = 1
            }
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                switch self.selection {
                case 1:
                    Image("react").resizable().scaledToFit().cornerRadius(28).overlay {
                        VStack {
                            VStack {
                                HStack {
                                    Text("NEW STUFF").fontWeight(.heavy).foregroundColor(.gray).shadow(radius: 4)
                                    Spacer()
                                }
                                HStack {
                                    Text("Reactions").fontWeight(.heavy).font(.title).shadow(radius: 4)
                                    Spacer()
                                }
                                HStack {
                                    Text("Hold press on photos to for reaction menu").fontWeight(.heavy).font(.caption).shadow(radius: 4)
                                    Spacer()
                                }
                            }.padding()
                            Spacer()
                        }
                    }
                case 2:
                    Image("bookmark").resizable().scaledToFit().cornerRadius(28).overlay {
                        VStack {
                            VStack {
                                HStack {
                                    Text("NEW STUFF").fontWeight(.heavy).foregroundColor(.gray).shadow(radius: 4)
                                    Spacer()
                                }
                                HStack {
                                    Text("Bookmarks").fontWeight(.heavy).font(.title).shadow(radius: 4)
                                    Spacer()
                                }
                                HStack {
                                    Text("Use the bookmark button to save places").fontWeight(.heavy).font(.caption).shadow(radius: 4)
                                    Spacer()
                                }
                            }.padding()
                            Spacer()
                        }
                    }
                case 3:
                    Image("recommend").resizable().scaledToFit().cornerRadius(28).overlay {
                        VStack {
                            VStack {
                                HStack {
                                    Text("NEW STUFF").fontWeight(.heavy).foregroundColor(.gray).shadow(radius: 4)
                                    Spacer()
                                }
                                HStack {
                                    Text("Recommends").fontWeight(.heavy).font(.title).shadow(radius: 4)
                                    Spacer()
                                }
                                HStack {
                                    Text("Reviewers can tag reviews as recommended").fontWeight(.heavy).font(.caption).shadow(radius: 4)
                                    Spacer()
                                }
                            }.padding()
                            Spacer()
                        }
                    }
                default:
                    VStack {}
                }
            }.padding(0).onTapGesture {
                self.moveNext()
            }
        }.overlay {
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        Button(action: {
                            withAnimation {
                                hideRecentUpdateDrawer()
                                show = false
                            }
                        }) {
                            Text("CLOSE").fontWeight(.heavy).font(.caption2)
                        }.padding(8).background().accentColor(.primary).cornerRadius(50).shadow(radius: 4)
                    }.padding()
                }
                Spacer()
            }
        }.onAppear {
            self.task = Task {
                while true {
                    try await Task.sleep(for: Duration.seconds(4))
                    self.moveNext()
                }
            }
        }.onDisappear {
            task?.cancel()
        }
    }
}

struct RecentUpdateView_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            RecentUpdateView(show: .constant(true))
        }.preferredColorScheme(.dark)
    }
}
