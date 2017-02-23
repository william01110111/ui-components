//
//  ViewController.swift
//  UI Component
//
//  Created by Chandan Brown on 2/10/17.
//  Copyright © 2017 Chandan B. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ActivityIndicatorViewable {
    
    @IBOutlet weak var loading: ActivityView!
    @IBOutlet weak var circleAnimation: ActivityView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Began Animating
    @IBAction func startLoading(_ sender: Any) {
        self.loading?.startAnimating()
        self.circleAnimation.startAnimating()
    }
    
    //Stop Animating
    @IBAction func stopLoading(_ sender: Any) {
        self.loading?.stopAnimating()
        self.circleAnimation.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

