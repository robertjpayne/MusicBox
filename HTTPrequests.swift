//
//  HTTPrequests.swift
//  MusicVideoCharts
//
//  Created by Christopher Dunaetz on 9/13/15.
//  Copyright (c) 2015 Chris Dunaetz. All rights reserved.
//

import Foundation
import UIKit

class networkingClass {
    

   //This particular function is not my own code:

    func httpRequest1(inputURL: NSURL!, completion: (data: NSData?, HTTPStatusCode: Int, error: NSError?) -> Void) {
        
        //Check if the url is readable
        print(inputURL)
        if (inputURL == nil) {
            print("could not read the provided url, maybe there were unusable characters in the search query")
            return
        }
        
        //1.
        let request = NSMutableURLRequest(URL: inputURL)
        //2.
        request.HTTPMethod = "GET"
        //3.
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        //4
        let session = NSURLSession(configuration: sessionConfig)
        //5
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(data: data, HTTPStatusCode: (response as! NSHTTPURLResponse).statusCode, error: error)
            })
        })
        //6
        task.resume()
    }

}