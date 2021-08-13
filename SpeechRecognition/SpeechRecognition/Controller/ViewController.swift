//
//  ViewController.swift
//  SpeechRecognition
//
//  Created by Ekaterina Tarasova on 13.08.2021.
//

import UIKit
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var textSpeech: UILabel!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var pauseButton: UIButton!
    @IBOutlet var backgroundView: UIView!
    
    var speechList: [String] = []
    var mySpeechR: [SpeachRecog] = []
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var task: SFSpeechRecognitionTask!
    var isStart = false
    var isPaused = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pauseButton.layer.cornerRadius = 10
        playButton.layer.cornerRadius = 10
        pauseButton.isHidden = true
        gradient()
        
        tableView.dataSource = self
        mySpeechR = DataManager.shared.fetchData()
        tableView.reloadData()
        requestPermission()
    }
    
// MARK: Checking request
    
    func requestPermission(){
        self.playButton.isEnabled = false
        SFSpeechRecognizer.requestAuthorization { (authState) in
            OperationQueue.main.addOperation {
                if authState == .authorized{
                    print("accepted")
                    self.playButton.isEnabled = true
                } else if authState == .denied{
                    print("denied")
                } else if authState == .notDetermined{
                    print("dont determined")
                } else if authState == .restricted{
                    print("restricted")
                }
            }
        }
    }
    
//MARK: Speech Recognization Service
    func startAudioEngine(){
            do {
                try audioEngine.start()
            } catch let error {
                print("\(error.localizedDescription)")
            }
        }

    func startSpeechRecognization(){
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        startAudioEngine()
        
        guard let myRecognization = SFSpeechRecognizer() else {
            print("Recognizationis not allow on your loval")
            return
        }
        if !myRecognization.isAvailable{
            print("try again after some time")
        }
        //Executes the speech recognition request and delivers the results to the specified handler block
        task = speechRecognizer?.recognitionTask(with: request, resultHandler: { (response, error) in
            guard let response = response else {
                if error != nil{
                    print("\(error.debugDescription)")
                }else {
                    print("problem is giving the response")
                }
                return
            }
            let message = response.bestTranscription.formattedString
            self.textSpeech.text = message
            self.speechList.append("\(message)")
        })
    }
    
    func cancelSpeech() {
        task.finish()
        task.cancel()
        task = nil
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
//MARK: UIButton
    @IBAction func playOrStopButton(_ sender: Any) {
        isStart = !isStart
        if isStart {
            startSpeechRecognization()
            playButton.backgroundColor = .red
            playButton.tintColor = .white
            pauseButton.isHidden = false
        } else {
            cancelSpeech()
            playButton.backgroundColor = .white
            playButton.tintColor = .systemIndigo
            pauseButton.isHidden = true
            
            let sp = DataManager.shared.mySpeeches(text: "\(speechList.suffix(1))")
            print("\(speechList.suffix(1))")
            mySpeechR.append(sp)
            self.tableView.reloadData()
            DataManager.shared.saveContext()
        }
    }
    
    @IBAction func pauseButton(_ sender: Any) {
        isPaused = !isPaused
        if isPaused {
            audioEngine.pause()
            pauseButton.tintColor = .red
        } else {
            pauseButton.tintColor = .black
            audioEngine.prepare()
            startAudioEngine()
        }
    }
}
