//
//  StoriesResponse.swift
//  TylerBoiceChallenge
//
//  Created by Tyler Boice on 19/10/21.
//

import Foundation

typealias Story = StoriesResponse.ResponseData.Child.Story

struct StoriesResponse: Decodable {
    
    // properties
    let data: ResponseData
    
    // custom struct
    struct ResponseData: Decodable {
        
        // properties
        let after: String
        let children: [Child]
        
        // custom struct
        struct Child: Decodable {
            
            // properties
            let data: Story
            
            // custom struct
            struct Story: Decodable {
                
                let title: String?
                let thumbnailHeight: Int?
                let thumbnailWidth: Int?
                let thumbnail: String?
                let numComments: Int
                
                private enum CodingKeys: String, CodingKey {
                    case title
                    case thumbnailHeight = "thumbnail_height"
                    case thumbnailWidth = "thumbnail_width"
                    case thumbnail
                    case numComments = "num_comments"
                }
            }
        }
    }
    
}
