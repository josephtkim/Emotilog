//
//  NewEntryViewController.swift
//  Journal
//
//  Created by Isaac Kim on 6/10/17.
//  Copyright © 2017 kimbros. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class NewEntryViewController: UIViewController, AVAudioPlayerDelegate, SFSpeechRecognizerDelegate {
    
    // Variables
    var newEntry: [String] = []
    var questionOneCompleted = false
    var questionTwoCompleted = false

    var mood = ""
    var entry = ""
    
    // Speech synthesizer (Question to speech)
    let speechSynth = AVSpeechSynthesizer()
    
    func sayQuestion() {
        let currentQuestion = AVSpeechUtterance(string: currentLabel.text!)
        speechSynth.speak(currentQuestion)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()
    }

    // Buttons and Labels
    @IBOutlet weak var startEntryButton: UIButton!
    @IBAction func startEntryPressed(_ sender: UIButton) {
        currentLabel.text = "How are you doing today?"
        currentLabel.isHidden = true
        currentResponseTextView.isHidden = false
        
        //sayQuestion()
        
        Thread.sleep(forTimeInterval: 1)
    
        DoneButton.isHidden = false
    }
    
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var currentResponseTextView: UITextView!
    
    @IBOutlet weak var DoneButton: UIButton!
    
    @IBOutlet weak var NoButton: UIButton!
    @IBOutlet weak var YesButton: UIButton!
    
    @IBAction func NoButtonPressed(_ sender: UIButton) {
        resetPage()
    }
    
    @IBAction func YesButtonPressed(_ sender: UIButton) {
        // Add new data
        entries.append(entry)
        emotions.append(moodEvaluation(input: mood))
        
        // Current date stamp
        let currentDateTime = Date()
        
        // Initialize date formatter and style
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        
        dates.append(formatter.string(from: currentDateTime).lowercased())
        
        print("Saving mood: \(moodEvaluation(input: mood)) and entry: \(entry) to table")
        resetPage()
    }
    
    @IBAction func DoneButtonPressed(_ sender: UIButton) {
        
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            DoneButton.isEnabled = false
            
            // Record answers
            if (!questionOneCompleted) {
                self.mood = currentResponseTextView.text
                questionOneCompleted = true
                print("First question is answered")
                
                currentLabel.isHidden = false
                currentResponseTextView.isHidden = true
                currentLabel.text = "I see. Can you tell me more about your day?"
                //sayQuestion()
            }
            else if (!questionTwoCompleted) {
                self.entry = currentResponseTextView.text
                questionTwoCompleted = true
                print("Second question is answered")
                
                currentLabel.isHidden = false
                currentResponseTextView.isHidden = true
                currentLabel.text = "Thank you. Would you like to save the entry?"
                //sayQuestion()
                
                DoneButton.isHidden = true
                startEntryButton.isHidden = true
                
                NoButton.isHidden = false
                YesButton.isHidden = false
            }
            DoneButton.setImage(UIImage(named: "Record_150.png"), for: .normal)
            
        } else {
            startRecording()
            
            currentLabel.isHidden = true
            currentResponseTextView.isHidden = false
            
            DoneButton.setImage(UIImage(named: "Stop_150.png"), for: .normal)
        }
    }
    
    
    // Take mood string and determine mood 
    func moodEvaluation(input: String) -> String {
        let joyKeywords: [String] = ["glad", "happy", "good", "great", "awesome"]
        let sadKeywords: [String] = ["sad", "awful", "depressed", "afraid", "lonely"]
        let angryKeywords: [String] = ["angry", "mad", "frustrated", "annoyed", "irritated"]
        let neutralKeywords: [String] = ["fine", "okay", "nothing", "neutral"]
        
        let words = input.components(separatedBy: " ")
        
        for word in words {
            if joyKeywords.contains(word.lowercased()) {
                return "happy"
            }
            else if sadKeywords.contains(word.lowercased()) {
                return "sad"
            }
            else if angryKeywords.contains(word.lowercased()) {
                return "anger"
            }
            else if neutralKeywords.contains(word.lowercased()) {
                return "neutral"
            }
        }
        
        return "neutral"
    }
    

    // Speech recognizer
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    
    func recordVoice() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            DoneButton.isEnabled = false
            DoneButton.setImage(UIImage(named: "Record_150.png"), for: .normal)
        } else {
            startRecording()
            DoneButton.setImage(UIImage(named: "Stop_150.png"), for: .normal)
        }
    }
    
    // Recording function
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.currentResponseTextView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.DoneButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            DoneButton.isEnabled = true
        } else {
            DoneButton.isEnabled = false
        }
    }
    
    
    func resetPage() {
        DoneButton.isHidden = true
        startEntryButton.isHidden = false
        NoButton.isHidden = true
        YesButton.isHidden = true
        
        newEntry = []
        
        
        currentLabel.isHidden = false
        currentResponseTextView.isHidden = true
        
        currentLabel.text = "Press microphone to start a new entry."
        
        questionOneCompleted = false
        questionTwoCompleted = false
        
        mood = ""
        entry = ""
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetPage()
        
        // Allow exit out of keyboard by tapping anywhere else on screen
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        // record
        DoneButton.isEnabled = false
        
        speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not determined")
            }
            
            OperationQueue.main.addOperation() {
                self.DoneButton.isEnabled = isButtonEnabled
            }
            
        }
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
