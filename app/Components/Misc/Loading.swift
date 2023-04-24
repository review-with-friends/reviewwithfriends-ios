//
//  Loading.swift
//  app
//
//  Created by Colton Lathrop on 12/6/22.
//

import Foundation
import SwiftUI
import UIKit

struct Loading: View {
    var body: some View {
        ZStack {
            LaunchScreenView().ignoresSafeArea(.all)
        }.ignoresSafeArea(.all)
    }
}

struct LaunchScreenView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: "Launch Screen", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "LaunchScreen")
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Loading().preferredColorScheme(.dark)
        }
    }
}
