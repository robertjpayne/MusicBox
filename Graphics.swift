//
//  Graphics.swift
//  MusicVideoCharts
//
//  Created by Christopher Dunaetz on 9/13/15.
//  Copyright (c) 2015 Chris Dunaetz. All rights reserved.
//

import Foundation
import UIKit

class GraphicsClass {
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}

class NavController: UINavigationController {
    
    override func viewDidLoad() {

        //To make the nav bar transluscent
        self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.translucent = true
        
        //To set the tint to white
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    }
    
    //To change the status bar style when the navigation controller is active.
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }
}