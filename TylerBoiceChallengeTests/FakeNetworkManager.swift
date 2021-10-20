//
//  FakeNetworkManager.swift
//  TylerBoiceChallengeTests
//
//  Created by Tyler Boice on 19/10/21.
//

import Foundation
import Combine
@testable import TylerBoiceChallenge

class FakeNetworkManager: NetworkManager {
    
    var data: Data?
    var response: Stories?
    var error: Error?
    
    func getData(from url: String) -> AnyPublisher<Data, NetworkError> {
        
        if let error = error {
            return Fail(error: NetworkError.other(error)).eraseToAnyPublisher()
        }
        
        if let data = data {
            return CurrentValueSubject<Data, NetworkError>(data).eraseToAnyPublisher()
        }
        
        fatalError("Need error or response")
    }
    
    func getStories(from url: String) -> AnyPublisher<Stories, NetworkError> {
        
        if let error = error {
            return Fail(error: NetworkError.other(error)).eraseToAnyPublisher()
        }
        
        if let response = response {
            return CurrentValueSubject<Stories, NetworkError>(response).eraseToAnyPublisher()
        }
        
        fatalError("Need error or response")
    }
    
    
}
