//
//  PhoneAuthenticationError.swift
//  bout
//
//  Created by Colton Lathrop on 12/1/22.
//

import Foundation

enum RequestError: Error, CustomStringConvertible {
    case BadRequest(message: String)
    case InternalServerError(message: String)
    case NetworkingError(message: String)
    case DeserializationError(message: String)
    
    var description: String {
        switch self {
        case .BadRequest(let message): return message
        case .InternalServerError(let message): return message
        case .NetworkingError(let message): return message
        case .DeserializationError(let message): return message
        }
    }
}
