//
//  CreateReviewModel.swift
//  belocal
//
//  Created by Colton Lathrop on 3/16/23.
//

import Foundation

class CreateReviewModel: ObservableObject {
    @Published var text: String = ""
    @Published var stars: Int = 0
    @Published var date = Date()
    @Published var showError = false
    @Published var errorText = ""
}
