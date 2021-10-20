//
//  NetworkManager.swift
//  TylerBoiceChallenge
//
//  Created by Tyler Boice on 19/10/21.
//

import Foundation
import Combine

typealias Stories = (stories: [Story], after: String)

protocol NetworkManager {
    func getData(from url: String) -> AnyPublisher<Data, NetworkError>
    func getStories(from url: String) -> AnyPublisher<Stories, NetworkError>
}
