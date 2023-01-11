//
//  PhoneAuthenticationError.swift
//  spotster
//
//  Created by Colton Lathrop on 12/1/22.
//

import Foundation

enum RequestError: Error, CustomStringConvertible {
    case BadRequestError(message: String)
    case InternalServerError(message: String)
    case NetworkingError(message: String)
    case DeserializationError(message: String)
    case URLMalformedError(message: String)
    
    var description: String {
        switch self {
        case .BadRequestError(let message): return message
        case .InternalServerError(let message): return message
        case .NetworkingError(let message): return message
        case .DeserializationError(let message): return message
        case .URLMalformedError(let message): return message
        }
    }
}
