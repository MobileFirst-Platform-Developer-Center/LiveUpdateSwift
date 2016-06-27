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
    var langauge = "US"
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
        LiveUpdateManager.sharedInstance.obtainConfiguration(langauge) { (configuration, error) in
            if error == nil {
                
                if let isVoiceEnabled = configuration!.isFeatureEnabled("isVoiceEnabled"), let helloText = configuration!.getProperty("helloText") , let voice = configuration!.getProperty("voice"){
                    if (isVoiceEnabled) {
                        self.audioUtils.playVoice(helloText, voice: voice, completionHandler: {
                            "Finish playing \(helloText)"
                        })
                    } else {
                        let alert = UIAlertController(title: "Live Update", message: helloText, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
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
        langauge = current!.restorationIdentifier!
    }
}

