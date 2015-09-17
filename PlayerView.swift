//
//  PlayerView.swift
//  MusicVideoCharts
//
//  Created by Christopher Dunaetz on 9/13/15.
//  Copyright (c) 2015 Chris Dunaetz. All rights reserved.
//

import Foundation
import UIKit

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
        
        var YTstring = "https://www.googleapis.com/youtube/v3/search?part=snippet&order=viewCount&q=\(query)&type=video&key=AIzaSyBf0DIPzfbp_8TUnBjHiUL8TUGOPLT9n8E"
        var YTurl = NSURL(string: YTstring)
        
        //If url came out nil, we present an alert view for the error:
        
        if (YTurl == nil) {
            
            println(YTurl)
            self.activityIndicatorHolder.hidden = true
            println("url formatting error")

            var alert = UIAlertController(title: "Video not found.", message: "Sorry, there was an error in the video search.", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                switch action.style{
                case .Default:
                    println("default")
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    
                case .Cancel:
                    println("cancel")
                    
                case .Destructive:
                    println("destructive")
                }
            }))

            return
        }
        
        //If the url is fine, we pass it to a function found in "HTTPrequests.swift"
        
        networking1.httpRequest1(YTurl, completion: { (data, HTTPStatusCode, error) -> Void in
            
            if HTTPStatusCode == 200 && error == nil {
                
                 self.activityIndicatorHolder.hidden = false
                
                //We make an instance of a custom class
                let dict = MusicBoxDictionary()
                //We feed it the data
                dict.loadData(data!)
                
                //We construct a url and send it to the webview
                var string1 = "https://www.youtube.com/watch?v=\(dict.id)" as String
                println(string1)
                var url1 = NSURL(string: string1)
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

