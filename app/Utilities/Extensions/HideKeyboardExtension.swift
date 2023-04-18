//
//  HideKeyboardExtension.swift
//  app
//
//  Created by Colton Lathrop on 4/17/23.
//

import Foundation
import SwiftUI

func hideKeyboard() {
    let resign = #selector(UIResponder.resignFirstResponder)
    UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
}
