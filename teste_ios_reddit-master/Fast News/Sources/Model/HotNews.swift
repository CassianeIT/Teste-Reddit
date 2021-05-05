//
//  News.swift
//  Fast News
//
//  Copyright © 2019 Lucas Moreton. All rights reserved.
//

import Foundation

struct HotNews: Codable {
    var id: String?
    var title: String?
    var selftext: String?
    var preview: Preview?
    var url: String?
    var created: Int?
    var ups: Int?
    var downs: Int?
    var score: Int?
    var authorFullname: String?
    var numComments: Int?
    
    
    private enum CodingKeys: String, CodingKey {
        case id, title, selftext, preview, url, created, ups, downs, score
        case authorFullname = "author_fullname"
        case numComments = "num_comments"
    }
    
    static var archiveURL: URL {
        let documentsDirectory =
            FileManager.default.urls(for: .documentDirectory,
                                     in: .userDomainMask).first!
        let archiveURL =
            documentsDirectory.appendingPathComponent("news")
            .appendingPathExtension("plist")
        
        return archiveURL
    }
    

}
