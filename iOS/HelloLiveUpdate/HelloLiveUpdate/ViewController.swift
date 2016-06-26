//
//  ViewController.swift
//  HelloLiveUpdate
//
//  Created by Ishai Borovoy on 26/06/2016.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit
import IBMMobileFirstPlatformFoundationLiveUpdate

class ViewController: UIViewController {
    var audioUtils = WatsonAudioUtils()
    var langauge = "EN"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func helloLiveUpdate(sender: AnyObject) {
        LiveUpdateManager.sharedInstance.obtainConfiguration(langauge) { (configuration, error) in
            if error == nil {
                if let text = configuration!.getProperty("helloText") , let voice = configuration!.getProperty("voice"){
                    self.audioUtils.playVoice(text, voice: voice, completionHandler: {
                        "Finish playing \(text)"
                    })
                }
            } else {
                print (error)
            }
        }
    }
    
    @IBAction func selectLangauge(sender: AnyObject) {
        let current = sender as! UIButton;
        langauge = current.currentTitle!
    }
}

