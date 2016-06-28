/**
 * Copyright 2016 IBM Corp.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//
//  ViewController.swift
//  HelloLiveUpdate
//

import UIKit
import IBMMobileFirstPlatformFoundationLiveUpdate

class ViewController: UIViewController {
    var country = "US"
    var current : UIButton?
    @IBOutlet weak var defaultUSButton: UIButton!
    
    override func viewDidLoad() {
        current = defaultUSButton
        current?.enabled = false
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func helloLiveUpdate(sender: AnyObject) {
        LiveUpdateManager.sharedInstance.obtainConfiguration(country) { (configuration, error) in
            if error == nil {
                if let helloText = configuration!.getProperty("helloText") {
                    let alert = UIAlertController(title: "Live Update", message: helloText, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            } else {
                print (error)
            }
        }
    }
    
    @IBAction func selectLangauge(sender: AnyObject) {
        current?.enabled = true
        current = sender as? UIButton
        current?.enabled = false
        country = current!.restorationIdentifier!
    }
}

