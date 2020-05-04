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
    var currentCountryButton : UIButton?
    
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var defaultUSButton: UIButton!
    
    @IBAction func selectCountry(sender: AnyObject) {
        currentCountryButton?.isEnabled = true
        currentCountryButton = sender as? UIButton
        currentCountryButton?.isEnabled = false
        country = currentCountryButton!.restorationIdentifier!
        
        updateHelloLabel ()
    }
    
    override func viewDidLoad() {
        currentCountryButton = defaultUSButton
        currentCountryButton?.isEnabled = false
        updateHelloLabel ()
        super.viewDidLoad()
    }
    
    func getUIImage (urlString: String)->UIImage? {
        let url = NSURL(string: urlString)
        let imagedData = NSData(contentsOf: url! as URL)!
        return UIImage(data: imagedData as Data, scale: 10)
    }
    
    func updateHelloLabel () {
        LiveUpdateManager.sharedInstance.obtainConfiguration() { (configuration, error) in
            if error == nil {
                let isMapFeatureEnable = configuration!.isFeatureEnabled("includeMap")
                if isMapFeatureEnable != nil && isMapFeatureEnable == true {
                    if let mapUrl = configuration!.getProperty("mapUrl") {
                        self.mapImage.image = self.getUIImage(urlString: mapUrl)
                    }
                } else {
                    self.mapImage.image = nil
                }
                if let helloText = configuration!.getProperty("helloText") {
                    self.helloLabel.text = helloText
                }
                
            } else {
                self.mapImage.image = nil
                self.helloLabel.text = ""
                print (error ?? "Error")
            }
        }
    }
}

