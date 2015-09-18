//
//  MusicBoxDictionary.swift
//  MusicVideoCharts
//
//  Created by Christopher Dunaetz on 9/15/15.
//  Copyright (c) 2015 Chris Dunaetz. All rights reserved.
//

import Foundation

class MusicBoxDictionary {
    
    var id: String = ""
    
    func loadData (input: NSData) {
        
        let dictionaryA = (try! NSJSONSerialization.JSONObjectWithData(input, options: [])) as! Dictionary<NSObject, AnyObject>
        let arrayB = dictionaryA["items"] as! Array<Dictionary<NSObject, AnyObject>>
        let firstEntryC = arrayB[0] as Dictionary<NSObject, AnyObject>
        let snippetD = firstEntryC["id"] as! Dictionary<NSObject, AnyObject>
        let videoIdE = snippetD["videoId"] as! String
        
        id = videoIdE
        
    }
}