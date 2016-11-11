//
//  RideViewController.swift
//  NimbleRide
//
//  Created by Nicholas Randhawa on 11/8/16.
//  Copyright © 2016 Alejandro Puente. All rights reserved.
//

import UIKit
import CoreLocation

class RideViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timerResetButton: UIButton!
    @IBOutlet weak var timerToggleButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    var bikeTimer = Timer()
    var count = 0
    var timerFlag = 0 //0 = paused, 1 = running
    var nextLocation:CLLocation!
    var previousLocation:CLLocation!
    var distance = 0.0, speed = 0.0, altitude = 0.0, totalDistance = 0.0
    
    func runTimer () {
        count += 1
        timerLabel.text = String (format: "%02d:%02d:%02d", (count/3600)%60, (count/60)%60, count%60)
    }
    
    @IBAction func timerToggleButton (_ send: AnyObject){
        if (timerFlag == 0){
            timerFlag = 1
            timerToggleButton.setTitle("Pause", for: .normal)
            bikeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: NSSelectorFromString("runTimer"), userInfo: nil, repeats: true)
        }
        else {
            timerFlag = 0
            timerToggleButton.setTitle("Resume", for: .normal)
            bikeTimer.invalidate()
        }
    }
    
    @IBAction func timerResetButton (_ send: AnyObject){
        timerLabel.text = "00:00:00"
        count = 0
        timerFlag = 0
        bikeTimer.invalidate()
        timerToggleButton.setTitle("Start", for: .normal)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        altitude = (locations.last!.altitude * 3.28084)
        altitudeLabel.text = String(format: "%.0f ft", altitude)
        speed = (locations.last!.speed * 2.23694)
        if (speed < 0){
            speed = 0
        }
        speedLabel.text = String(format: "%.2f mph", speed)

        if (timerToggleButton.title(for: .normal) == "Start"){ //timer has not started
            distance = 0
            previousLocation = locations.last
        }

        else if (timerToggleButton.title(for: .normal) == "Pause"){ //timer is running
            nextLocation = locations.last
            distance += nextLocation.distance(from: previousLocation)
            previousLocation = nextLocation
        }

        else { //timer is paused
            previousLocation = locations.last
        }

        totalDistance = distance * 0.000621371
        distanceLabel.text = String(format: "%.2f miles", totalDistance)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error" + error.localizedDescription)
    }
}

