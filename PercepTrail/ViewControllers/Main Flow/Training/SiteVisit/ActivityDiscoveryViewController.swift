//
//  ActivityDiscoveryViewController.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/24/24.
//

import UIKit
import MapKit
import CoreLocation

struct Activity {
    let name: String
    let coordinate: CLLocationCoordinate2D
}

class ActivityDiscoveryViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var vMap: MKMapView!
    
    // MARK: - Properties
    
    var locationManager: CLLocationManager!
    var selectedAnnotationView: MKAnnotationView?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
            super.viewDidLoad()
            setupLocationManager()
            setupUI()
            addActivityAnnotations()
        }

    
    // MARK: - Location Manager Setup
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // 請求權限
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - UI Settings
    
    fileprivate func setupUI() {
        vMap.delegate = self
    }
    
    // MARK: - IBAction
    
    @IBAction func openTaskPage(_ sender: Any) {
        // 開啟任務頁面邏輯
    }
    
    // MARK: - Function
    
    func addActivityAnnotations() {
        let activities = [
            Activity(name: "眉溪活動", coordinate: CLLocationCoordinate2D(latitude: 24.150, longitude: 120.683)),
            Activity(name: "乾溪漫步", coordinate: CLLocationCoordinate2D(latitude: 25.033, longitude: 121.565)),
            Activity(name: "霧社溪之旅", coordinate: CLLocationCoordinate2D(latitude: 22.627, longitude: 120.301))
        ]
        
        for activity in activities {
            let annotation = MKPointAnnotation()
            annotation.coordinate = activity.coordinate
            annotation.title = activity.name
            vMap.addAnnotation(annotation)
        }
    }
}

// MARK: - Extensions

// MARK: - CLLocationManagerDelegate

extension ActivityDiscoveryViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: locValue, latitudinalMeters: 500, longitudinalMeters: 500)
        vMap.setRegion(region, animated: true)
    }
        
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            if CLLocationManager.locationServicesEnabled() {
                manager.startUpdatingLocation()
                vMap.showsUserLocation = true
            }
        } else {
            Alert.showAlertWithError(title: "位置訪問被拒",
                                     message: "無法取得裝置位置權限",
                                     vc: self,
                                     confirmTitle: "確認", confirm: {
                CommandBase.sharedInstance.openURL(with: AppDefine.SettingsURLScheme.Location.rawValue)
            })
        }
    }
}


// MARK: - MKMapViewDelegate

extension ActivityDiscoveryViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else {
            let identifier = "Activity"
            var view: MKMarkerAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                view.glyphImage = UIImage(named: "customIcon")
            }
            
            view.markerTintColor = UIColor.systemYellow
            view.glyphTintColor = UIColor.white
            view.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)

            return view
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let selectedView = selectedAnnotationView as? MKMarkerAnnotationView {
            selectedView.markerTintColor = UIColor.systemYellow
        }

        selectedAnnotationView = view
        if let markerView = view as? MKMarkerAnnotationView {
            markerView.markerTintColor = UIColor.systemBlue
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let markerView = view as? MKMarkerAnnotationView {
            markerView.markerTintColor = UIColor.systemYellow
        }
    }
}



// MARK: - Protocols

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "SiteVisit", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "ActivityDiscoveryViewController")
}
