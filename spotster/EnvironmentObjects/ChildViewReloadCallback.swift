//
//  ChildViewReloadCallback.swift
//  spotster
//
//  Created by Colton Lathrop on 1/2/23.
//

import Foundation

typealias ReloadCallback = () async -> Void

class ChildViewReloadCallback: ObservableObject {
    @Published var callback: ReloadCallback?
    
    func callIfExists() async  {
        if let callback = self.callback {
            await callback()
        }
    }
    
    init(callback: ReloadCallback?) {
        self.callback = callback
    }
}
