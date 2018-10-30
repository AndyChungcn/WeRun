//
//  CurrentRunVC.swift
//  WeRun
//
//  Created by 钟汇杭 on 2018/10/29.
//  Copyright © 2018 钟汇杭. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class CurrentRunVC: RunLocation {
    
    @IBOutlet weak var sliderImageView: UIImageView!
    @IBOutlet weak var swipeBGImageView: UIImageView!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var avgPaceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    fileprivate var timer = Timer()
    fileprivate var counter = 0
    fileprivate var startLocation: CLLocation!
    fileprivate var lastLocation: CLLocation!
    fileprivate var runDistance = 0.0
    fileprivate var pace = 0
    fileprivate var coordinateLocations = List<Location>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(endRunSwiped(sender:)))
        sliderImageView.addGestureRecognizer(swipeGesture)
        sliderImageView.isUserInteractionEnabled = true
        swipeGesture.delegate = self as? UIGestureRecognizerDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startRun()
        manager?.delegate = self
        manager?.distanceFilter = 10
    }
    
    func startRun() {
        startTimer()
        manager?.startUpdatingLocation()
        pauseBtn.setImage(#imageLiteral(resourceName: "pauseButton"), for: .normal)
    }
    
    func startTimer() {
        durationLabel.text = counter.formatTimeDurationToString()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        counter += 1
        durationLabel.text = counter.formatTimeDurationToString()
    }
    
    @IBAction func pauseBtnPressed(_ sender: Any) {
        if timer.isValid {
            pauseRun()
        } else {
            startRun()
        }
    }
    
    func pauseRun() {
        timer.invalidate()
        pauseBtn.setImage(#imageLiteral(resourceName: "resumeButton"), for: .normal)
        startLocation = nil
        lastLocation = nil
        manager?.stopUpdatingLocation()
    }
    
    func endRun() {
        manager?.stopUpdatingLocation()
        Run.addRunToRealm(pace: pace, distance: runDistance, duration: counter, locations: coordinateLocations)
    }
    
    func calculatePace(time seconds: Int, miles: Double) -> String {
        pace = Int(Double(seconds) / miles)
        return pace.formatTimeDurationToString()
    }
    
    
    @objc func endRunSwiped(sender: UIPanGestureRecognizer) {
        let minAdjust: CGFloat = 77
        let maxAdjust: CGFloat = 127
        if let sliderView = sender.view {
            if sender.state == UIGestureRecognizer.State.began || sender.state == UIGestureRecognizer.State.changed {
                let translation = sender.translation(in: self.view)
                if sliderView.center.x >= (swipeBGImageView.center.x - minAdjust) && sliderView.center.x < (swipeBGImageView.center.x + maxAdjust) {
                    sliderView.center.x = sliderView.center.x + translation.x
                } else if sliderView.center.x >= (swipeBGImageView.center.x + maxAdjust) {
                    endRun()
                    dismiss(animated: true, completion: nil)
                } else {
                    sliderView.center.x = swipeBGImageView.center.x - minAdjust
                }
                sender.setTranslation(CGPoint.zero, in: self.view)
            } else if sender.state == UIGestureRecognizer.State.ended {
                UIView.animate(withDuration: 0.1) {
                    sliderView.center.x = self.swipeBGImageView.center.x - minAdjust
                }
            }
        }
    }
}

extension CurrentRunVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            startLocation = locations.first
        } else if let location = locations.first {
            runDistance += lastLocation.distance(from: location)
            let newLocation = Location(latitude: Double(lastLocation.coordinate.latitude), longitude: Double(lastLocation.coordinate.longitude))
            coordinateLocations.insert(newLocation, at: 0)
            distanceLabel.text = "\(runDistance.metersToMiles(places: 2))"
            if counter > 0 && runDistance > 0 {
                avgPaceLabel.text = calculatePace(time: counter, miles: runDistance.metersToMiles(places: 2))
            }
        }
        lastLocation = locations.last
    }
}
