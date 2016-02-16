//
//  ViewController.swift
//  TestAppSwift
//
//  Created by Michael Klemm on 15.02.16.
//  Copyright © 2016 Michael Klemm. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        print("Received 2")
        
        let number = message["number"] as! String
        
        
        print(number)
        
        dispatch_async(dispatch_get_main_queue(),{
            self.label.text = number
        })
        
        replyHandler(["number": number])
    }

}

