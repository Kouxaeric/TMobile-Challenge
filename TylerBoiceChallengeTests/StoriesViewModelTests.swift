//
//  StoriesViewModelTests.swift
//  TylerBoiceChallengeTests
//
//  Created by Tyler Boice on 19/10/21.
//

import XCTest
import Combine
@testable import TylerBoiceChallenge

class StoriesViewModelTests: XCTestCase {
    
    var fakeNetworkManager: FakeNetworkManager!
    var viewModel: StoriesViewModel!
    var subscribers = Set<AnyCancellable>()

    override func setUpWithError() throws {
        fakeNetworkManager = FakeNetworkManager()
        viewModel = StoriesViewModel(service: fakeNetworkManager)
    }

    func testLoadStoriesSuccess() throws {
        
        // Given
        let expectation = XCTestExpectation(description: "wait for data")
        let data = try load(json: "stories")
        let storiesResponse = try JSONDecoder().decode(StoriesResponse.self, from: data)
        let stories = storiesResponse.data.children.map { $0.data }
        let response = Stories(stories, "123")
        fakeNetworkManager.response = response
        
        // When
        viewModel
            .$stories
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { stories in
                print(stories.count)
                XCTAssertEqual(stories.count, 25)
                expectation.fulfill()
            }
            .store(in: &subscribers)
        
        viewModel.loadStories()
        
        // Then
        wait(for: [expectation], timeout: 2)
    }

    private func load(json: String) throws -> Data {
        let bundle = Bundle(for: StoriesViewModelTests.self)
        
        guard let file = bundle.url(forResource: json, withExtension: "json")
        else { fatalError("File \(json) could not be loaded") }
        
        return try Data(contentsOf: file)
    }

}
