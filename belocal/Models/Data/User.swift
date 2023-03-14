//
//  User.swift
//  belocal
//
//  Created by Colton Lathrop on 12/1/22.
//

import Foundation

struct User : Codable, Identifiable {
    let id: String
    let name: String
    let displayName: String
    let created: Date
    let picId: String
    let recovery: Optional<Bool> 
}
