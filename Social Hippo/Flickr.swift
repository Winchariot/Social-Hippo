//
//  FlickrRouter.swift
//  Social Hippo
//
//  Created by James Gillin on 3/16/16.
//  Copyright © 2016 James Gillin. All rights reserved.
//

import Alamofire

struct Flickr {
    
  enum Router: URLRequestConvertible {
    static let baseURLString = "https://api.flickr.com/services/rest"
    static var apiKey: String = ""
    
    case PhotoSearch(String)
    
    var URLRequest: NSMutableURLRequest {
      let result: [String: AnyObject]? = {
        switch self {
        case .PhotoSearch(let tags) :
          let params: [String:AnyObject] = ["method":"flickr.photos.search",
            "format":"json",
            "nojsoncallback":1,
            "api_key":Router.apiKey,
            "tags":tags,
            "tag_mode":"all",
            "content_type":1,
            "media":"photos",
            "extras":"owner_name",
            "per_page":1
          ]
          return params
        }
      }()
      
      let BaseURL = NSURL(string: Router.baseURLString)!
      let URLRequest = NSURLRequest(URL: BaseURL)
      let encoding = Alamofire.ParameterEncoding.URL
      return encoding.encode(URLRequest, parameters: result).0
    }
    
  }
}