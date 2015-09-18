//
//  ViewController.swift
//  MusicVideoCharts
//
//  Created by Christopher Dunaetz on 9/13/15.
//  Copyright (c) 2015 Chris Dunaetz. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    // MARK: Variables
    //----------------------------------------------------------------------------------------------------------------
    
    //Instances of class in "Helper Classes" folder
    let graphicsTools = GraphicsClass()
    let networking1 = networkingClass()
    
    //Array to store tracks in:
    var topTracks:NSArray = []
    //String to store selected tracks's artist and title.
    var trackAndNameQuery: String!
    
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentOutlet: UISegmentedControl!

    @IBOutlet weak var activityHolder: UIView!
   
    // MARK: Setup
    //----------------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spotifyGet()
    }
    
    //When we move to the "PlayerView" controller, we pass along name of the selected song and artist.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segue1" {
            let destinationVC = segue.destinationViewController as! PlayerView
            destinationVC.queryTerm = trackAndNameQuery
        }
    }

    //If the user switch back and forth between "most streamed" and "most viral", we will update the spotify data.
    @IBAction func segmentAction(sender: UISegmentedControl) {
        
        spotifyGet()
    }
    
    // MARK: Table Views
    //----------------------------------------------------------------------------------------------------------------
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //To take the shading off the row when it's selected
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //We get the selected row's info, save it to a variable, and perform the segue to the "PlayerView" controller.
        let track:NSDictionary = topTracks[indexPath.row] as! NSDictionary
        let trackTitle = track["track_name"] as! String
        let artistTitle = track["artist_name"] as! String
        trackAndNameQuery = trackTitle + " " + artistTitle
        
        performSegueWithIdentifier("segue1", sender: self)
        
        //Note: In the method "prepareForSegue" we send the track name over.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return topTracks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) 
        
        //We match the tracks's position in the array with the indexPath of the table view cell.
        let track:NSDictionary = topTracks[indexPath.row] as! NSDictionary
        
        //We also use that indexPath to update the "#1, #2, etc" position label
        let positionString = "#\(indexPath.row+1)"
        let positionLabel = cell.viewWithTag(3) as! UILabel
        positionLabel.text = positionString
        
        //We set the label as the artist name
        let artistName = track["artist_name"] as? String
        let titleCustom = cell.viewWithTag(1) as! UILabel
        titleCustom.text = artistName
        
        //Same for the tracks's title
        let trackName = track["track_name"] as? String
        let subTitleCustom = cell.viewWithTag(2) as! UILabel
        subTitleCustom.text = trackName
        
        return cell
    }
    
    
    // MARK: Spotify API request
    //----------------------------------------------------------------------------------------------------------------
    
    //This is to get the charts from Spotify
    func spotifyGet() {
        
        //Start showing the activity indicator.
        activityHolder.hidden = false
        
        //Create a string based on the segmented control choice.
        var rankType: String
        if (segmentOutlet.selectedSegmentIndex == 0) {
            rankType = "most_streamed"
        } else { rankType = "most_viral" }
        
        //Construct the url with the variable rankType
        let baseURL = "http://charts.spotify.com"
        let latestWeeklyString = "/api/tracks/\(rankType)/global/weekly/latest"
        let urlString = baseURL.stringByAppendingString(latestWeeklyString)
        let url = NSURL(string: urlString)
        
        //Once we've built the url we pass it to a networking function found in "HTTPrequests.swift"
        networking1.httpRequest1(url, completion: { (data, HTTPStatusCode, error) -> Void in
            
            if HTTPStatusCode == 200 && error == nil {
                //We convert the raw JSON into a dictionary object
                let dictionaryA = (try! NSJSONSerialization.JSONObjectWithData(data!, options: [])) as! Dictionary<NSObject, AnyObject>
                //The only object is the array of tracks found in the "tracks" key.
                let arrayB = dictionaryA["tracks"] as! Array<Dictionary<NSObject, AnyObject>>
                //We save this array
                self.topTracks = arrayB
                
                self.tableView.reloadData()
                self.tableView.flashScrollIndicators()
                self.activityHolder.hidden = true

            }
        })
        
        
    }
    
    


}

