//
//  ImageAlbumSelector.swift
//  app
//
//  Created by Colton Lathrop on 3/27/23.
//

import Foundation
import SwiftUI
import PhotosUI

struct ImageAlbumSelector: View {
    @Binding var selectedAssetCollection: IdentifiablePHAssetCollection?
    
    @State var availableAssetCollections: [IdentifiablePHAssetCollection] = []
    
    var body: some View {
        VStack {
            Picker("Album", selection: $selectedAssetCollection) {
                ForEach(self.availableAssetCollections) { identifiableAssetCollection in
                    let optionalIdentifiableAssetCollection: IdentifiablePHAssetCollection? = identifiableAssetCollection
                    if let title = identifiableAssetCollection.assetCollection.localizedTitle {
                        Text(title).tag(optionalIdentifiableAssetCollection)
                    }
                }
            }
        }.onAppear {
            let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
            let smartAlbumCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
            
            var collectionsArr: [PHAssetCollection]
            if collections.count > 0 {
                collectionsArr = collections.objects(at: IndexSet(IndexSet(integersIn: 0...collections.count - 1)))
            } else {
                collectionsArr = []
            }
            
            if smartAlbumCollections.count > 0 {
                collectionsArr.append(contentsOf: smartAlbumCollections.objects(at: IndexSet(IndexSet(integersIn: 0...smartAlbumCollections.count - 1))))
            }
            
            self.availableAssetCollections = collectionsArr.map {IdentifiablePHAssetCollection(assetCollection: $0)}
            
            self.selectedAssetCollection = self.availableAssetCollections.first { identifiableAssetCollection in
                identifiableAssetCollection.assetCollection.localizedTitle == "Recents"
            }
        }
    }
}

struct IdentifiablePHAssetCollection: Identifiable, Hashable, Equatable {
    static func == (lhs: IdentifiablePHAssetCollection, rhs: IdentifiablePHAssetCollection) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    var assetCollection: PHAssetCollection
    var id: String
    
    init(assetCollection: PHAssetCollection) {
        self.assetCollection = assetCollection
        self.id = assetCollection.localIdentifier
    }
}

struct ImageAlbumSelector_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            ImageAlbumSelector(selectedAssetCollection: .constant(nil)).preferredColorScheme(.dark)
        }
    }
}
