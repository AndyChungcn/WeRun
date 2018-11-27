//
//  BeginRunVC.swift
//  WeRun
//
//  Created by 钟汇杭 on 2018/10/29.
//  Copyright © 2018 钟汇杭. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class BeginRunVC: RunLocation {
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lastRunCloseBtn: UIButton!
    @IBOutlet weak var avgPaceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var lastRunBGView: UIView!
    @IBOutlet weak var lastStackView: UIStackView!
    @IBOutlet weak var calorieLabel: UILabel!
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        mapView.delegate = self
        manager?.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupMapView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }
    
    func setupMapView() {
        
        if let overlay = addLastRunToMap() {            
            if mapView.overlays.count > 0 {
                mapView.removeOverlays(mapView.overlays)
            }
            print("overlay: \(overlay)")
            mapView.addOverlay(overlay)
            lastStackView.isHidden = false
            lastRunBGView.isHidden = false
            lastRunCloseBtn.isHidden = false
        } else {
            centerMapOnUserLocation()
            lastStackView.isHidden = true
            lastRunBGView.isHidden = true
            lastRunCloseBtn.isHidden = true
        }
    }
    
    func addLastRunToMap() -> MKPolyline? {        
        guard let lastRun = Run.getAllRuns()?.first else { return nil }
        print("lastRun: \(lastRun)")
        
        avgPaceLabel.text = lastRun.pace.formatTimeDurationToString()
        distanceLabel.text = "\(lastRun.distance.metersToMiles(places: 2)) 千米"
        durationLabel.text = lastRun.duration.formatTimeDurationToString()
        let calorieBurn = Double(lastRun.duration) * 55.0 * 0.1355 / 60
        let roundCalorie = Double(round(10*calorieBurn)/10)
        calorieLabel.text = "\(roundCalorie) 千卡"
        
        // show artwork on map
        if !lastRun.locations.isEmpty  {
            let startPoint = Artwork(title: "起点",
                                  locationName: "起点",
                                  discipline: "Sculpture",
                                  coordinate: CLLocationCoordinate2D(latitude: lastRun.locations[0].latitude, longitude: lastRun.locations[0].longitude))
            mapView.addAnnotation(startPoint)
            
            let endPoint = Artwork(title: "终点",
                                  locationName: "终点",
                                  discipline: "Sculpture",
                                  coordinate: CLLocationCoordinate2D(latitude: lastRun.locations.last!.latitude, longitude: lastRun.locations.last!.longitude))
            mapView.addAnnotation(endPoint)
        }
        
        
        var coordinates =  [CLLocationCoordinate2D]()
        for location in lastRun.locations {
            coordinates.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        }
        print("Coordinate2D: \(coordinates)")
        
        mapView.userTrackingMode = .none
        mapView.setRegion(centerMapOnPrevRoute(locations: lastRun.locations), animated: true)
        
        return MKPolyline(coordinates: coordinates, count: lastRun.locations.count)
    }
    
    func centerMapOnUserLocation() {
        mapView.userTrackingMode = .follow
        let coordinateRegion = MKCoordinateRegion.init(center: mapView.userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func centerMapOnPrevRoute(locations: List<Location>) -> MKCoordinateRegion {
        guard let initialLoc =  locations.first else { return MKCoordinateRegion() }
        var minLat = initialLoc.latitude
        var minLng = initialLoc.longitude
        var maxLat = minLat
        var maxLng =  minLng
        
        for location in locations {
            minLat = min(minLat, location.latitude)
            minLng = min(minLng, location.longitude)
            maxLat = max(maxLat, location.latitude)
            maxLng = max(maxLng, location.longitude)
        }
        
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (minLat + maxLat)/2, longitude: (minLng + maxLng)/2), span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat)*1.4, longitudeDelta: (maxLng - minLng)*1.4))
    }
    
    @IBAction func lastRunCloseBtnPressed(_ sender: Any) {
        lastStackView.isHidden = true
        lastRunBGView.isHidden = true
        lastRunCloseBtn.isHidden = true
        centerMapOnUserLocation()
    }
    
    @IBAction func mapViewCenterBtnPressed(_ sender: Any) {
        centerMapOnUserLocation()
    }
    
}

extension BeginRunVC: CLLocationManagerDelegate{

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = #colorLiteral(red: 1, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        renderer.lineWidth = 5
        return renderer
    }
}



class Artwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
