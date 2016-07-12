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
    
    // Button Arrays
    
    var eventButtons: [UIButton] = []
    var directionButtons: [UIButton] = []
    
    
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
        
        // Adding Buttons to button arrays
        
        eventButtons.append(eventButton01)
        eventButtons.append(eventButton02)
        eventButtons.append(eventButton03)
        eventButtons.append(eventButton04)
        
        directionButtons.append(downButton01)
        directionButtons.append(downButton02)
        directionButtons.append(downButton03)
        directionButtons.append(upButton01)
        directionButtons.append(upButton02)
        directionButtons.append(upButton03)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK: Game Functions
    
    func checkAnswer() {
        
        roundsCompleted += 1
        
    }

    
// MARK: Shake Feature
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
        //Detect shake motion
        if motion == .MotionShake {
            
            resetTimer()
            checkAnswer()
        }
    }


// MARK: Helper Methods
    
    // Helper Method to enable and disable the buttons after user has answered a question or began another round
    
    func enableEventButtons(userInteractionEnabled bool : Bool) {
        
        for buttons in eventButtons {
            
            if bool == true {
                buttons.userInteractionEnabled = true
            } else {
                buttons.userInteractionEnabled = false
            }
        }
        
    }
    
    func enableDirectionButtons(userInteractionEnabled bool : Bool) {
        
        for buttons in directionButtons {
            
            if bool == true {
                buttons.userInteractionEnabled = true
            } else {
                buttons.userInteractionEnabled = false
            }
        }
    }

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