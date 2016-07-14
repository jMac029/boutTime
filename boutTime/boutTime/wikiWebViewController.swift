//
//  wikiWebViewController.swift
//  boutTime
//
//  Created by James McMillan on 7/13/16.
//  Copyright © 2016 jamesdmcmillan. All rights reserved.
//

import UIKit

class WikiWebViewController: UIViewController {
    
    var wikiUrl = "https://en.wikipedia.org/wiki/HTTP_404"
    

    @IBOutlet weak var wikiWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let requestURL = NSURL(string: wikiUrl)
        let request = NSURLRequest(URL: requestURL!)
        wikiWebView.loadRequest(request)
        
    }
    
    
    @IBAction func closeWikiWebView(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
