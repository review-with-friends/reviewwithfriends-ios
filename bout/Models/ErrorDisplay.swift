//
//  Error.swift
//  bout
//
//  Created by Colton Lathrop on 11/29/22.
//

import Foundation
import SwiftUI

class ErrorDisplay : ObservableObject {
    @Published var displayError: Bool
    @Published var errorMessage: String
    
    init() {
        self.displayError = false
        self.errorMessage = ""
    }
    
    func showError(message: String) {
        withAnimation {
            self.displayError = true
            self.errorMessage = message
        }
    }
    
    func closeError() {
        withAnimation {
            self.displayError = false
            self.errorMessage = ""
        }
    }
}
