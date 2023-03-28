//
//  DeeplinkNavigationQueue.swift
//  app
//
//  Created by Colton Lathrop on 3/14/23.
//

import Foundation
import SwiftUI

struct DeeplinkTarget: Hashable {
    var id: String
    var type: DeeplinkTargetType
}

enum DeeplinkTargetType {
    case Review
    case User
}
