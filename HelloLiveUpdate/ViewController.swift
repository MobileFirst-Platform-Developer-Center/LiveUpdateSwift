/**
 * Copyright 2020 IBM Corp.
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
//
//  Created by Vittal R Pai on 04/05/20.
//  Copyright © 2020 IBM. All rights reserved.
//

import UIKit
import IBMMobileFirstPlatformFoundationLiveUpdate

class ViewController: UIViewController {
    
    @IBOutlet weak var backgrounImage: UIImageView!
    @IBOutlet weak var featureButton: UIButton!
    
    override func viewDidLoad() {
        hideFeature()
        checkForFeature()
        super.viewDidLoad()
    }
    
    func getUIImage (urlString: String)->UIImage? {
        let url = NSURL(string: urlString)
        let imagedData = NSData(contentsOf: url! as URL)!
        return UIImage(data: imagedData as Data, scale: 10)
    }
    
    func checkForFeature() {
        LiveUpdateManager.sharedInstance.obtainConfiguration(useCache: false, completionHandler: { (configuration, error) in
            if error == nil {
                let isFestivalShoppingFeatureEnable = configuration!.isFeatureEnabled("festivalShopping")
                if isFestivalShoppingFeatureEnable != nil && isFestivalShoppingFeatureEnable == true {
                    if let imageName = configuration!.getProperty("image") {
                        self.backgrounImage.image = UIImage(named: imageName)
                    }
                    if let buttonText = configuration!.getProperty("buttonLabel") {
                        self.featureButton.isHidden = false
                        self.featureButton.setTitle(buttonText, for: .normal)
                    }
                } else {
                    self.hideFeature()
                }
            } else {
                self.hideFeature()
                print (error ?? "Error")
            }
        })
    }
    
    func hideFeature() {
        self.backgrounImage.image = UIImage(named: "background")
        self.featureButton.isHidden = true
    }
}

