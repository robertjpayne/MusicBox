//
//  PlayerView.swift
//  MusicVideoCharts
//
//  Created by Christopher Dunaetz on 9/13/15.
//  Copyright (c) 2015 Chris Dunaetz. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class PlayerView: UIViewController {
    
    let networking1 = networkingClass()
    
    @IBOutlet weak var webViewOutlet: UIWebView!
    
    @IBOutlet weak var activityIndicatorHolder: UIView!
    
    var videoID: String!
    var queryTerm: String!
    
    override func viewDidLoad() {
        
        self.youtubeQuery()
        
    }
    
    // MARK: Youtube
    //----------------------------------------------------------------------------------------------------------------
    
    func youtubeQuery() {
        
        //Formatting the query
        
        var query = queryTerm
        query = query.stringByReplacingOccurrencesOfString("\"", withString: "")
        query = query.stringByReplacingOccurrencesOfString(" ", withString: "+")
        
        //creating the url
        
        let YTstring = "https://www.googleapis.com/youtube/v3/search?part=snippet&order=viewCount&q=\(query)&type=video&key=AIzaSyBf0DIPzfbp_8TUnBjHiUL8TUGOPLT9n8E"
        let YTurl = NSURL(string: YTstring)
        
        //If url came out nil, we present an alert view for the error:
        
        if (YTurl == nil) {
            
            print(YTurl)
            self.activityIndicatorHolder.hidden = true
            print("url formatting error")

            let alert = UIAlertController(title: "Video not found.", message: "Sorry, there was an error in the video search.", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                switch action.style{
                case .Default:
                    print("default")
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    
                case .Cancel:
                    print("cancel")
                    
                case .Destructive:
                    print("destructive")
                }
            }))

            return
        }
        
        //If the url is fine, we pass it to a function found in "HTTPrequests.swift"
        
        networking1.httpRequest1(YTurl, completion: { (data, HTTPStatusCode, error) -> Void in
            
            if HTTPStatusCode == 200 && error == nil {
                
                 self.activityIndicatorHolder.hidden = false
                
                //We get the video ID from the JSON using the SwiftyJSON framework.
                let id = JSON(data: data!)["items"][0]["id"]["videoId"].stringValue
                
                //We construct a url and send it to the webview
                let string1 = "https://www.youtube.com/watch?v=\(id)" as String
                print(string1)
                let url1 = NSURL(string: string1)
                let request = NSMutableURLRequest(URL: url1!)
                self.webViewOutlet.loadRequest(request)
            }

        })
        
        
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        //This is to re-adjust the white space at the top of the page.
        webView.scrollView.contentOffset = CGPointMake(0, 0)
        
        //Hide the activity indicator.
        self.activityIndicatorHolder.hidden = true

    }
}

