//
//  NetworkURL.swift
//  TylerBoiceChallenge
//
//  Created by Tyler Boice on 19/10/21.
//

import Foundation

enum NetworkURL {
    static private let urlBase = "https://www.reddit.com/.json"
    static let keyAfter = "$AFTER_KEY"
    static let storiesURL = "\(urlBase)?after=\(keyAfter)"
}
