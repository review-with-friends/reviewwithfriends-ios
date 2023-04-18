//
//  ReportUser.swift
//  app
//
//  Created by Colton Lathrop on 4/17/23.
//

import Foundation
import SwiftUI

struct ReportUser: View {
    @Binding var showReportSheet: Bool
    var userId: String
    
    @State var complete: Bool = false
    @State var error: Bool = false
    @State var reportType: ReportType = .None
    
    @EnvironmentObject var auth: Authentication
    
    enum ReportType: String, CaseIterable, Identifiable {
        case ExplicitImages, HateSpeech, Spam, IllegalActivity, None
        var id: Self { self }
    }
    
    func reportUser() async {
        self.error = false
        
        let reportResult = await app.reportUserById(token: self.auth.token, userId: self.userId)
        
        switch reportResult {
        case .success(_):
            self.complete = true
            Task {
                
            }
        case .failure(_):
            self.error = true
        }
    }
    
    var body: some View {
        VStack {
            if !self.complete {
                VStack {
                    if self.error {
                        Text("Failed to submit report. Please try again.").foregroundColor(.red)
                    }
                    List {
                        Picker("Reason", selection: self.$reportType) {
                            Text("None").tag(ReportType.None)
                            Text("Explicit Images").tag(ReportType.ExplicitImages)
                            Text("Hate Speech").tag(ReportType.HateSpeech)
                            Text("Spam").tag(ReportType.Spam)
                            Text("Illegal Activity").tag(ReportType.IllegalActivity)
                        }
                        Button("Submit") {
                            Task {
                                await self.reportUser()
                            }
                        }.disabled(reportType == .None)
                    }
                }
            } else {
                Text("Thank you for submitting a report!")
            }
        }
    }
}

struct ReportUser_Preview: PreviewProvider {
    static var previews: some View {
        VStack{
            ReportUser(showReportSheet: .constant(true), userId: "123")
                .preferredColorScheme(.dark)
                .environmentObject(Authentication.initPreview())
        }
    }
}
