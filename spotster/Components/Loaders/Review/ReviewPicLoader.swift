//
//  ReviewPicLoader.swift
//  spotster
//
//  Created by Colton Lathrop on 12/20/22.
//

import Foundation
import SwiftUI

struct ReviewPicLoader: View {
    let picId: String
    
    @State var reloadHard = false
    
    var body: some View {
        if self.reloadHard {
            ReviewPicSkeleton(loading: true)
        } else {
            AsyncImage(url: URL(string: "https://bout.sfo3.cdn.digitaloceanspaces.com/" + picId), transaction: Transaction(animation: .spring())) { phase in
                if let image = phase.image {
                    image.resizable().scaledToFit().cornerRadius(16).scaleEffect()
                } else if phase.error != nil {
                    Button(action: {
                        Task {
                            self.reloadHard = true
                            
                            do { try await Task.sleep(for: Duration.milliseconds(100)) }
                            catch {}
                            
                            self.reloadHard = false
                        }
                    }){
                        ReviewPicSkeleton(loading: false, error: true)
                    }.accentColor(.primary)
                } else {
                    ReviewPicSkeleton(loading: true)
                }
            }
        }
    }
}
