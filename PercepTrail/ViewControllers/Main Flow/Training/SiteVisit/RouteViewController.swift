//
//  RouteViewController.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/24/24.
//

import UIKit
import MapKit
import MKRingProgressView

// MARK: - RouteViewController

class RouteViewController: UIViewController {
    // MARK: - IBOutlet
    
    @IBOutlet var vTimeRing: RingProgressView!
    @IBOutlet var vDistanceRing: RingProgressView!
    @IBOutlet var vMap: MKMapView!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbDistance: UILabel!
    @IBOutlet weak var btnTakePhone: UIButton!
    
    // MARK: - Properties
    
    var destinationCoordinate: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    var timer: Timer?
    static var elapsedTime: Int = 0
    var distanceUpdateTimer: Timer?
    var initialDistance: Double = 0.0
    var routeUpdateTimer: Timer?
    var previousRoute: MKPolyline?
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startRouteUpdateTimer()
        configureLocationManager()
        vMap.showsUserLocation = true
        startDistanceUpdateTimer()
        if timer == nil {
            startTimer()
        }
        updateDistanceToDestination()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRouteNavigation()
        showRouteOnMap(to: destinationCoordinate!)
        setupGeofence(for: destinationCoordinate!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        vMap.showsUserLocation = false
        distanceUpdateTimer?.invalidate()
    }
    
    // MARK: - UI Settings
    
    fileprivate func setupUI() {
        vDistanceRing.progress = 0.0
        vTimeRing.progress = 0.0
        

        vMap.delegate = self
        setupButtonImage()
    }
    
    private func setupButtonImage() {
        if let image1 = UIImage(systemName: "camera.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal) {
            let resizedImage = image1.resizeImage(to: CGSize(width: 70, height: 60))
            btnTakePhone.setImage(resizedImage, for: .normal)
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        routeUpdateTimer?.invalidate()
        routeUpdateTimer = nil
    }
    
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 10
    }
    
    private func showRouteOnMap(to destination: CLLocationCoordinate2D) {
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
        
        let destinationAnnotation = DestinationAnnotation(coordinate: destination, title: "目的地", imageName: "p1")
        vMap.addAnnotation(destinationAnnotation)
    }
    
    // MARK: - IBAction
    
    @IBAction func goBack(_ sender: Any) {
        timer?.invalidate()
        RouteViewController.elapsedTime = 0
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let homeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController {
            present(homeVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func pushToTakeCameraVC(_ sender: Any) {
        let storyboard = UIStoryboard(name: "TakePhone", bundle: nil)
        if let takePhotoVC = storyboard.instantiateViewController(withIdentifier: "TakePhoneViewController") as? TakePhoneViewController {
            takePhotoVC.fromTask = true
            takePhotoVC.destinationCoordinate = destinationCoordinate
            present(takePhotoVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Action
    
    @objc func updateTimer() {
        RouteViewController.elapsedTime += 1
        updateLabelTime()
        updateTimeProgress()
    }
    
    @objc func updateDistanceToDestination() {
        guard let currentLocation = locationManager.location else { return }
        let destinationLocation = CLLocation(latitude: destinationCoordinate!.latitude, longitude: destinationCoordinate!.longitude)
        let distance = currentLocation.distance(from: destinationLocation) // 距離以米為單位
        
        DispatchQueue.main.async {
            self.lbDistance.text = String(format: "%.2f m", distance)
        }
    }
    
    @objc func updateRoute() {
        setupRouteNavigation()
    }
    
    // MARK: - Function
    
    private func startTimer() {
            if timer == nil {
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            }
        }
    
    private func startDistanceUpdateTimer() {
        distanceUpdateTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateDistanceToDestination), userInfo: nil, repeats: true)
    }
    
    private func startRouteUpdateTimer() {
        routeUpdateTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(updateRoute), userInfo: nil, repeats: true)
    }
    
    private func updateLabelTime() {
        let minutes = RouteViewController.elapsedTime / 60
        let seconds = RouteViewController.elapsedTime % 60
        lbTime.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func navigateToNextPage() {
        performSegue(withIdentifier: "pushSettlement", sender: nil)
    }
    
    private func updateTimeProgress() {
        let timePerCircle = 900.0 // 15分鐘為一圈
        let progress = Double(RouteViewController.elapsedTime) / timePerCircle
        let formattedProgress = min(progress, 1.0)
        DispatchQueue.main.async {
            self.vTimeRing.progress = formattedProgress
        }
    }
    
    private func updateStepProgress(steps: Int) {
        let stepsPerCircle = 1000.0
        let progress = Double(steps) / stepsPerCircle
        let formattedProgress = min(progress, 1.0)
        DispatchQueue.main.async {
            self.vDistanceRing.progress = formattedProgress
        }
    }
    
    private func calculateInitialDistance() {
        guard let currentLocation = locationManager.location else { return }
        let destinationLocation = CLLocation(latitude: destinationCoordinate!.latitude, longitude: destinationCoordinate!.longitude)
        initialDistance = currentLocation.distance(from: destinationLocation)
        updateDistanceProgress(currentDistance: initialDistance)
    }
    
    private func updateDistanceProgress(currentDistance: Double) {
        if initialDistance == 0 { return }
        let progress = 1.0 - max(currentDistance / initialDistance, 0.0)
        DispatchQueue.main.async {
            self.vDistanceRing.progress = progress
        }
    }
}

// MARK: CLLocationManagerDelegate

extension RouteViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let currentLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let currentDistance = currentLocation.distance(from: CLLocation(latitude: destinationCoordinate!.latitude, longitude: destinationCoordinate!.longitude))
        updateDistanceProgress(currentDistance: currentDistance)
        
        if currentDistance <= 5 {
            DispatchQueue.main.async {
                self.vDistanceRing.progress = 1.0
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? DestinationAnnotation, let imageName = annotation.imageName {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
            imageView.center = self.view.center
            imageView.image = UIImage(named: imageName)
            imageView.contentMode = .scaleAspectFit
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage)))

            self.view.addSubview(imageView)
        }
    }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }

    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region.identifier == "destinationRegion" {
            timer?.invalidate()
            RouteViewController.elapsedTime = 0
            navigateToNextPage()
        }
    }
    
    private func setupGeofence(for destination: CLLocationCoordinate2D) {
        let geofenceRegion = CLCircularRegion(center: destination, radius: 30, identifier: "destinationRegion")
        geofenceRegion.notifyOnEntry = true
        locationManager.startMonitoring(for: geofenceRegion)
    }
    
    private func updateLocation(location: CLLocation) {
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        vMap.setRegion(region, animated: true)
    }
}

// MARK: MKMapViewDelegate

extension RouteViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        //        showRouteOnMap(to: destinationCoordinate!)
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(centerMapOnUserLocation), object: nil)
        perform(#selector(centerMapOnUserLocation), with: nil, afterDelay: 4.0)
    }
    
    @objc private func centerMapOnUserLocation() {
        if let userLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
            vMap.setRegion(region, animated: true)
        }
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
                
                // 先添加新路線
                self.vMap.addOverlay(route.polyline, level: .aboveRoads)
                
                // 如果有舊的路線，移除它
                if let previousRoute = self.previousRoute {
                    self.vMap.removeOverlay(previousRoute)
                }
                
                // 更新前一次的路線記錄
                self.previousRoute = route.polyline
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
