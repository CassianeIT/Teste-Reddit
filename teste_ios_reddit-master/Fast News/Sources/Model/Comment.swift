//
//  Comment.swift
//  Fast News
//
//  Copyright © 2019 Lucas Moreton. All rights reserved.
//

import Foundation

struct Comment: Codable {
    var created: Int?
    var ups: Int?
    var downs: Int?
    var body: String?
    var authorFullname: String?
    
    private enum CodingKeys: String, CodingKey {
        case created, ups, downs, body
        case authorFullname = "author_fullname"
    }
    
    static var archiveURL: URL {
        let documentsDirectory =
            FileManager.default.urls(for: .documentDirectory,
                                     in: .userDomainMask).first!
        let archiveURL =
            documentsDirectory.appendingPathComponent("comments")
            .appendingPathExtension("plist")
        
        return archiveURL
    }
    
    //MARK: - Public Methods
    func isEmpty() -> Bool {
        guard let _ = created, let _ = ups, let _ = downs, let _ = body, let _ = authorFullname else {
            return true
        }
        
        return false
    }
    
}
