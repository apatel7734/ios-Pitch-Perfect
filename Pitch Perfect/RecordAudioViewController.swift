//
//  RecordAudioViewController.swift
//  Pitch Perfect
//
//  Created by Ashish Patel on 2/20/15.
//  Copyright (c) 2015 Average Techie. All rights reserved.
//

import UIKit
import AVFoundation

class RecordAudioViewController: UIViewController,AVAudioRecorderDelegate {
    
    
    @IBOutlet weak var recordingLabel: UILabel!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //hide stop button
        stopButton.hidden = true
        recordButton.enabled = true
        recordingLabel.hidden = false
        recordingLabel.text = "Tap to record"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //interface builder action means connected to some UI event
    @IBAction func didRecordButtonClicked(sender: UIButton) {
        stopButton.hidden = false
        recordButton.enabled = false
        recordingLabel.text = "Recording..."
        
        //start recording audio
        recordAudio()
    }
    
    
    func recordAudio(){
        
        //search and find directory path in current document directory
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        // get the current date and time object
        let currentDateTime = NSDate()
        // instance of date formatter
        let formatter = NSDateFormatter()
        //assign formate of date time
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        //create recording file name based on current date time
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        // get the path using array of directory name and file name
        let pathArray = [dirPath,recordingName]
        //return filepath in NSURL formate
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        /**
        returns singleton audio session that helps to activate/deactivate audio session
        Set the audio session category and mode in order to communicate to the system how you intend to use audio in your app
        */
        var session = AVAudioSession.sharedInstance()
        // session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker, error: nil)
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        //enabled metering meaning we can set desible level later while play or make changes
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func stopRecording(){
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    
    @IBAction func didStopRecordingButtonClickec(sender: UIButton) {
        recordingLabel.hidden = true
        stopButton.hidden = true
        recordButton.enabled=true
        
        //stop recording
        stopRecording()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag{
            var audioTitle = recorder.url.lastPathComponent
            recordedAudio = RecordedAudio(pathUrl: recorder.url, title: audioTitle!)
            self.performSegueWithIdentifier("stopRecordingSegue", sender: recordedAudio)
        }else{
            println("Unsuccessful attempt of recording audio")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecordingSegue"){
            let playAudioVC: PlayAudioViewController = segue.destinationViewController as PlayAudioViewController
            let data = sender as RecordedAudio
            playAudioVC.recievedAudio = data
        }
    }
    
    
    
    
}

