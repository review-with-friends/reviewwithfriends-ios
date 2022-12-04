//
//  SetProfilePicView.swift
//  bout
//
//  Created by Colton Lathrop on 12/3/22.
//

import Foundation
import SwiftUI
import PhotosUI


struct SetProfilePicView: View {
    @State var selectedItem: PhotosPickerItem?
    @State var selectedItemData: Data?
    
    @Binding var phase: OnboardingPhase
    
    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var errorDisplay: ErrorDisplay
    
    var body: some View {
        Text("GetStartedView")
        ProfilePicView(getImage: getProfilePic, token: authentication.token, userId: authentication.user?.id ?? "") { image in
          image
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
        } placeholder: {
            Text("PlaceHolder")
        }
        PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()) {
                    Text("Select a photo")
                }.onChange(of: selectedItem) { newItem in
                    Task {
                        // Retrive selected asset in the form of Data
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedItemData = data
                        }
                    }
                }
        if let selectedItemData,
           let uiImage = UIImage(data: selectedItemData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
        }
    }
}

struct SetProfilePicView_Previews: PreviewProvider {
    static var previews: some View {
        SetProfilePicView(phase: .constant(OnboardingPhase.SetNames)).preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
    }
}
