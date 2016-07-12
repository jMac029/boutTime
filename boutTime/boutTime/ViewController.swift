//
//  ViewController.swift
//  boutTime
//
//  Created by James McMillan on 7/8/16.
//  Copyright © 2016 jamesdmcmillan. All rights reserved.
//

import UIKit
import GameKit

class ViewController: UIViewController {
    
// MARK: Global variables
    
    // Quiz Variables
    var uSHistoryQuiz: USHistorialEventsQuiz
    var shuffledEvents = USHistorialEventsQuiz(historicalEvents: [])
    var roundQuiz = USHistorialEventsQuiz(historicalEvents: [])
    var correctAnswers = 0
    var roundsCompleted = 0
    let rounds = 6
    var index = 0
    
    // Timer Variables
    var timer = NSTimer()
    var seconds = 60
    var timerRunning = false
    
    // Sound Effects Variables
    let loadCorrectSound = SoundEffects.loadGameSoundCorrect(<#T##SoundEffects#>)
    let playCorrectSound = SoundEffects.playGameSoundCorrect(<#T##SoundEffects#>)
    let loadIncorrectSound = SoundEffects.loadGameSoundIncorrect(<#T##SoundEffects#>)
    let playIncorrectSound = SoundEffects.playGameSoundIncorrect(<#T##SoundEffects#>)
    let loadFinishedSound = SoundEffects.loadGameSoundFinished(<#T##SoundEffects#>)
    let playFinishedSound = SoundEffects.playGameSoundFinished(<#T##SoundEffects#>)
    let loadRetrySound = SoundEffects.loadGameSoundRetry(<#T##SoundEffects#>)
    let playRetySound = SoundEffects.playGameSoundRetry(<#T##SoundEffects#>)
    let loadTimerEndSound = SoundEffects.loadGameSoundTimerEnd(<#T##SoundEffects#>)
    let playTimerEndSound = SoundEffects.playGameSoundTimerEnd(<#T##SoundEffects#>)
    
// MARK: Labels
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    
// MARK: Buttons
    
    @IBOutlet weak var eventButton01: UIButton!
    @IBOutlet weak var eventButton02: UIButton!
    @IBOutlet weak var eventButton03: UIButton!
    @IBOutlet weak var eventButton04: UIButton!
    
    @IBOutlet weak var downButton01: UIButton!
    @IBOutlet weak var upButton01: UIButton!
    @IBOutlet weak var downButton02: UIButton!
    @IBOutlet weak var upButton02: UIButton!
    @IBOutlet weak var downButton03: UIButton!
    @IBOutlet weak var upButton03: UIButton!
    
    @IBOutlet weak var endRoundButton: UIButton!
    
    
// MARK: Init
    
// Initializer to unarchive plist file of US Historical Events, copied from Vending Machine App course
    
    required init?(coder aDecoder: NSCoder) {
        do {
            let array = try PlistConverter.arrayFromFile("USHistoryEvents", ofType: "plist")
            self.uSHistoryQuiz = USHistorialEventsQuiz(historicalEvents: HistoricalEventsUnarchiver.historicalEventsFromArray(array))
        } catch let error {
            fatalError("\(error)")
        }
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }




// MARK: Helper Methods

// Lightning Timer Methods copied over from Project 2 and modified for use in this project

    func beginTimer() {
    
        if timerRunning == false {
        
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.countdownTimer), userInfo: nil, repeats: true)
        
            timerRunning = true
        }
    }

    func countdownTimer() {
    
        //let selectedQuestionDict = olympicTriviaQuestions[indexOfSelectedQuestion]
        //let correctAnswer = selectedQuestionDict.correctAnswer
    
        // countdown by 1 second
    
        seconds -= 1
    
        timerLabel.text = "0:\(seconds)"
    
        if seconds == 0 {
        
            timer.invalidate()
        
            roundsCompleted += 1
        
            loadTimerEndSound()
            playTimerEndSound()
        
            //disableButtons()
        
        }
    
    }

    func resetTimer() {
    
    seconds = 60
    timerLabel.text = "0:\(seconds)"
    timerRunning = false
    
    }
    

}