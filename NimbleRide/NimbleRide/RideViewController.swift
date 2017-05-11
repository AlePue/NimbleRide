//
//  RideViewController.swift
//  NimbleRide
//
//  Created by Nicholas Randhawa on 11/8/16.
//  Copyright © 2016 Alejandro Puente. All rights reserved.
//

import UIKit
import CoreLocation
import SpeechKit
import MapKit

class RideViewController: UIViewController, CLLocationManagerDelegate, SKTransactionDelegate{

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var avgSpeedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timerResetButton: UIButton!
    @IBOutlet weak var timerToggleButton: UIButton!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var voiceCommandButton: UIButton!
    @IBOutlet weak var voiceImage: UIImageView!
    @IBOutlet weak var cadenceLabel: UIButton!
    @IBOutlet weak var batteryLabel: UIButton!
    
//    @IBOutlet weak var cadenceLabel: UILabel! = {
//       let cadenceLabels = UILabel()
//        cadenceLabels.text = "10"
//        return cadenceLabels
//    }()
    
    let locationManager = CLLocationManager()
    var myUIImage: UIImage = #imageLiteral(resourceName: "speaker2").withRenderingMode(.alwaysTemplate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        
//        myUIImage = #imageLiteral(resourceName: "speaker2")
        myButton.setImage(myUIImage, for: UIControlState.normal)
        
        myUIImage = myUIImage.maskWithColor(color: .black)
        

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
    var timerCount = 0, pointsTaken = 0.0, calories = 0.0
    var timerFlag = 0, voiceFlag = 0 //0 = paused, 1 = running
    var nextLocation:CLLocation!
    var previousLocation:CLLocation!
    var city = "San Jose"
    var state = "CA"
    var landmark = "San Jose State University"
    var country = "United States"

    let session = SKSession(url: NSURL(string: "nmsps://NMDPTRIAL_nrandhawa01_yahoo_com20170225163344@sslsandbox-nmdp.nuancemobility.net:443") as URL!, appToken: "1b3110f8b753718ce8567d91dbe23f52297406693752658592da9142b36177ce9288c749db38d5c38e53546a3594bc5e08c2c840142dc5a70856e9bbb761894a")
    var textToSpeak = "No input received"

    var distance = 0.0, speed = 0.0, altitude = 0.0, totalDistance = 0.0, avgSpeed = 0.0, totalSpeed = 0.0, weight = 160

    
    func runTimer () {
        timerCount += 1
        timerLabel.text = String (format: "%02d:%02d:%02d", (timerCount/3600)%60, (timerCount/60)%60, timerCount%60)
    }
    
    @IBAction func timerToggleButton (_ send: AnyObject){
        timerToggleFunc()
    }
    
