//
//  GetImageUrls.swift
//  MyVirtualTourist
//
//  Created by Ma Ding on 17/9/15.
//  Copyright © 2017年 Ma Ding. All rights reserved.
//

import Foundation

class GetImageUrls {
    
    // Mark: Get Photos Data
    func getImageUrls(latitude: Double, longitude: Double, pageNumber: Int, completionHandlerForGetPhotosUrls: @escaping (_ success: Bool, _ photosUrl: [String]?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let methodParameters = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKeyValue,
            Constants.FlickrParameterKeys.Latitude: latitude,
            Constants.FlickrParameterKeys.Longitude: longitude,
            Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback, Constants.FlickrParameterKeys.Page: pageNumber, Constants.FlickrParameterKeys.PerPage: Constants.FlickrParameterValues.PerPage /*Constants.FlickrParameterKeys.AuthToken: Constants.FlickrParameterValues.AuthValue, Constants.FlickrParameterKeys.APISig: Constants.FlickrParameterValues.APISigValue*/
            ] as [String : Any]
        
        // create url and request
        let session = URLSession.shared
        let urlString = Constants.Flickr.APIBaseURL + escapedParameters(methodParameters as [String:AnyObject])
        print("urlString is \(urlString)")
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        // create network request
        let task = session.dataTask(with: request) { (data, response, error) in
            
            // if an error occurs, print it and re-enable the UI
            func displayError(_ error: String) {
                print(error)
            }
            
            /* GUARD: Was there an error? */
            if error != nil {
                completionHandlerForGetPhotosUrls(false, nil, error! as NSError)
            } else {
                /* GUARD: Did we get a successful 2XX response? */
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                    displayError("Your request returned a status code other than 2xx!")
                    return
                }
                
                /* GUARD: Was there any data returned? */
                guard let data = data else {
                    displayError("No data was returned by the request!")
                    return
                }
                
                // parse the data
                let parsedResult: [String:AnyObject]!
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                } catch {
                    displayError("Could not parse the data as JSON: '\(data)'")
                    return
                }
                
                /* GUARD: Did Flickr return an error (stat != ok)? */
                guard let stat = parsedResult[Constants.FlickrResponseKeys.Status] as? String, stat == Constants.FlickrResponseValues.OKStatus else {
                    displayError("Flickr API returned an error. See error code and message in \(parsedResult)")
                    return
                }
                
                /* GUARD: Are the "photos" and "photo" keys in our result? */
                guard let photosDictionary = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject], let photoArray = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [[String:AnyObject]] else {
                    displayError("Cannot find keys '\(Constants.FlickrResponseKeys.Photos)' and '\(Constants.FlickrResponseKeys.Photo)' in \(parsedResult)")
                    return
                }
                
                // Get photos url_m
                var photosUrl = [String]()
                photosUrl = self.getPhotosUrl(photoArray: photoArray, key: "url_m")
                print("PhotosUrl is \(photosUrl)")
                completionHandlerForGetPhotosUrls(true, photosUrl, nil)
            }
        }
        // start the task!
        task.resume()
        return task
    }
    
    // MARK: Helper for Escaping Parameters in URL
    
    private func escapedParameters(_ parameters: [String:AnyObject]) -> String {
        
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                
                // make sure that it is a string value
                let stringValue = "\(value)"
                
                // escape it
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                // append it
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
            }
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }
    
    // Get photos url
    private func getPhotosUrl(photoArray: [[String: AnyObject]], key: String) -> Array<String> {
    
        var photosUrl = [String]()
        for photo in photoArray {
        
            photosUrl.append(photo["url_m"] as! String)
        }
        return photosUrl
    }
    
    static var sharedInstance = GetImageUrls()
    
    // Helper method: given a URL, get the UIImage to load in the collection view cell
    func downloadPhotoWith(url: String, completionHandlerForDownload: @escaping (_ success: Bool, _ imageData: NSData?, _ error: Error?) -> Void) {
        
        let session = URLSession.shared
        
        // Convert the url string to URL so that it can be passed into dataTask(with url:)
        let photoURL = URL(string: url)
        
        let task = session.dataTask(with: photoURL!) { (data, response, error) in
            
            guard let imageData = data else {
                completionHandlerForDownload(false, nil, error)
                return
            }
            
            completionHandlerForDownload(true, imageData as NSData?, nil)
        }
        
        task.resume()
    }
}
