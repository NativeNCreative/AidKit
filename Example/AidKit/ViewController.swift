//
//  ViewController.swift
//  AidKit
//
//  Created by Rezeq, Maher on 7/27/17.
//  Copyright © 2017 NativeNCreative. All rights reserved.
//

import UIKit
import AidKit

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

    @IBAction func launchMenu(_ sender: Any) {
        let menuTableViewController = MenuTableViewController()
        let navigationController = UINavigationController(rootViewController: menuTableViewController)
        present(navigationController, animated: true, completion: nil)
    }

    @IBAction func start(sender: UIButton) {
        AKManager.shared.start()
        recording.isHidden = false
    }

    @IBAction func stop(sender: UIButton) {
        AKManager.shared.stop()
        recording.isHidden = true
    }
}

