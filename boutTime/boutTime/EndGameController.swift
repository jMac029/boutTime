//
//  EndGameController.swift
//  boutTime
//
//  Created by James McMillan on 7/13/16.
//  Copyright © 2016 jamesdmcmillan. All rights reserved.
//

import UIKit

class EndGameController: UIViewController {
    
    var correctAnswers = 0
    let roundsCompleted = 6
    
    
    @IBOutlet weak var scoreLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayScore()
    }
    
    

    @IBAction func playAgain() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        self.performSegueWithIdentifier("unwindSegue", sender: UIButton.self)
    }
    

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func displayScore() {
        
        if correctAnswers == roundsCompleted {
            scoreLabel.text = "Congratulations! \nYou've Aced the Quiz! \nwith a score of \(correctAnswers) out of 6"
        } else if correctAnswers < roundsCompleted {
            scoreLabel.text = "Time to brush up on your \nU.S. History! \nyou scored \(correctAnswers) out of 6"
        }
    }

}
