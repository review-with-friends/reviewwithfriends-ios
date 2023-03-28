//
//  ViewExtensions.swift
//  app
//
//  Created by Colton Lathrop on 12/27/22.
//

import Foundation
import SwiftUI

public extension View {
    func onFirstAppear(_ action: @escaping () async -> Void) -> some View {
        modifier(FirstAppear(action: action))
    }
}

/// Taken as-is from https://www.swiftjectivec.com/swiftui-run-code-only-once-versus-onappear-or-task/
/// Thanks!
private struct FirstAppear: ViewModifier {
    let action: () async -> Void
    
    // Use this to only fire your block one time
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
        // And then, track it here
        content.task {
            guard !hasAppeared else { return }
            hasAppeared = true
            await action()
        }
    }
}
