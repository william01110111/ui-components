//
//  ActivityTypeEnum.swift
//  UI Component
//
//  Created by Chandan Brown on 2/10/17.
//  Copyright © 2017 Chandan B. All rights reserved.
//

import UIKit

// - LineScalePulseOut: Animation name (inspired by NSActivity Indicator)

public enum ActivityType: Int {
    //  - returns: Instance of Blank.
    case blank
    
    // - returns: Instance of LineScalePulseOut.
    case lineScalePulseOut
    
    // - returns: Instance of CircleAnimation.
    case circleAnimation
    
    // - returns: Instance of AudioEqualizer.
    case audioEqualizer
    
    static let allTypes = (blank.rawValue ... audioEqualizer.rawValue).map{ ActivityType(rawValue: $0)! }
    
    func animation() -> AnimationDelegate {
        switch self {
            
        case .lineScalePulseOut:
            return LineScalePulseOut() 
            
        case .circleAnimation:
            return CircleAnimation()
            
        default:
            return LineScalePulseOut()
        }
    }
}
