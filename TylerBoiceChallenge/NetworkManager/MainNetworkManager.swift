//
//  MainNetworkManager.swift
//  TylerBoiceChallenge
//
//  Created by Tyler Boice on 19/10/21.
//

import Foundation
import Combine

class MainNetworkManager: NetworkManager {
    
    private let session = URLSession.shared
    
    func getData(from url: String) -> AnyPublisher<Data, NetworkError> {
        
        guard let url = URL(string: url) else {
            return Fail(error: NetworkError.badURL).eraseToAnyPublisher()
        }
        
        return session
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .mapError{ error in NetworkError.other(error) }
            .eraseToAnyPublisher()
    }
    
    func getStories(from url: String) -> AnyPublisher<Stories, NetworkError> {
        
        guard let url = URL(string: url) else {
            return Fail(error: NetworkError.badURL).eraseToAnyPublisher()
        }
        
        // printing in console the url
        print(url.absoluteURL)
        
        return session
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: StoriesResponse.self, decoder: JSONDecoder())
            .map { response -> Stories in
                let stories = response.data.children.map{ $0.data }
                let after = response.data.after
                return Stories(stories, after)
            }
            .mapError{ error in NetworkError.other(error) }
            .eraseToAnyPublisher()
    }
}
