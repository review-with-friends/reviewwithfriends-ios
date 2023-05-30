//
//  AddImagesUploader.swift
//  app
//
//  Created by Colton Lathrop on 5/15/23.
//

import Foundation
import SwiftUI

struct AddImagesUploader: View {
    /// Called when we finish uploading the pics.
    var finishUploadCallback: () -> Void
    
    /// Callback to upload a photo.
    var uploadPhoto: (String, String, Data) async -> Result<(), RequestError>
    
    var reviewId: String
    
    /// Tracks which photos have uploaded. Essentially a queue, but instead of just removing, we move to the already uploaded
    /// This is expected to be by-value so we manage our state independently of the selected.
    @State var imagesToUpload: [ImageSelection]
    
    /// Images we have already uploaded.
    @State var imagesAlreadyUploaded: [ImageSelection] = []
    
    /// The stage of uploading the review we are in.
    @State var uploadState: UploadStage = .Photos
    
    @EnvironmentObject var auth: Authentication
    
    /// Gets the percent of files done in a given instant.
    func getUploadPercent() -> Double {
        return Double(self.imagesAlreadyUploaded.count) / (Double(self.imagesToUpload.count) + Double(self.imagesAlreadyUploaded.count))
    }
    
    func processPhotos() async {
        // Loop through our state machine
        while self.uploadState != .Failed {
            // if we are in the state to keep trying for photos
            // and we actually have photos still
            if self.uploadState == .Photos && self.imagesToUpload.count > 0 {
                // pull out the first photos
                if let selectedImage = self.imagesToUpload.first {
                    // convert it, this should work
                    if let data = selectedImage.image.jpegData(compressionQuality: 0.9) {
                        // try to upload via the provided uploadPhoto function
                        let result = await self.uploadPhoto(auth.token, self.reviewId, data)
                        
                        switch result {
                        case .success(_):
                            // on success, we move the photo to the already uploaded list
                            imagesAlreadyUploaded.append(selectedImage)
                            // on success, remove it from the to upload list
                            imagesToUpload.removeFirst()
                        case .failure(_):
                            // it's expected the upload to retry internally, break trying and don't dequeue the latest photo attempted
                            self.uploadState = .Failed
                            break;
                        }
                    }
                }
            }
            
            // check if we are done, and break if so
            if self.imagesToUpload.count <= 0 {
                self.uploadState = .Done
                break;
            }
            
            // if our state is failed, break out and don't try again
            if self.uploadState == .Failed {
                break;
            }
        }
        
        // if we are broken out of the loop, we should be done here
        if self.uploadState == .Done {
            self.finishUploadCallback()
        }
    }
    
    var uploadProgress: some View {
        VStack {
            CircularProgressView(progress: self.getUploadPercent(), failed: self.uploadState == .Failed, retry: {
                    self.uploadState = .Photos
                    Task {
                        await self.processPhotos()
                    }
            }).frame(width: 150).padding(32)
        }.padding().background(.black).cornerRadius(16.0).shadow(radius: 5.0)
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                uploadProgress
                Spacer()
            }
            Spacer()
        }.background(APP_BACKGROUND.opacity(0.5)).task {
            await self.processPhotos()
        }
    }
}

struct CircularProgressView: View {
    let progress: Double
    let failed: Bool
    let retry: () -> Void
    
    func getColor() -> Color {
        if self.failed {
            return Color.red
        } else {
            return Color.white
        }
    }
    
    var body: some View {
        Button(action: {
            self.retry()
        }){
            ZStack {
                VStack {
                    if self.failed {
                        Text("Retry")
                            .foregroundColor(getColor())
                            .font(.title)
                            .bold()
                    } else {
                        Text("\(String(format: "%.0f", self.progress * 100.0))%")
                            .foregroundColor(getColor())
                            .font(.title)
                            .bold()
                    }
                }
                Circle()
                    .stroke(
                        self.getColor().opacity(0.5),
                        lineWidth: 25
                    )
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        self.getColor(),
                        style: StrokeStyle(
                            lineWidth: 25,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut, value: progress)
            }
        }
    }
}

enum UploadStage {
    case Photos
    case Done
    case Failed
}

struct AddImagesLoader_Preview: PreviewProvider {
    static func finishCallback() {}
    
    static func uploadPhoto(token: String, reviewId: String, data: Data) async -> Result<(), RequestError> {
        do {
            try await Task.sleep(for: Duration.seconds(1))
        } catch {}
        
        let randomValue = Int.random(in: 1...100)
        if randomValue >= 75 {
            return .failure(RequestError.NetworkingError(message: "failed network shit"))
        } else {
            return .success(())
        }
    }
    
    static var previews: some View {
        ZStack {
            Image("hood")
            AddImagesUploader(finishUploadCallback: finishCallback, uploadPhoto: uploadPhoto, reviewId: "123", imagesToUpload: [
                ImageSelection(id: "123", image: UIImage(named: "hood")!),
                ImageSelection(id: "test1", image: UIImage(named: "hood")!),
                ImageSelection(id: "test2", image: UIImage(named: "hood")!),
                ImageSelection(id: "test", image: UIImage(named: "hood")!),
                ImageSelection(id: "test3", image: UIImage(named: "hood")!),
                ImageSelection(id: "tes4", image: UIImage(named: "hood")!),
                ImageSelection(id: "tes5", image: UIImage(named: "hood")!)]).preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
        }
    }
}

