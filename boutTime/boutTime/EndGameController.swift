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
    
    
    @IBOutlet weak var scoreLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = "You scored \(correctAnswers) out of 6"
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
}
