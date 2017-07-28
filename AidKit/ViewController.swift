//
//  ViewController.swift
//  AidKit
//
//  Created by Rezeq, Maher on 7/27/17.
//  Copyright © 2017 NativeNCreative. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recording: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func start(sender: UIButton) {

        AKManager.sharedInstance.start()
        recording.isHidden = false
    }

    @IBAction func stop(sender: UIButton) {
        AKManager.sharedInstance.stop()
        recording.isHidden = true
    }
}

