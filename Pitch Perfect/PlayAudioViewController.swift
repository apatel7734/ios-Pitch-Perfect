//
//  PlayAudioViewController.swift
//  Pitch Perfect
//
//  Created by Ashish Patel on 2/20/15.
//  Copyright (c) 2015 Average Techie. All rights reserved.
//

import UIKit
import AVFoundation

class PlayAudioViewController: UIViewController{
    
    var audioPlayer: AVAudioPlayer!
    var recievedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var pitchEffect: AVAudioUnitTimePitch!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        //get the file code structure
        var path = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3")
        if (path != nil){
        var urlPath = NSURL(fileURLWithPath: path!)
        audioPlayer = AVAudioPlayer(contentsOfURL: urlPath, error: nil)
        audioPlayer.enableRate = true
        }else{
        println("can't find path")
        }
        */
        
        if (recievedAudio.filePathUrl != nil){
            audioPlayer = AVAudioPlayer(contentsOfURL: recievedAudio.filePathUrl, error: nil)
            audioPlayer.enableRate = true
        }else{
            println("can't find path")
        }
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recievedAudio.filePathUrl, error: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didSlowButtonClicked(sender: UIButton) {
        audioPlayer.rate = 0.5
        audioPlayer.stop()
        audioPlayer.play()
        
    }
    
    
    @IBAction func didFastButtonClicked(sender: UIButton) {
        audioPlayer.rate = 2.0
        audioPlayer.stop()
        audioPlayer.play()
    }
    
    @IBAction func didStopButtonClicked(sender: UIButton) {
        audioPlayer.stop()
        audioPlayerNode.stop()
    }
    
    
    
    @IBAction func playChipmonkButtonClick(sender: UIButton) {
        println("Play chipmonk button clicked")
        playAudioWithPitch(1000)
        
    }
    
    
    
    @IBAction func playDarthVaderButtonClicked(sender: UIButton) {
        println("Play darthvader button clicked")
        playAudioWithPitch(-1000)
    }
    
    
    func playAudioWithPitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        //initialize all audio tools
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        pitchEffect = AVAudioUnitTimePitch()
        pitchEffect.pitch = pitch
        audioEngine.attachNode(pitchEffect)
        
        
        audioEngine.connect(audioPlayerNode, to: pitchEffect, format: nil)
        audioEngine.connect(pitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
