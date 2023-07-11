//
//  QRCodeOverlay.swift
//  app
//
//  Created by Colton Lathrop on 7/10/23.
//

import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeOverlay: View {
    let userId: String
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    @State var showQRCode = false;
    
    func generateQRCode(from string: String) -> UIImage {
        if case let .success(url) = app.generateUniqueUserURL(userId: self.userId) {
            filter.message = Data(url.absoluteString.utf8)
            
            if let outputImage = filter.outputImage {
                if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                    return UIImage(cgImage: cgimg)
                }
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack {
                    Button(action: {
                        withAnimation {
                            self.showQRCode = true;
                        }
                    }){
                        Image(systemName: "qrcode").font(.title).padding(8.0)
                    }.accentColor(.black)
                }.background(.primary).cornerRadius(50.0).padding(8.0)
            }
        }.overlay {
            VStack {
                if self.showQRCode {
                    Image(uiImage: self.generateQRCode(from: self.userId))
                        .resizable()
                        .interpolation(.none)
                        .scaledToFill()
                        .padding()
                    PrimaryButton(title: "Dismiss", action: {
                        withAnimation {
                            self.showQRCode = false;
                        }
                    }).padding(.bottom)
                }
            }.background(APP_BACKGROUND).cornerRadius(16.0)
        }
    }
}
