//
//  ViewController.swift
//  boutTime
//
//  Created by James McMillan on 7/8/16.
//  Copyright © 2016 jamesdmcmillan. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

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
    let url404 = "https://en.wikipedia.org/wiki/HTTP_404"
    
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
    let playAgainImage = UIImage(named: "play_again")
    
    // Sound Effects Variables
    var gameSound: SystemSoundID = 0
    var gameSoundCorrect: SystemSoundID = 0
    var gameSoundIncorrect: SystemSoundID = 0
    
    
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
    @IBOutlet weak var scoreLabel: UILabel!
    
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
    @IBOutlet weak var playAgainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //roundedCorners()
        gameSetup()
        timerLabel.hidden = true
        
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        //Display game instructions alert to player
        if gameAlertViewed == true {
            
        } else {
            
            displayGameAlert()
            gameAlertViewed = true
        }
    }
    
// MARK: Actions
    
    @IBAction func directionOption(sender: UIButton) {
        
        switch sender.tag {
            
        case 1:
            moveButtonTitles(eventButton01, destinationPos: eventButton02)
            
        case 2:
            moveButtonTitles(eventButton02, destinationPos: eventButton01)
            
        case 3:
            moveButtonTitles(eventButton02, destinationPos: eventButton03)
            
        case 4:
            moveButtonTitles(eventButton03, destinationPos: eventButton02)
            
        case 5:
            moveButtonTitles(eventButton03, destinationPos: eventButton04)

        case 6:
            moveButtonTitles(eventButton04, destinationPos: eventButton03)
        
        default:
            break
        }
        
    }
    
//      Attempted to make Webview for events to work and could not get it to function correctly
//    @IBAction func showWikiWebView(sender: UIButton) {
//        
//        setWikiURL(sender)
//        performSegueWithIdentifier("wikiWebView", sender: self)
//        
//    }

    
    
    @IBAction func nextRound(sender: AnyObject) {
        instructionLabel.text = "Shake to Complete"
        roundQuiz.historicalEvents.removeAll()
        endRoundButton.hidden = true
        updateEventDisplay()
        timerLabel.hidden = false
        beginTimer()
        enableEventButtons(userInteractionEnabled: false)
        enableDirectionButtons(userInteractionEnabled: true)
    }
    
    
    // hide status bar on top of screen
    override func prefersStatusBarHidden() -> Bool {
        return true
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
    
    
    func checkAnswer() {
        
        roundsCompleted += 1
        timer.invalidate()
        
        var orderedEvents = orderEventsPerRound(roundQuiz)
        
        let answer1 = eventButton01.titleLabel?.text
        let answer2 = eventButton02.titleLabel?.text
        let answer3 = eventButton03.titleLabel?.text
        let answer4 = eventButton04.titleLabel?.text
        
        if answer1 == orderedEvents[0].event && answer2 == orderedEvents[1].event && answer3 == orderedEvents[2].event && answer4 == orderedEvents[3].event {
            
            loadGameSoundCorrect()
            playGameSoundCorrect()
            
            correctAnswers += 1
            instructionLabel.text = "Round \(roundsCompleted) of \(rounds)"
            endRoundButton.hidden = false
            endRoundButton.setImage(nextRoundSuccessImage, forState: .Normal)
            enableEventButtons(userInteractionEnabled: false)
            enableDirectionButtons(userInteractionEnabled: false)
            
        } else {
            
            loadGameSoundIncorrect()
            playGameSoundIncorrect()
            
            enableEventButtons(userInteractionEnabled: false)
            enableDirectionButtons(userInteractionEnabled: false)
            instructionLabel.text = "Round \(roundsCompleted) of \(rounds)"
            endRoundButton.hidden = false
            endRoundButton.setImage(nextRoundFailImage, forState: .Normal)
            resetTimer()
            timerLabel.hidden = true
            
        }
        
        if roundsCompleted == rounds {
            
            instructionLabel.text = "Rounds Completed!"
            timerLabel.hidden = true
            //scoreLabel.hidden = false
            //scoreLabel.text = "Your Score: \(correctAnswers) out of \(roundsCompleted)"
            endRoundButton.hidden = true
            playAgainButton.hidden = false
            enableEventButtons(userInteractionEnabled: false)
            enableDirectionButtons(userInteractionEnabled: false)
            resetTimer()
        }
    
    }
    
    func gameSetup() {
        
        roundsCompleted = 0
        index = 0
        endRoundButton.hidden = true
        playAgainButton.hidden = true
        randomEvents(uSHistoryQuiz)
        //uSHistoryQuiz.historicalEvents.removeAll()
        updateEventDisplay()
        timerLabel.hidden = false
        scoreLabel.hidden = true
        instructionLabel.text = "Shake to Complete"
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
    
    func displayGameAlert() {
        
        let gameAlert = UIAlertController(title: "US History Quiz", message: "Order the US History events in chronological order by year from oldest to newest.", preferredStyle: .Alert)
        gameAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (alertAction) -> Void in
            
            self.timerLabel.hidden = false
            self.beginTimer()
            self.instructionLabel.text = "Shake to Complete"
        }))
        
        presentViewController(gameAlert, animated: true, completion: nil)
    }

    // attempt at setting the url for to be passed on the segue, couldn't get it to work correctly
