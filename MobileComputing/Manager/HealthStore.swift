/*
    The HealthStore class is used to manage the user request to allow HealthKit Access,
    as well as query data for the users steps.
    In this project, StepData is simply queried when it's needed.
    It is possible to fire a long-running query, but the HealthStore only updates its StepData itself once every hour.
    Manually triggering the query before that, though, will fetch a somewhat precise stepCount for that point in time.
 
    setup code roughly based on: https://github.com/azamsharp/SwiftUIHealthKit
 
    * class:        HealthKitManager
    * functions:    requestAuthorization
                    getQueriedSteps
                    fetchDaySteps
*/

import Foundation
import HealthKit

class HealthStore: ObservableObject {
    
    private var queriedSteps: Double?
    
    private var healthStore: HKHealthStore?
    private var query: HKStatisticsCollectionQuery?
    
    private let dateFormatter = ISO8601DateFormatter()
    
    init() {
        // HealthKit is available from iOS 8.0, iPadOS 8.0 and watchOS 2.0 and upwards
        // currently in Beta for macOS 14.0 and Mac Catalyst 17.0
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    func fetchDaySteps(chosenDay: String) {
        let steps = HKQuantityType(.stepCount)
        
        let dayStartISO = chosenDay + "T00:00:00+0000"          // add start time for day in ISO-format
        let dayEndISO = chosenDay + "T23:59:00+0000"            // add end time for day in ISO-format

        let startDate = dateFormatter.date(from:dayStartISO)    // generate Date()-Objects from ISO-Strings
        let endDate = dateFormatter.date(from:dayEndISO)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        // options: .cumulativeSum -> determines the actual step data, if data is collected through more than
        // just the iPhone (e.g. additional AppleWatch)
        // otherwise the step count would be higher than the actual steps.
        let query = HKStatisticsQuery(
            quantityType: steps,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fetching data")
                return
            }
            
            self.queriedSteps = quantity.doubleValue(for: .count())
        }
        healthStore?.execute(query)
    }
    
    func getQueriedSteps() -> Double {
        return self.queriedSteps ?? 0       // if queriedSteps is nil, return 0
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        // stepType defines, what kind of data we want to query. In this case: only stepCount
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        // if healthStore cannot be initialized, return from function call with "false"
        // this can be the case if for example HealthKit is not available on the device
        guard let healthStore = self.healthStore else { return completion(false) }
        
        // request authorization from User
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { (success, error) in
            completion(success)
        }
        
    }
    
}
