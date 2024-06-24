//
//  RouteViewController.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/24/24.
//

import UIKit

class RouteViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var vTimeRing: MKRingProgressView!
    @IBOutlet weak var vWorkoutRing: MKRingProgressView!
    @IBOutlet weak var vMap: MKMapView!
    
    
    // MARK: - Properties
    
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Settings
    
    fileprivate func setupUI() {
        
    }
    
    // MARK: - IBAction
    
    @IBAction func goBack(_ sender: Any) {
        
    }
    
    @IBAction func pushToTakeCameraVC(_ sender: Any) {
    }
    
    // MARK: - Function
    
    
    
}

// MARK: - Extensions



// MARK: - Protocols

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "SiteVisit", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "RouteViewController")
}


