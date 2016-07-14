//
//  EndGameController.swift
//  boutTime
//
//  Created by James McMillan on 7/13/16.
//  Copyright © 2016 jamesdmcmillan. All rights reserved.
//

import UIKit

class EndGameController: UIViewController {
    
    //-----------------------
    //MARK: Variables
    //-----------------------
    var correctAnswers: Int = 0
    
    //-----------------------
    //MARK: Outlets
    //-----------------------
    @IBOutlet weak var scoreLabel: UILabel!
    
    //-----------------------
    //MARK: View
    //-----------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = "You scored \(correctAnswers) out of 6"
    }
    
    //-----------------------
    //MARK: Button Actions
    //-----------------------
    @IBAction func playAgain() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //-----------------------
    //MARK: Extra
    //-----------------------
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
