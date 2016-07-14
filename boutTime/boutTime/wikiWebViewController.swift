//
//  wikiWebViewController.swift
//  boutTime
//
//  Created by James McMillan on 7/13/16.
//  Copyright © 2016 jamesdmcmillan. All rights reserved.
//

import UIKit

class WikiWebViewController: UIViewController {
    
    var wikiUrl = ""
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let requestedURL = NSURL(string: wikiUrl)
        let request = NSURLRequest(URL: requestedURL!)
        webView.loadRequest(request)
        
    }
    
    
    
    @IBAction func closeWikiView(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
