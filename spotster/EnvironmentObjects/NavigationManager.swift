//
//  NavigationManager.swift
//  spotster
//
//  Created by Colton Lathrop on 12/25/22.
//

import Foundation
import SwiftUI

class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    
    /// Inspected by loaders to see if their given review need to be hard reloaded onAppear.
    @Published var recentlyUpdatedReviews: [String] = []
}
