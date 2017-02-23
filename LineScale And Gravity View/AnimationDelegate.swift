//
//  AnimationDelegate.swift
//  UI Component
//
//  Created by Chandan Brown on 2/10/17.
//  Copyright © 2017 Chandan B. All rights reserved.
//


import UIKit

protocol AnimationDelegate {
    func setUpAnimation(in layer:CALayer, size: CGSize, color: UIColor)
}
