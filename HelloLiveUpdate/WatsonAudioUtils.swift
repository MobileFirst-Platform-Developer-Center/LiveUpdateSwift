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
//  WatsonAudioUtils.swift
//  HelloLiveUpdate
//
//  Created by Ishai Borovoy on 07/06/2016.
//

import Foundation
import AVFoundation
import IBMMobileFirstPlatformFoundation

public class WatsonAudioUtils : NSObject,AVAudioPlayerDelegate{

    override public init() {
          super.init()
    }
    
    var playAudioComplitionHandler:()-> Void = {print("Finish playing")}
    var audioPlayer:AVAudioPlayer?
    
    //Play section
    public func playVoice (text : String, voice: String, completionHandler:()-> Void) {
        self.playAudioComplitionHandler = completionHandler
        let textToSpeechRequest = WLResourceRequest (URL: NSURL(string: "/adapters/textToSpeechAdapter/textToSpeech"), method: WLHttpMethodGet, scope: "configuration-user-login")
        
        textToSpeechRequest.queryParameters = ["text" : text, "voice" : voice]
        textToSpeechRequest.sendWithCompletionHandler { (response, error) in
            if (error == nil) {
                do {
                    
                    let data = NSMutableData (data: response.responseData)
                    WatsonAudioUtils.repairWAVHeader (data)
                    self.audioPlayer = try AVAudioPlayer(data: data)
                    self.audioPlayer!.delegate = self
                    
                    // check if audioPlayer is prepared to play audio
                    if (self.audioPlayer!.prepareToPlay())
                    {
                        self.audioPlayer!.volume = 1.0
                        self.audioPlayer!.play()
                    }
                } catch {
                    print(error)
                }
                
            } else {
                print (error)
            }
        }
    }
    
    //player delegates
    public func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print ("audioPlayerDidFinishPlaying")
        playAudioComplitionHandler ()
    }
    
    //Fix Wav Section
    private  static func dataToUTF8String(data: NSData, offset: Int, length: Int) -> String? {
        let range = NSMakeRange(offset, length)
        let subdata = data.subdataWithRange(range)
        return String(data: subdata, encoding: NSUTF8StringEncoding)
    }
    
    
    private static func dataToUInt32(data: NSData, offset: Int) -> Int {
        var num: UInt32 = 0
        let length = 4
        let range = NSMakeRange(offset, length)
        data.getBytes(&num, range: range)
        return Int(num)
    }
    
    
    private static func repairWAVHeader(data: NSMutableData) {
        // resources for WAV header format:
        // [1] http://unusedino.de/ec64/technical/formats/wav.html
        // [2] http://soundfile.sapp.org/doc/WaveFormat/
        
        // update RIFF chunk size
        let fileLength = data.length
        var riffChunkSize = UInt32(fileLength - 8)
        let riffChunkSizeRange = NSMakeRange(4, 4)
        data.replaceBytesInRange(riffChunkSizeRange, withBytes: &riffChunkSize)
        
        // find data subchunk
        var subchunkID: String?
        var subchunkSize = 0
        var fieldOffset = 12
        let fieldSize = 4
        while true {
            // prevent running off the end of the byte buffer
            if fieldOffset + 2*fieldSize >= data.length {
                return
            }
            
            // read subchunk ID
            subchunkID = dataToUTF8String(data, offset: fieldOffset, length: fieldSize)
            fieldOffset += fieldSize
            if subchunkID == "data" {
                break
            }
            
            // read subchunk size
            subchunkSize = dataToUInt32(data, offset: fieldOffset)
            fieldOffset += fieldSize + subchunkSize
        }
        
        // compute data subchunk size (excludes id and size fields)
        var dataSubchunkSize = UInt32(data.length - fieldOffset - fieldSize)
        
        // update data subchunk size
        let dataSubchunkSizeRange = NSMakeRange(fieldOffset, fieldSize)
        data.replaceBytesInRange(dataSubchunkSizeRange, withBytes: &dataSubchunkSize)
    }
}