//
//  TrainingMainViewController.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/20/24.
//

import UIKit
import HealthKit

class TrainingMainViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var vProgressRing: UIView!
    @IBOutlet weak var lbTotalPoints: UILabel!
    @IBOutlet weak var lbWalkingDistance: UILabel!
    @IBOutlet weak var lbTrainingTime: UILabel!
    
    
    // MARK: - Properties
    
    var healthStore: HKHealthStore?
    

    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupHealthStore()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateStepCount()
    }
    
    // MARK: - UI Settings
    
    fileprivate func setupUI() {
        lbTotalPoints.text = "\(UserPreferences.shared.totalScore)"
    }
    
    func setupHealthStore() {
            if HKHealthStore.isHealthDataAvailable() {
                healthStore = HKHealthStore()
                let allTypes = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
                healthStore?.requestAuthorization(toShare: nil, read: allTypes) { (success, error) in
                    if !success {
                        print("HealthKit authorization denied! \(error?.localizedDescription ?? "No error provided")")
                    } else {
                        DispatchQueue.main.async {
                            self.updateStepCount()
                        }
                    }
                }

            }
        }
    
    
    // MARK: - Function
    
    func updateStepCount() {
        guard let healthStore = healthStore else { return }
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { [weak self] _, result, error in
            guard let self = self else { return }
            var stepCount = 0.0
            if let sum = result?.sumQuantity() {
                stepCount = sum.doubleValue(for: HKUnit.count())
            }
            
            DispatchQueue.main.async {
                self.lbWalkingDistance.text = "\(Int(stepCount))"
            }
        }
        healthStore.execute(query)
    }
    
}

// MARK: - Protocols

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "Main", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "TrainingMainViewController")
}


