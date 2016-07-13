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
    var randomEventsQuiz = USHistorialEventsQuiz(historicalEvents: [])
    var roundQuiz = USHistorialEventsQuiz(historicalEvents: [])
    var correctAnswers = 0
    var roundsCompleted = 0
    let rounds = 6
    var index = 0
    var wikiUrl = ""
    var gameAlertViewed = false
    
    // Timer Variables
    var timer = NSTimer()
    var seconds = 60
    var timerRunning = false
    
    // Button Arrays
    
    var eventButtons: [UIButton] = []
    var directionButtons: [UIButton] = []
    
    // Button Images
    
    let nextRoundFailImage = UIImage(named: "next_round_fail")
    let nextRoundSuccessImage = UIImage(named: "next_round_success")
    
    // Sound Effects Variables
//    let loadCorrectSound = SoundEffects.loadGameSoundCorrect(<#T##SoundEffects#>)
//    let playCorrectSound = SoundEffects.playGameSoundCorrect(<#T##SoundEffects#>)
//    let loadIncorrectSound = SoundEffects.loadGameSoundIncorrect(<#T##SoundEffects#>)
//    let playIncorrectSound = SoundEffects.playGameSoundIncorrect(<#T##SoundEffects#>)
//    let loadFinishedSound = SoundEffects.loadGameSoundFinished(<#T##SoundEffects#>)
//    let playFinishedSound = SoundEffects.playGameSoundFinished(<#T##SoundEffects#>)
//    let loadRetrySound = SoundEffects.loadGameSoundRetry(<#T##SoundEffects#>)
//    let playRetySound = SoundEffects.playGameSoundRetry(<#T##SoundEffects#>)
//    let loadTimerEndSound = SoundEffects.loadGameSoundTimerEnd(<#T##SoundEffects#>)
//    let playTimerEndSound = SoundEffects.playGameSoundTimerEnd(<#T##SoundEffects#>)

    
    
    
    
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
    
// MARK: Outlets
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    
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
        
        gameSetup()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        //Display game instructions alert to player
        if gameAlertViewed == true {
            
        } else {
            
            displayGameAlert()
            gameAlertViewed = true
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK: Game Functions
    
    func updateEventDisplay() {
        
        if index >= randomEventsQuiz.historicalEvents.count {
            
        } else {
            eventButton01.setTitle(randomEventsQuiz.historicalEvents[index].event, forState: .Normal)
            eventButton02.setTitle(randomEventsQuiz.historicalEvents[index + 1].event, forState: .Normal)
            eventButton03.setTitle(randomEventsQuiz.historicalEvents[index + 2].event, forState: .Normal)
            eventButton04.setTitle(randomEventsQuiz.historicalEvents[index + 3].event, forState: .Normal)
            
            roundQuiz.historicalEvents.append(randomEventsQuiz.historicalEvents[index])
            roundQuiz.historicalEvents.append(randomEventsQuiz.historicalEvents[index + 1])
            roundQuiz.historicalEvents.append(randomEventsQuiz.historicalEvents[index + 2])
            roundQuiz.historicalEvents.append(randomEventsQuiz.historicalEvents[index + 3])
            
            index += 4
        }
        
    }
    
    
    func gameSetup() {
        
        roundsCompleted = 0
        index = 0
        endRoundButton.hidden = true
        randomEvents(uSHistoryQuiz)
        uSHistoryQuiz.historicalEvents.removeAll()
        updateEventDisplay()
        timerLabel.hidden = false
        enableEventButtons(userInteractionEnabled: false)
        enableDirectionButtons(userInteractionEnabled: true)
    }
    
    func randomEvents(historyQuiz: USHistorialEventsQuiz) {
        
        // select random historical events from the USHistoryEvents array and not repeated
        
        let randomEvents = USHistorialEventsQuiz(historicalEvents: GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(uSHistoryQuiz.historicalEvents) as! [HistoricalEvents])
        
        randomEventsQuiz = randomEvents
    }
    
    func orderEventsPerRound(events: USHistorialEventsQuiz) -> [HistoricalEvents] {
        
        // Sort historical events by date in ascending order
        return events.historicalEvents.sort({$1.year > $0.year})
    }
    
    func checkAnswer() {
        
        roundsCompleted += 1
        
    }
    
    func displayGameAlert() {
        
        let gameAlert = UIAlertController(title: "US History Quiz", message: "Order the US History events in chronological order by year from oldest to newest.", preferredStyle: .Alert)
        gameAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (alertAction) -> Void in
            
            self.beginTimer()
        }))
        
        presentViewController(gameAlert, animated: true, completion: nil)
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
        
//            loadTimerEndSound()
//            playTimerEndSound()
        
            //disableButtons()
        
        }
    
    }

    func resetTimer() {
    
    seconds = 60
    timerLabel.text = "0:\(seconds)"
    timerRunning = false
    
    }
    

}