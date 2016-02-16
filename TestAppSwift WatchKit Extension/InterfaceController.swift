//
//  InterfaceController.swift
//  TestAppSwift WatchKit Extension
//
//  Created by Michael Klemm on 15.02.16.
//  Copyright © 2016 Michael Klemm. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {

    @IBOutlet var button: WKInterfaceButton!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func buttonPushed() {
        print("buttonPushed() called")
        
        let session = WCSession.defaultSession()
        
        let message = ["number": "18"]
        
        session.sendMessage(message,
            replyHandler: {
                (params: [String : AnyObject]) -> Void in print("reply received")
                
                let number = params["number"] as! String
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.button.setTitle(number)
                })
            }, errorHandler:  {
                (error) -> Void in print("error happened")
        })
    }
}
