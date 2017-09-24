//
//  FlickrConstants.swift
//  MyVirtualTourist
//
//  Created by Ma Ding on 17/9/15.
//  Copyright © 2017年 Ma Ding. All rights reserved.
//
//

import MapKit
// MARK: - Constants

struct Constants  {
    
    // MARK: Flickr
    struct Flickr {
        static let APIBaseURL = "https://api.flickr.com/services/rest/"
    }
    
    // MARK: Flickr Parameter Keys
    struct FlickrParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let Latitude = "lat"
        static let Longitude = "lon"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let Page = "page"
        static let PerPage = "per_page"
        //static let AuthToken = "auth_token"
        //static let APISig = "api_sig"
    }
    
    // MARK: Flickr Parameter Values
    struct FlickrParameterValues {
        static let SearchMethod = "flickr.photos.search"
        static let APIKeyValue = "c8d4a64043c50d6329d7c2f1d2a27fdc"
        static let MediumURL = "url_m"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1" /* 1 means "yes" */
        static let PerPage = "20"
        //static let AuthValue = "72157689114528375-0e85e9322f97b8e0"
        //static let APISigValue = "54fa50374c1fa0d4fa34097e320fbbde"
        
    }
    
    // MARK: Flickr Response Keys
    struct FlickrResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let MediumURL = "url_m"
    }
    
    // MARK: Flickr Response Values
    struct FlickrResponseValues {
        static let OKStatus = "ok"
    }
    
    // Mark: Photos Url
    static var photosUrl = [String]()

}
