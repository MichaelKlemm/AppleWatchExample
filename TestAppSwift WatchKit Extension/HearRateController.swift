//
//  HearRateController.swift
//  TestAppSwift
//
//  Created by Michael Klemm on 15.02.16.
//  Copyright © 2016 Michael Klemm. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit


class HearRateController: WKInterfaceController, HKWorkoutSessionDelegate {
    
    let healthStore = HKHealthStore()
    var workoutSession: HKWorkoutSession?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let typesToShare = Set([HKObjectType.workoutType()])
        let typesToRead = Set([
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceCycling)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!
            ])
        
        self.healthStore.requestAuthorizationToShareTypes(typesToShare, readTypes: typesToRead) { (success, error) -> Void in
            print("Okay")
        }
        
    }
    
    func workoutSession(workoutSession: HKWorkoutSession, didChangeToState toState: HKWorkoutSessionState, fromState: HKWorkoutSessionState, date: NSDate) {
        switch toState {
        case .Running:
            print("Switch to running")
            self.workoutDidStart(date)
        case .Ended:
            print("Switch to ended")
            self.workoutDidEnd(date)
        case .NotStarted:
            print("Switch to not started")
        }
    }
    
    func workoutSession(workoutSession: HKWorkoutSession, didFailWithError error: NSError) {
        
    }
    
    private func workoutDidStart(date: NSDate) {
        print("Workout started: \(date)")
        
        let query = self.createStreamingHearRateQuery(date)
        self.healthStore.executeQuery(query)
    }
    
    private func workoutDidEnd(date: NSDate) {
        print("Workout ended: \(date)")
        
        //self.healthStore.stopQuery(<#T##query: HKQuery##HKQuery#>)
    }
    
    func createStreamingHearRateQuery(workoutStartDate: NSDate) -> HKQuery {
        let predicate = HKQuery.predicateForSamplesWithStartDate(workoutStartDate, endDate: nil, options: .None)
        let heartReateType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!
        let query = HKAnchoredObjectQuery(type: heartReateType, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) {
            (query, samples, deletedObjects, anchor, error) -> Void in
            
        }
        query.updateHandler = {
            (query, samples, deletedObjects, anchor, error) -> Void in
            guard let samples = samples as? [HKQuantitySample] else { return }
            guard let quantity = samples.last?.quantity else { return }
            let heartRateUnit = HKUnit(fromString: "count/min")
            print("\(quantity.doubleValueForUnit(heartRateUnit))")
        }
        
        return query
    }
    

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func startNewWorkout() {
        self.workoutSession = HKWorkoutSession(activityType: .Running, locationType: .Outdoor)
        if let session = self.workoutSession {
            session.delegate = self
            self.healthStore.startWorkoutSession(session)
        }
    }
    @IBAction func stopWorkout() {
        if let session = self.workoutSession {
            self.healthStore.endWorkoutSession(session)
        }
    }
}
