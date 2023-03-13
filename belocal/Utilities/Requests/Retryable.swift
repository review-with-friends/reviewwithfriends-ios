//
//  Retryable.swift
//  belocal
//
//  Created by Colton Lathrop on 12/3/22.
//

import Foundation

func requestWithRetry(request: URLRequest) async -> Result<Data, RequestError> {
    var result: Result<Data, RequestError> = .failure(.NetworkingError(message: "error sending request"))
    
    for attempt in 1...3 {
        result = await internalRequestWithRetry(request: request)
        
        switch result {
        case .success(_):
            return result
        case .failure(let error):
            switch error {
            case .DeserializationError:
                return result
            case .BadRequestError:
                return result
            case .InternalServerError:
                do {
                    try await Task.sleep(for: Duration.milliseconds(500 * attempt))
                    continue
                } catch {
                    return result
                }
            case .NetworkingError:
                do {
                    try await Task.sleep(for: Duration.milliseconds(500 * attempt))
                    continue
                } catch {
                    return result
                }
            case .URLMalformedError:
                return result
            }
        }
    }
    
    return result
}

private func internalRequestWithRetry(request: URLRequest) async -> Result<Data, RequestError> {
    var data: Data
    var response: HTTPURLResponse
    var content: String
    
    do {
        var tempResponse: URLResponse
        (data, tempResponse) = try await URLSession.shared.data(for: request)
        
        response = (tempResponse as? HTTPURLResponse)!
        
        content = "unknown error"
        if let temp_content = String(data: data, encoding: .utf8) {
            content = temp_content
        }
    } catch (let error) {
        return .failure(.NetworkingError(message: error.localizedDescription))
    }
    
    let status = response.statusCode
    
    if status == 200 {
        return .success(data)
    } else if status <= 499 && status >= 400 {
        return .failure(.BadRequestError(message: content))
    } else {
        return .failure(.InternalServerError(message: content))
    }
}
