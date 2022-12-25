//
//  LocationOverlayView.swift
//  bout
//
//  Created by Colton Lathrop on 12/13/22.
//

import Foundation
import SwiftUI
import MapKit

struct LocationOverlayView: View {
    var location_name: String
    var latitude: Double
    var longitude: Double
    
    @State var loading = true
    @State var failed = false
    @State var error = ""
    @State var reviews: [Review] = []
    
    @EnvironmentObject var auth: Authentication
    
    func loadReviews() async {
        self.loading = true
        self.resetError()
        
        let reviews_res = await bout.getReviewsForLocation(token: auth.token, location_name: self.location_name, latitude: self.latitude, longitude: self.longitude)
        
        switch reviews_res {
        case .success(let reviews):
            self.reviews = reviews
        case .failure(let error):
            self.setError(error: error.description)
        }
        
        self.loading = false
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
            if self.loading {
                Text("Loading")
            } else if self.failed {
                Text(self.error)
                Button(action: {}){
                    Text("Retry Loading")
                }
            } else {
                ReviewListView(reviews: $reviews)
            }
        }.task {
            await self.loadReviews()
        }
    }
}
