//
//  PedometerController.swift
//  TestAppSwift
//
//  Created by Michael Klemm on 15.02.16.
//  Copyright © 2016 Michael Klemm. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion


class PedometerController: WKInterfaceController {
    
    let pedometer = CMPedometer()

    @IBOutlet var steps: WKInterfaceLabel!
    @IBOutlet var distance: WKInterfaceLabel!
    @IBOutlet var floorsAsc: WKInterfaceLabel!
    @IBOutlet var floorsDesc: WKInterfaceLabel!
    @IBOutlet var pace: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        super.willActivate()
        
        let date = NSDate()
        
        self.pedometer.startPedometerUpdatesFromDate(date) {
            (pedometerData, error) -> Void in
            print("pedometer update received")
            print("data: \(pedometerData)")
            if let data = pedometerData {
                self.updateLabelsWithData(data)
            } else {
                print("Error on cast")
            }
        }
    }
    
    private func updateLabelsWithData(pedometerData: CMPedometerData) {
        let stepsVal = pedometerData.numberOfSteps.floatValue
        let distanceVal = pedometerData.distance?.floatValue
        let floorsAscVal = pedometerData.floorsAscended?.doubleValue
        let floorsDescVal = pedometerData.floorsDescended?.doubleValue
        let paceVal = pedometerData.currentPace?.doubleValue
        
        self.steps.setText("steps: \(stepsVal)")
        self.distance.setText("distance: \(distanceVal)")
        self.floorsAsc.setText("oscended: \(floorsAscVal)")
        self.floorsDesc.setText("descended: \(floorsDescVal)")
        self.pace.setText("pace: \(paceVal)")
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
