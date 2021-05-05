//
//  HotNewsProvider.swift
//  Fast News
//
//  Copyright © 2019 Lucas Moreton. All rights reserved.
//

import Foundation
import Alamofire

//MARK: - Type alias
typealias HotNewsCallback = ( () throws -> [HotNews]) -> Void
typealias HotNewsCommentsCallback = ( () throws -> [Comment]) -> Void

class HotNewsProvider {
    
    //MARK: - Constants
    
    // Hot News endpoint
    private var kHotNewsEndpoint = "/r/ios/hot/.json"
    // Comments endpoint
    private let kCommentsEndpoint = "/r/ios/comments/@.json"
    
    
    // Hot News key/value parameters
    let kLimitKey = "limit"
    var kLimitValue = 100
    let kAfterKey = "after"
    let kAfterValue = ""
    
    //MARK: - Singleton
    static let shared: HotNewsProvider = HotNewsProvider()
    
    //MARK: - Public Methods
    func hotNews(completion: @escaping HotNewsCallback) {
        let alamofire = APIProvider.shared.sessionManager
        
        let requestString = APIProvider.shared.baseURL() + kHotNewsEndpoint
        
        let parameters: Parameters = [ kLimitKey : kLimitValue,
                                       kAfterKey : kAfterValue ]

        do {
            let requestURL = try requestString.asURL()
            let headers: HTTPHeaders = APIProvider.shared.baseHeader()
            
            alamofire.request(requestURL, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).responseJSON { [self] (response) in
                switch response.result {
                case .success:
                                        
                    guard let hotNewsDict = response.result.value as? [String: AnyObject],
                          let dictArray = hotNewsDict["data"]?["children"] as? [[String: AnyObject]] else {
                        completion {

                            return [HotNews]()
                         
                        }
                        return
                    }
                    
                    var hotNewsArray: [HotNews] = [HotNews]()

                    for hotNews in dictArray {
                        let data = hotNews["data"]
                        
                        guard let jsonData = try? JSONSerialization.data(withJSONObject: data as Any, options: .prettyPrinted),
                              let hotNews = try? JSONDecoder().decode(HotNews.self, from: jsonData) else {
                            completion { return [HotNews]() }
                            return
                        }
                        hotNewsArray.append(hotNews)
                    }
                    
                    completion {
                        
                        saveToFile(news: hotNewsArray)
                        
                        var archiveURL: URL {
                            let documentsDirectory =
                                FileManager.default.urls(for: .documentDirectory,
                                                         in: .userDomainMask).first!
                            let archiveURL =
                                documentsDirectory.appendingPathComponent("news")
                                .appendingPathExtension("plist")
                            
                            return archiveURL
                        }
                        
                        func saveToFile(news: [HotNews]) {
                            let encoder = PropertyListEncoder()
                            do {
                                let encodedNews = try? encoder.encode(hotNewsArray)
                                try encodedNews?.write(to: archiveURL)
                                print(archiveURL)
                            } catch {
                                print("Error encoding news: \(error)")
                            }
                        }
                        
                        return hotNewsArray }
                    break
                case .failure(let error):
                    completion {
                        guard let newsData = try? Data(contentsOf: HotNews.archiveURL) else {
                            throw error
                        }
                        do {
                            let decoder = PropertyListDecoder()
                            let decodedNews = try decoder.decode([HotNews].self, from: newsData)
                            return decodedNews
                        } catch {
                            print("Error decoding books: \(error)")
                            throw error
                        }
                    }
                }
            }
        } catch {
            completion { throw error }
        }
    }
    
  
    func hotNewsComments(id: String, completion: @escaping HotNewsCommentsCallback) {
        let alamofire = APIProvider.shared.sessionManager
        let endpoint = kCommentsEndpoint.replacingOccurrences(of: "@", with: id)
        let requestString = APIProvider.shared.baseURL() + endpoint
        
        do {
            let requestURL = try requestString.asURL()
            let headers: HTTPHeaders = APIProvider.shared.baseHeader()
            
            alamofire.request(requestURL, method: .get, parameters: nil, encoding: URLEncoding.queryString, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    
                    guard let hotNewsDict = response.result.value as? [[String: AnyObject]],
                        let dictArray = hotNewsDict.last?["data"]?["children"] as? [[String: AnyObject]] else {
                            completion { return [Comment]() }
                            return
                    }
                    
                    var commentsArray: [Comment] = [Comment]()
                    
                    for comment in dictArray {
                        let data = comment["data"]
                        
                        guard let jsonData = try? JSONSerialization.data(withJSONObject: data as Any, options: .prettyPrinted),
                            let comment = try? JSONDecoder().decode(Comment.self, from: jsonData) else {
                                completion { return [Comment]() }
                                return
                        }
                        
                        if !comment.isEmpty() {
                            commentsArray.append(comment)
                        }
                    }
                    
                    completion {
                        saveToFile(news: commentsArray)
                        
                        var archiveURL: URL {
                            let documentsDirectory =
                                FileManager.default.urls(for: .documentDirectory,
                                                         in: .userDomainMask).first!
                            let archiveURL =
                                documentsDirectory.appendingPathComponent("comments")
                                .appendingPathExtension("plist")
                            
                            return archiveURL
                        }
                        
                        func saveToFile(news: [Comment]) {
                            let encoder = PropertyListEncoder()
                            do {
                                let encodedNews = try? encoder.encode(commentsArray)
                                try encodedNews?.write(to: archiveURL)
                                print(archiveURL)
                            } catch {
                                print("Error encoding news: \(error)")
                            }
                        }
                
                        return commentsArray
                    }
                    break
                case .failure(let error):
                    completion {
                        guard let newsData = try? Data(contentsOf: Comment.archiveURL) else {
                            throw error
                        }
                        do {
                            let decoder = PropertyListDecoder()
                            let decodedNews = try decoder.decode([Comment].self, from: newsData)
                            return decodedNews
                        } catch {
                            print("Error decoding books: \(error)")
                            throw error
                        }
                    }
                }
            }
        } catch {
            completion { throw error }
        }
    }
}
