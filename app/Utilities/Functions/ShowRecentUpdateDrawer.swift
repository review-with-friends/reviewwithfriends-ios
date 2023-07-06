//
//  ShowRecentUpdateDrawer.swift
//  app
//
//  Created by Colton Lathrop on 5/17/23.
//

import Foundation
import SwiftUI

let RECENT_UPDATE_KEY = "1_0_2"

func shouldShowRecentUpdateDrawer() -> Bool {
    let value = AppStorage.init(wrappedValue: true, RECENT_UPDATE_KEY)
    return value.wrappedValue
}

func hideRecentUpdateDrawer() {
    var value = AppStorage.init(wrappedValue: true, RECENT_UPDATE_KEY)
    value.wrappedValue = false
    value.update()
}

func showRecentUpdateDrawer() {
    var value = AppStorage.init(wrappedValue: true, RECENT_UPDATE_KEY)
    value.wrappedValue = true
    value.update()
}
