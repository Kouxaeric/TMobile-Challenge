//
//  StoriesViewModel.swift
//  TylerBoiceChallenge
//
//  Created by Tyler Boice on 19/10/21.
//

import Foundation
import Combine

class StoriesViewModel {
    
    var totals: Int { stories.count }
    
    @Published private(set) var stories = [Story]()
    @Published private(set) var rowToUpdate = 0
    
    private let service: NetworkManager
    private var imageCache = [String: Data]()
    private var after = ""
    private var updating = false
    private var subscribers = Set<AnyCancellable>()
    
    init(service: NetworkManager = MainNetworkManager()) {
        self.service = service
    }
    
    func loadStories() {
        updating = true
        // creating new url
        let url = NetworkURL.storiesURL.replacingOccurrences(of: NetworkURL.keyAfter, with: after)
        // get data from url
        service
            .getStories(from: url)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.updating = false
                case .failure(let error):
                    // print erro in console
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                self?.stories.append(contentsOf: response.stories)
                self?.after = response.after
            }
            .store(in: &subscribers)
    }
    
    func getImage(by row: Int) -> Data? {
        let story = stories[row]
        
        guard let url = story.thumbnail,
              url.contains("https://") // validate if it is an url
        else { return nil }
        
        // validate if the image is in cache
        if let data = imageCache[url] { return data }
        
        // download image
        service
            .getData(from: url)
            .receive(on: RunLoop.main) // update on main thread o prevent race condition
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    // print error in console
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] data in
                self?.imageCache[url] = data
                self?.rowToUpdate = row
            }
            .store(in: &subscribers)

        return nil
    }
    
    func loadMoreStories(currentRows rows: [Int]) {
        // verify is rows contains the last row
        let lastRow = stories.count - 1
        if rows.contains(lastRow) && !updating {
            loadStories()
        }
    }
    
    func getTitle(at row: Int) -> String? { stories[row].title }
        
    func getNumComments(at row: Int) -> String? { "\(stories[row].numComments)" }
}
