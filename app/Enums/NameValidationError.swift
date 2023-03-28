//
//  NameValidationError.swift
//  app
//
//  Created by Colton Lathrop on 12/3/22.
//

import Foundation

enum NameValidationError: Error, CustomStringConvertible {
    case Invalid(message: String)
    
    var description: String {
        switch self {
        case .Invalid(let message): return message
        }
    }
}
