//
//  NetworkError.swift
//  TylerBoiceChallenge
//
//  Created by Tyler Boice on 19/10/21.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case other(Error)
    
    var localizedDescription: String {
        switch self {
        case .badURL:
            return "Bad URL"
        case .other(let error):
            return error.localizedDescription
        }
    }
}
