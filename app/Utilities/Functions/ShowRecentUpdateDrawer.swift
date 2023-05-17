//
//  ShowRecentUpdateDrawer.swift
//  app
//
//  Created by Colton Lathrop on 5/17/23.
//

import Foundation
import SwiftUI

let RECENT_UPDATE_KEY = "1_0_1"

func shouldShowRecentUpdateDrawer() -> Bool {
    var value = AppStorage.init(wrappedValue: false, RECENT_UPDATE_KEY)
    if value.wrappedValue == false {
        value.wrappedValue = true
        value.update()
        return true
    } else {
        return false
    }
}
