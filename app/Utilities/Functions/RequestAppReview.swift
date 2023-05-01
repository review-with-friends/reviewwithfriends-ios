//
//  RequestAppReview.swift
//  app
//
//  Created by Colton Lathrop on 4/30/23.
//

import Foundation
import SwiftUI
import StoreKit

let REVIEW_REQUEST_KEY = "REVIEW_REQUEST_KEY"

func requestUserAppReview() {
    var value = AppStorage.init(wrappedValue: false, REVIEW_REQUEST_KEY)
    if value.wrappedValue == false {
        value.wrappedValue = true
        value.update()
        if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}
