//
//  PHFetchResultManager.swift
//  app
//
//  Created by Colton Lathrop on 3/19/23.
//

import Foundation
import PhotosUI

class PHFetchResultManager: ObservableObject {
    @Published var fetchResult: PHFetchResult<PHAsset>?
    @Published var totalCount = 0
    
    @Published var assets: [IdentifiablePHAsset] = []
    
    private var page = 0
    private let pageSize = 30
    
    @Published var finished = false
    
    public func assignNewResults(results: PHFetchResult<PHAsset>) {
        DispatchQueue.main.async {
            self.fetchResult = results
            self.totalCount = results.count
            self.finished = false
            self.page = 0
            self.assets = []
            
            self.loadMore()
        }
    }
    
    public func loadMore() {
        if self.finished {
            return
        }
        
        if self.fetchResult == nil {
            return
        }
        
        var pageLow = self.page * pageSize
        var pageHigh = (self.page + 1) * pageSize
        
        if pageLow >= self.totalCount {
            pageLow = self.totalCount - 1
            pageHigh = self.totalCount - 1
        } else if pageHigh >= self.totalCount {
            pageHigh = self.totalCount - 1
        }
        
        if pageHigh >= self.totalCount - 1 {
            self.finished = true
        }
        
        var mappedAssets: [IdentifiablePHAsset] = []
        
        if let result = self.fetchResult {
            if result.count == 0 {
                return
            }
            mappedAssets = result.objects(at: IndexSet(integersIn: pageLow...pageHigh)).map {IdentifiablePHAsset(asset: $0)}
        }
        
        for asset in self.assets {
            mappedAssets.removeAll(where: { mappedAsset in
                asset.id == mappedAsset.id
            })
        }
        
        self.assets.append(contentsOf: mappedAssets)
        self.page += 1
    }
}

class IdentifiablePHAsset: Identifiable {
    var asset: PHAsset
    var id: String
    var selected: Bool = false
    
    init(asset: PHAsset) {
        self.asset = asset
        self.id = asset.localIdentifier
    }
}
