//
//  SpeechService.swift
//  SpeechRecognition
//
//  Created by Ekaterina Tarasova on 13.08.2021.
//

import UIKit
import Speech

func startSpeechRecognization(audioEngine: AVAudioEngine,speechRecognizer: SFSpeechRecognizer, request: SFSpeechAudioBufferRecognitionRequest, task: inout SFSpeechRecognitionTask, list:inout [String], label: UILabel) {
    let node = audioEngine.inputNode
    let recordingFormat = node.outputFormat(forBus: 0)
    node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
        request.append(buffer)
    }
    
    audioEngine.prepare()
    do {
        try audioEngine.start()
    } catch let error {
        print("\(error.localizedDescription)")
    }
    
    guard let myRecognization = SFSpeechRecognizer() else {
        print("Recognizationis not allow on your loval")
        return
    }
    if !myRecognization.isAvailable{
        print("try again after some time")
    }
    
    task = speechRecognizer.recognitionTask(with: request, resultHandler: { (response, error) in
        guard let response = response else {
            if error != nil{
                print("\(error.debugDescription)")
            }else {
                print("problem is giving the response")
            }
            return
        }
        let message = response.bestTranscription.formattedString
        label.text = message
        list.append("\(message)")
    })
}