    func timerToggleFunc() {
        if (timerFlag == 0){
            timerToggleButton.setTitle("Pause", for: .normal)
            bikeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: NSSelectorFromString("runTimer"), userInfo: nil, repeats: true)
        }
        else {
            timerToggleButton.setTitle("Resume", for: .normal)
            bikeTimer.invalidate()
        }
        timerFlag = ~timerFlag

    }
    
    @IBAction func timerResetButton (_ send: AnyObject){
        timerResetFunc()
    }
    
    func timerResetFunc() {
        myHistory.shared.time = timerLabel.text
        myHistory.shared.avgSpeed = (avgSpeedLabel.text! as NSString).doubleValue as NSNumber
        myHistory.shared.calBurned = (calorieLabel.text! as NSString).integerValue as NSNumber
        myHistory.shared.distance = (distanceLabel.text! as NSString).doubleValue as NSNumber
        myHistory.shared.fName = FtueViewController.FBuser.firstName
        myHistory.shared.lName = FtueViewController.FBuser.lastName
        myHistory.shared.userId = FtueViewController.FBuser.id as NSNumber
        myHistory.shared.RideID = NSDate().timeIntervalSince1970 as NSNumber
        myHistory.shared.city = city
        myHistory.shared.state = state
        myHistory.shared.landmark = landmark
        myHistory.shared.country = country
        
        let alertController = UIAlertController(title: "Save Ride", message: "Would you like to save your ride?", preferredStyle: .alert)
        let yesAlertButton = UIAlertAction(title: "Yes", style: .default, handler: {
            action in
            FeedViewController().saveDB(controller: self) //save ride to DB
        })
        let noAlertButton = UIAlertAction(title: "No", style: .destructive, handler: nil)
        
        alertController.addAction(yesAlertButton)
        alertController.addAction(noAlertButton)
        self.present(alertController, animated: true, completion: nil)
        
        timerLabel.text = "00:00:00"
        timerCount = 0
        timerFlag = 0
        bikeTimer.invalidate()
        timerToggleButton.setTitle("Start", for: .normal)
    }
    
    func addCalorie (speed: Double, calorie: Double) -> Double {
        var count: Double
        switch speed {
        case 0..<10:    // speed < 10
            count = calorie + calcCalorie(MET: 4.0, weight: Double(weight))
        case 10..<12:   // speed 10 < x < 12
            count = calorie + calcCalorie(MET: 6.0, weight: Double(weight))
        case 12..<14:   // speed 12 < x < 14
            count = calorie + calcCalorie(MET: 8.0, weight: Double(weight))
        case 14..<16:   // speed 14 < x < 16
            count = calorie + calcCalorie(MET: 10.0, weight: Double(weight))
        case 16..<20:   // speed 16 < x < 20
            count = calorie + calcCalorie(MET: 12.0, weight: Double(weight))
        case 20..<100:     // speed 20 < x
            count = calorie + calcCalorie(MET: 16.0, weight: Double(weight))
        default:
            count = calorie
        }
        return count
    }
    
    func calcCalorie (MET: Double, weight: Double) -> Double {
        return MET * (weight * 0.45359237) * (1/3600) // calorie burn = MET * weight in kgs * time in hours
    }

    @IBAction func connectBattery(_ sender: Any) {
        if batteryLabel.titleLabel?.text == "Connect BLE"{
            performSegue(withIdentifier: "Pair", sender: self)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        altitude = (locations.last!.altitude * 3.28084)
        altitudeLabel.text = String(format: "%.0f ft", altitude)
        speed = (locations.last!.speed * 2.23694)
        if (speed < 0){
            speed = 0
        }
        speedLabel.text = String(format: "%.2f mph", speed)

        if (timerToggleButton.title(for: .normal) == "Start"){ //timer has not started
            distance = 0
            totalSpeed = 0
            pointsTaken = 0
            avgSpeed = 0
            calories = 0
            previousLocation = locations.last
            let geoCoder = CLGeocoder()
            let endLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
            geoCoder.reverseGeocodeLocation(endLocation, completionHandler: { (placemarks, error) -> Void in
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
                if error == nil{
                    self.state = placeMark.administrativeArea!
                    self.landmark = placeMark.name!
                    self.country = placeMark.country!
                    self.city = placeMark.locality!
                }
                else{
                    debugPrint(error!)
                }
            })
            
        }

        else if (timerToggleButton.title(for: .normal) == "Pause"){ //timer is running
            nextLocation = locations.last
            pointsTaken += 1
            distance += nextLocation.distance(from: previousLocation)
            totalSpeed += nextLocation.speed
            avgSpeed = totalSpeed / pointsTaken
            if (avgSpeed < 0){
                avgSpeed = 0
            }
            previousLocation = nextLocation
            //calories = distance / 50
            calories = addCalorie(speed: speed, calorie: calories)
        }

        else { //timer is paused
            previousLocation = locations.last
        }

        totalDistance = distance * 0.000621371
        distanceLabel.text = String(format: "%.2f miles", totalDistance)
        avgSpeedLabel.text = String(format: "%.2f mph", avgSpeed * 2.23694)
        calorieLabel.text = String(format: "%.0f", calories)
    }

    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error" + error.localizedDescription)
    }

    @IBAction func voiceButton(_ sender: Any) {
        //        voiceCommandFunc()
        //        session!.recognize(withType: SKTransactionSpeechTypeDictation, detection: .long, language: "eng-USA", delegate: self)
        debugPrint("image tapped")
    }
    
    @IBOutlet weak var myButton: UIButton!
    @IBAction func voiceCommandButton (_ send: AnyObject){
            voiceCommandFunc()
            session!.recognize(withType: SKTransactionSpeechTypeDictation, detection: .long, language: "eng-USA", delegate: self)
    }

    func voiceCommandFunc () {
        voiceFlag = ~voiceFlag

        
        if (voiceFlag == 0){
            voiceCommandButton.setTitle("", for: .normal) //voice command
            
            myUIImage = myUIImage.maskWithColor(color: .green)
            myButton.setImage(myUIImage, for: UIControlState.normal)
            
        }
        else{
            voiceCommandButton.setTitle("", for: .normal) //command running
            myUIImage = myUIImage.maskWithColor(color: .red)
            myButton.setImage(myUIImage, for: UIControlState.normal)
            
        }
    }

    func transaction(_ transaction: SKTransaction!, didReceive recognition: SKRecognition!) {
        if recognition.text.lowercased().range(of: "altitude") != nil{
            let alt = altitudeLabel.text?.components(separatedBy: " ")
            let altitudeStatus = alt?[0]
            
            if(altitudeStatus == "1"){
                textToSpeak = "Your current altitude is 1 foot"
            }
            else{
                textToSpeak = "Your current altitude is" + altitudeStatus! + "feet"
            }
        }

        else if recognition.text.lowercased().range(of: "time") != nil{
            let time = timerLabel.text?.components(separatedBy: ":")
            let hour = time?[0]
            let minute = time?[1]
            let second = time?[2]

            if (hour == "00"){ // 00:00:XX
                if (minute == "00"){ // 00:00:XX
                    if(second == "01"){ // 00:00:01
                        textToSpeak = "Your current time is 1 second"
                    }
                    else{ // 00:00:!1
                        textToSpeak = "Your current time is" + second! + "seconds"
                    }
                }
                else{
                    if(minute == "01"){ // 00:01:XX
                        if(second == "01"){ // 00:01:01
                            textToSpeak = "Your current time is 1 minute and 1 second"
                        }
                        else{ // 00:01:!1
                            textToSpeak = "Your current time is 1 minute and" + second! + "seconds"
                        }
                    }
                    else{ // 00:>1:01
                        if(second == "01"){
                            textToSpeak = "Your current time is" + minute! + "minutes and 1 second"
                        }
                        else{ // 00:>1:!1
                            textToSpeak = "Your current time is" + minute! + "minutes and" + second! + "seconds"
                        }
                    }
                }
            }
            else if (hour == "01"){ // 01:XX:XX
                if(minute == "01"){ // 01:01:XX
                    if(second == "01"){ // 01:01:01
                        textToSpeak = "Your current time is 1 hour 1 minute and 1 second"
                    }
                    else{ // 01:01:!1
                        textToSpeak = "Your current time is 1 hour 1 minute and" + second! + "seconds"
                    }
                }
                else{ // 01:!1:01
                    if(second == "01"){
                        textToSpeak = "Your current time is" + minute! + "minutes and 1 second"
                    }
                    else{ // 01:!1:!1
                        textToSpeak = "Your current time is" + minute! + "minutes and" + second! + "seconds"
                    }
                }

                textToSpeak = "Your current time is 1 hour and" + minute! + "minutes and" + second! + "seconds"
            }
            else{ // >1:XX:XX
                if(minute == "01"){ // >1:01:XX
                    if(second == "01"){ // >1:01:01
                        textToSpeak = "Your current time is" + hour! + "hours 1 minute and 1 second"
                    }
                    else{ // >1:01:!1
                        textToSpeak = "Your current time is " + hour! + "hours 1 minute and" + second! + "seconds"
                    }
                }
                else{ // 01:!1:01
                    if(second == "01"){
                        textToSpeak = "Your current time is" + hour! + "hours" + minute! + "minutes and 1 second"
                    }
                    else{ // >1:!1:!1
                        textToSpeak = "Your current time is" + timerLabel.text!
                    }
                }
            }
        }

        else if recognition.text.lowercased().range(of: "speed") != nil{
            if recognition.text.lowercased().range(of: "average") != nil{
                let spd = avgSpeedLabel.text?.components(separatedBy: " ")
                let speedStatus = spd?[0]

                if(speedStatus == "1"){
                    textToSpeak = "Your average speed is 1 mile per hour"
                }
                else{
                    textToSpeak = "Your average speed is" + speedStatus! + "miles per hour"
                }

            }
            else{
                let spd = speedLabel.text?.components(separatedBy: " ")
                let speedStatus = spd?[0]

                if(speedStatus == "1"){
                    textToSpeak = "Your current speed is 1 mile per hour"
                }
                else{
                    textToSpeak = "Your current speed is" + speedStatus! + "miles per hour"
                }
            }
            
        }

        else if recognition.text.lowercased().range(of: "calories") != nil{
            if (calorieLabel.text == "1"){
                textToSpeak = "You've burned 1 calorie"
            }
            else{
                textToSpeak = "You've burned" + calorieLabel.text! + "calories"
            }
        }

        else if recognition.text.lowercased().range(of: "distance") != nil ||
            (recognition.text.lowercased().range(of: "far") != nil){
            let dist = distanceLabel.text?.components(separatedBy: " ")
            let distanceStatus = dist?[0]
            
            if(distanceStatus == "1.00"){
                textToSpeak = "Your traveled distance is 1 mile"
            }
            else{
                textToSpeak = "Your traveled distance is" + distanceStatus! + "miles"
            }
        }

        else if (recognition.text.lowercased().range(of: "start") != nil) ||
                (recognition.text.lowercased().range(of: "begin") != nil) ||
                (recognition.text.lowercased().range(of: "continue") != nil) ||
                (recognition.text.lowercased().range(of: "resume") != nil){
            if (timerToggleButton.titleLabel?.text == "Start"){
                textToSpeak = "Workout started. Good luck!"
                timerToggleFunc()
            }
            else if (timerFlag == 0){
                textToSpeak = "Workout resuming. Breaks are for the weak"
                timerToggleFunc()
            }
            else{
                textToSpeak = "Workout already going"
            }
        }

        else if recognition.text.lowercased().range(of: "pause") != nil{
            textToSpeak = "Workout paused. Enjoy your break"
            timerToggleFunc()
        }

        else if recognition.text.lowercased().range(of: "cadence") != nil{
            textToSpeak = "Your cadence is" + cadenceLabel.title(for: .normal)!
            timerToggleFunc()
        }

        else if recognition.text.lowercased().range(of: "battery") != nil{
            textToSpeak = "Your battery is at" + batteryLabel.title(for: .normal)!
            timerToggleFunc()
        }

        else if (recognition.text.lowercased().range(of: "end") != nil) ||
                (recognition.text.lowercased().range(of: "stop") != nil) ||
                (recognition.text.lowercased().range(of: "complete") != nil) ||
                (recognition.text.lowercased().range(of: "finish") != nil){
            textToSpeak = "Workout ended. Thank you for using Nimble Ride"
            timerResetFunc()
        }

        else {
            textToSpeak = "Command not supported"
        }

        _ = session?.speak(textToSpeak, withLanguage: "eng-USA", delegate: self)
        voiceCommandFunc()
    }
}



class MapRideViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapRide: MKMapView!
    
    var manager:CLLocationManager!
    var myLocations: [CLLocation] = []
    
    
    
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(metricsButtonTapped))

    
    
    var locationManager = CLLocationManager()
    
    func navigationControllerSettingsSetup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(metricsButtonTapped))
    }
    func metricsButtonTapped() {
        debugPrint("DONE PRESSED")
        performSegue(withIdentifier: "Ride", sender: self)

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationControllerSettingsSetup()
        
        mapRide.delegate = self
        mapRide.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        
        //Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        //Zoom to user location
        let noLocation = CLLocationCoordinate2D()
        let viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 200, 200)
        mapRide.setRegion(viewRegion, animated: false)
        mapRide.setUserTrackingMode(.follow, animated: true)
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
     
        myLocations.append(locations[0] as CLLocation)
        
        let spanX = 0.07
        let spanY = 0.07
        
        let newRegion = MKCoordinateRegion(center: mapRide.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        mapRide.setRegion(newRegion, animated: true)
        
        if (myLocations.count > 1){
            let sourceIndex = myLocations.count - 1
            let destinationIndex = myLocations.count - 2
            
            let c1 = myLocations[sourceIndex].coordinate
            let c2 = myLocations[destinationIndex].coordinate
            var a = [c1, c2]
            let polyline = MKPolyline(coordinates: &a, count: a.count)
            mapRide.add(polyline)
        }
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        print("locations = \(locValue.latitude) \(locValue.longitude)")

    }
    
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if !overlay.isKind(of: MKPolyline.self) {
            return nil
        }
        
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor.black
        renderer.lineWidth = 3
        return renderer
    }
    
    
}

extension UIImage {
    func maskWithColor(color: UIColor) -> UIImage {
        
        var maskImage = self.cgImage
        let width = self.size.width
        let height = self.size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let bitmapContext = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        bitmapContext!.clip(to: bounds, mask: maskImage!)
        bitmapContext!.setFillColor(color.cgColor)
        bitmapContext!.fill(bounds)
        
        let cImage = bitmapContext!.makeImage()
        let coloredImage = UIImage(cgImage: cImage!)
        
        return coloredImage
    }
}
