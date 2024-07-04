//
//  ActivityDiscoveryViewController.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/24/24.
//

import CoreLocation
import MapKit
import UIKit

struct Activity {
    let name: String
    let coordinate: CLLocationCoordinate2D
    let imageName: String
}

class ActivityDiscoveryViewController: UIViewController {
    // MARK: - IBOutlet

    @IBOutlet var vMap: MKMapView!

    // MARK: - Properties

    var locationManager: CLLocationManager!
    var selectedAnnotationView: MKAnnotationView?
    var selectedActivityCoordinate: CLLocationCoordinate2D?

    // MARK: - LifeCycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vMap.showsUserLocation = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        setupUI()
        addActivityAnnotations()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        vMap.showsUserLocation = false
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
        if selectedActivityCoordinate != nil {
            performSegue(withIdentifier: "pushToRouteVC", sender: nil)
        } else {
            Alert.showToastWith(message: "請選擇一個活動地點以繼續", vc: self, during: .long)
        }
    }


    // MARK: - Function

    func addActivityAnnotations() {
        let activities = [
            Activity(name: "眉溪活動", coordinate: CLLocationCoordinate2D(latitude: 24.150, longitude: 120.683), imageName: "p1"),
            Activity(name: "乾溪漫步", coordinate: CLLocationCoordinate2D(latitude: 24.147, longitude: 120.685), imageName: "p2"),
            Activity(name: "霧社溪之旅", coordinate: CLLocationCoordinate2D(latitude: 24.152, longitude: 120.681), imageName: "p3"),
        ]

        for activity in activities {
            let annotation = ActivityAnnotation(name: activity.name, coordinate: activity.coordinate, imageName: activity.imageName)
            vMap.addAnnotation(annotation)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushToRouteVC" {
            if let routeVC = segue.destination as? RouteViewController {
                routeVC.destinationCoordinate = selectedActivityCoordinate
            }
        }
    }
}

// MARK: - Extensions.

// MARK: - CLLocationManagerDelegate

extension ActivityDiscoveryViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: locValue, latitudinalMeters: 500, longitudinalMeters: 500)
        vMap.setRegion(region, animated: true)
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            DispatchQueue.global().async {
                manager.startUpdatingLocation()
            }
            
            vMap.showsUserLocation = true
        case .denied, .restricted:
            showLocationAccessDeniedAlert()
        default:
            break
        }
    }

    private func showLocationAccessDeniedAlert() {
        Alert.showAlertWithError(title: "位置訪問被拒",
                                 message: "此應用需要位置訪問權限來提供功能。請在設定中開啟。",
                                 vc: self,
                                 confirmTitle: "開啟設定", confirm: {
                                     if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                                         UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                     }
                                 })
    }
}

// MARK: - MKMapViewDelegate

extension ActivityDiscoveryViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is ActivityAnnotation  {
            let identifier = "Activity"
            var view: MKMarkerAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                let button = UIButton(type: .detailDisclosure)
                view.rightCalloutAccessoryView = button
            }
            view.glyphText = "⭐️"
            view.markerTintColor = UIColor.blue
            view.glyphTintColor = UIColor.white

            return view
        }
        return nil
    }


    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? ActivityAnnotation {
            if let image = UIImage(named: annotation.imageName) {
                let imageView = UIImageView(image: image)
                imageView.frame = self.view.bounds
                imageView.contentMode = .scaleAspectFit
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage)))
                self.view.addSubview(imageView)
            }
        }
    }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? ActivityAnnotation {
            selectedActivityCoordinate = annotation.coordinate
            selectedAnnotationView = view
            if let markerView = view as? MKMarkerAnnotationView {
                markerView.markerTintColor = UIColor.systemBlue
            }
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let markerView = view as? MKMarkerAnnotationView {
            markerView.markerTintColor = UIColor.blue
        }
    }
}


@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "SiteVisit", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "ActivityDiscoveryViewController")
}
