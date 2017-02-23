//
//  ActivityIndicatorView.swift
//  UI Component
//
//  Created by Chandan Brown on 2/10/17.
//  Copyright © 2017 Chandan B. All rights reserved.
//

import UIKit

//This extends abilities of UIViewController to display and remove UI blocker.
public protocol ActivityIndicatorViewable { }

public extension ActivityIndicatorViewable where Self: UIViewController {
    
    /**
     -  type:                 animation type.
     -  size:                 size of activity indicator view.
     -  color:                color of activity indicator view.
     -  minimumDisplayTime:   minimum display time of UI blocker.
     -  padding:              padding of activity indicator view.
     -  message:              message displayed under activity indicator view.
     -  displayTimeThreshold: display time threshold to actually display UI blocker.
     -  messageFont:          font of message displayed under activity indicator view.
     */
    
    public final func startAnimating(_ size: CGSize?  = nil, message: String? = nil, messageFont: UIFont? = nil, type: ActivityType?  = nil, color: UIColor?   = nil, padding: CGFloat? = nil, displayTimeThreshold: Int? = nil, minimumDisplayTime: Int?   = nil, backgroundColor: UIColor?  = nil) {
        
        let activityData = ActivityData(size: size, message: message, messageFont: messageFont,type: type, color: color, padding: padding, displayTimeThreshold: displayTimeThreshold, minimumDisplayTime: minimumDisplayTime, backgroundColor: backgroundColor)
        
        ActivityPresenter.sharedInstance.startAnimating(activityData)
        print("Is Animating")
    }
    
    // Remove
    public final func stopAnimating() {
        ActivityPresenter.sharedInstance.stopAnimating()
    }
}

