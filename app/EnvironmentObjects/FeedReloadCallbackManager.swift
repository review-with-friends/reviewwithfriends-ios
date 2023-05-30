//
//  FeedReloadCallbackManager.swift
//  app
//
//  Created by Colton Lathrop on 5/12/23.
//

import Foundation

class FeedReloadCallbackManager: ObservableObject {
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
