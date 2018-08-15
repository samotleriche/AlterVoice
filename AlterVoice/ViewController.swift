//
//  ViewController.swift
//  AlterVoice
//
//  Created by Tomas Leriche on 8/14/18.
//  Copyright © 2018 Tomas Leriche. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopRecordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecordButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(_ sender: Any) {
        recordingLabel.text = "recording in progress"
        recordButton.isEnabled = false
        stopRecordButton.isEnabled = true
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        recordingLabel.text = "tap to record"
        recordButton.isEnabled = true
        stopRecordButton.isEnabled = false
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
        performSegue(withIdentifier: "toSecondView", sender: audioRecorder.url)
        }else{
            print("recording failed")
        }
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSecondView" {
            let playSoundsVC = segue.destination as! AnalysisViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

