//
//  RouteViewController.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/24/24.
//

import MapKit
import MKRingProgressView
import UIKit

class RouteViewController: UIViewController {
    // MARK: - IBOutlet

    @IBOutlet var vTimeRing: RingProgressView!
    @IBOutlet var vWorkoutRing: RingProgressView!
    @IBOutlet var vMap: MKMapView!

    // MARK: - Properties

    var destinationCoordinate: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()

   
    
    // MARK: - LifeCycle

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vMap.showsUserLocation = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRouteNavigation()
        showRouteOnMap(to: destinationCoordinate!)
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        vMap.showsUserLocation = false
    }
    
    // MARK: - UI Settings

    fileprivate func setupUI() {
        configureLocationManager()
        vMap.delegate = self
    }

    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func showRouteOnMap(to destination: CLLocationCoordinate2D) {
            let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: vMap.userLocation.coordinate))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
            request.transportType = .any
            
            let directions = MKDirections(request: request)
            directions.calculate { [weak self] (response, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error calculating directions: \(error.localizedDescription)")
                    return
                }
                
                guard let route = response?.routes.first else {
                    print("No routes found.")
                    return
                }
                self.vMap.removeOverlays(self.vMap.overlays)
                self.vMap.addOverlay(route.polyline)
              }
        
        let destinationAnnotation = DestinationAnnotation(coordinate: destination, title: "目的地")
           vMap.addAnnotation(destinationAnnotation)
        }

    // MARK: - IBAction

    @IBAction func goBack(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let homeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController {
            present(homeVC, animated: true, completion: nil)
        }
    }

    @IBAction func pushToTakeCameraVC(_ sender: Any) {
    }

    // MARK: - Function
}

// MARK: - Extensions

extension RouteViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
            vMap.setRegion(region, animated: true)
            manager.stopUpdatingLocation()
        }
    }
}

extension RouteViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        showRouteOnMap(to: destinationCoordinate!)
    }
    
    func setupRouteNavigation() {
        guard let destination = destinationCoordinate,
              let sourceCoordinate = locationManager.location?.coordinate else {
            print("導航資訊不完整")
            return
        }

        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destination)

        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)

        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceItem
        directionRequest.destination = destinationItem
        directionRequest.transportType = .walking

        let directions = MKDirections(request: directionRequest)
        directions.calculate { [weak self] response, error in
            DispatchQueue.main.async {
                guard let self = self, let route = response?.routes.first else {
                    print("路線計算錯誤: \(error?.localizedDescription ?? "未知錯誤")")
                    return
                }

                self.vMap.addOverlay(route.polyline, level: .aboveRoads)
                let rect = route.polyline.boundingMapRect
                self.vMap.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 10
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is DestinationAnnotation {
            let identifier = "DestinationMarker"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.calloutOffset = CGPoint(x: -5, y: 5)
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                annotationView?.annotation = annotation
            }
            
            annotationView?.markerTintColor = .red
            annotationView?.glyphText = "🏁"
            
            return annotationView
        }
        return nil
    }

}

// MARK: - Protocols

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "SiteVisit", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "RouteViewController")
}