//    func setWikiURL(senderButton: UIButton) -> String {
//        
//        let title = senderButton.currentTitle!
//        
//                for event in uSHistoryQuiz.historicalEvents {
//        
//                    if title == event.event {
//        
//                        wikiUrl = event.url
//                    }
//                }
//        
//        return url404
//    }

    
// MARK: Shake Feature
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
        //Detect shake motion
        if motion == .MotionShake {
            
            resetTimer()
            checkAnswer()
        }
    }


// MARK: Helper Methods


    func roundedCorners () {
        
        for view in eventButtons {
            
            view.layer.cornerRadius = 5
            view.clipsToBounds = true
        }
    }
    
    // Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "displayScoreSegue" {
            
            if let destination = segue.destinationViewController as? EndGameController {
                
                destination.correctAnswers = self.correctAnswers
            }
            
        }
//      segue for webview feature, couldn't get it to function correctly
//        if segue.identifier == "wikiWebView" {
//            
//            if let destination = segue.destinationViewController as? WikiWebViewController {
//                destination.wikiUrl = self.wikiUrl
//            }
//        }
    }
    
    @IBAction func unwind(unwindSegue: UIStoryboardSegue) {
        
        if unwindSegue.identifier == "unwindSegue" {
            
            gameSetup()
            beginTimer()
        }
    }
    
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
    
    func moveButtonTitles(originalPos: UIButton, destinationPos: UIButton) {
        
        //Swap button titles.
        let firstButtonTitle = originalPos.titleForState(.Normal)
        let secondButtonTitle = destinationPos.titleForState(.Normal)
        
        originalPos.setTitle(secondButtonTitle, forState: .Normal)
        destinationPos.setTitle(firstButtonTitle, forState: .Normal)
    }

// Lightning Timer Methods copied over from Project 2 and modified for use in this project

    func beginTimer() {
    
        if timerRunning == false {
        
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.countdownTimer), userInfo: nil, repeats: true)
        
            timerRunning = true
        }
        
        
    }

    func countdownTimer() {
    
        // countdown by 1 second
    
        seconds -= 1
    
        timerLabel.text = "0:\(seconds)"
    
        if seconds == 0 {
        
            timer.invalidate()
        
            roundsCompleted += 1
            
            instructionLabel.text = "Time's UP!"
            
            checkAnswer()
            resetTimer()
        
            enableEventButtons(userInteractionEnabled: false)
            enableDirectionButtons(userInteractionEnabled: false)
        
        }
        
        // update timerLabel so that seconds show correctly
        if seconds < 10 {
            timerLabel.text = "0:0\(seconds)"
        }
    
    }

    func resetTimer() {
    
    seconds = 60
    timerLabel.text = "0:\(seconds)"
    timerRunning = false
    
    }
    
    // Sound effects helper methods, many of these were copied over from Project 2
        
        func loadGameSoundCorrect() {
            let pathToSoundFile = NSBundle.mainBundle().pathForResource("GameSoundCorrectDing", ofType: "wav")
            let soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
            AudioServicesCreateSystemSoundID(soundURL, &gameSoundCorrect)
        }
        
        func playGameSoundCorrect() {
            AudioServicesPlaySystemSound(gameSoundCorrect)
        }
        
        func loadGameSoundIncorrect() {
            let pathToSoundFile = NSBundle.mainBundle().pathForResource("GameSoundIncorrectBuzz", ofType: "wav")
            let soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
            AudioServicesCreateSystemSoundID(soundURL, &gameSoundIncorrect)
        }
        
        func playGameSoundIncorrect() {
            AudioServicesPlaySystemSound(gameSoundIncorrect)
        }
    

}