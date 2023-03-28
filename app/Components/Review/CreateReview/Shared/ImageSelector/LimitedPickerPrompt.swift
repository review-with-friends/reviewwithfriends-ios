//
//  LimitedPickerPrompt.swift
//  app
//
//  Created by Colton Lathrop on 3/19/23.
//

import Foundation
import SwiftUI
import PhotosUI

struct LimitedPicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: uiViewController)
            DispatchQueue.main.async {
                isPresented = false
            }
        }
    }
}
