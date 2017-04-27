//
//  FeedViewController.swift
//  NimbleRide
//
//  Created by Alejandro Puente on 3/19/17.
//  Copyright © 2017 Alejandro Puente. All rights reserved.
//


import UIKit
import AWSDynamoDB
import MapKit


class FeedViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()

    @IBOutlet weak var feedMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        History.shared.userId = 2
//        History.shared.RideID = 1
//        History.shared.fName = "Steve"
//        History.shared.lName = "Jobs"
        
//        feedMap.setRegion(<#T##region: MKCoordinateRegion##MKCoordinateRegion#>, animated: <#T##Bool#>)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        if !(AccountViewController.FBuser.firstName.isEmpty){
            let name = AccountViewController.FBuser.firstName + " " + AccountViewController.FBuser.lastName
            self.nameLabel.text = name + "'s Feed"
        }
        
    }

    func deleteDB(controller: UIViewController){
        dynamoDBObjectMapper.remove(myHistory.shared).continue({ (task:AWSTask!) -> Any? in
            if let error = task.error as NSError? {
                debugPrint("\nThe deletion request failed. \nError: \(error)\n")
                
                let alertController = UIAlertController(title: "Deletion Failed", message: "Your ride could not be deleted. Try again?", preferredStyle: .alert)
                let yesAlertButton = UIAlertAction(title: "Yes", style: .default, handler: {
                    action in
                    self.deleteDB(controller: controller)
                })
                let noAlertButton = UIAlertAction(title: "No", style: .destructive, handler: nil)

                alertController.addAction(yesAlertButton)
                alertController.addAction(noAlertButton)
                controller.present(alertController, animated: true, completion: nil)
            }
            else{
                let alertController = UIAlertController(title: "Ride Deleted", message: nil, preferredStyle: .actionSheet)
                controller.present(alertController, animated: true, completion: nil)
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when){
                    controller.dismiss(animated: true, completion: nil)
                }
            }
            return nil
        })
    }

    func saveDB(controller: UIViewController){
        dynamoDBObjectMapper.save(myHistory.shared).continue({ (task:AWSTask!) -> Any? in
            if let error = task.error as NSError? {
                debugPrint("\nThe save request failed. \nError: \(error)\n")

                let alertController = UIAlertController(title: "Save Failed", message: "Your ride could not be saved. Try again?", preferredStyle: .alert)
                let yesAlertButton = UIAlertAction(title: "Yes", style: .default, handler: {
                    action in
                    self.saveDB(controller: controller)
                })
                let noAlertButton = UIAlertAction(title: "No", style: .destructive, handler: nil)
                
                alertController.addAction(yesAlertButton)
                alertController.addAction(noAlertButton)
                controller.present(alertController, animated: true, completion: nil)
            }
            else{
                let alertController = UIAlertController(title: "Ride Saved", message: nil, preferredStyle: .actionSheet)
                controller.present(alertController, animated: true, completion: nil)
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when){
                controller.dismiss(animated: true, completion: nil)
                }
            }
            return nil
        })
    }

    func scanDB(){
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.limit = 20

        dynamoDBObjectMapper.scan(History.self, expression: scanExpression).continue({ (task:AWSTask!) -> Any? in
            if let error = task.error as NSError? {
                debugPrint("\nThe scan request failed. \nError: \(error)\n")

            }
            else if let paginatedOutput = task.result {
                for ride in paginatedOutput.items {
                    debugPrint (ride)
                }
            }
            return nil
        })
    }

    func loadDB(controller: UIViewController, userId: NSNumber){
        let exp = AWSDynamoDBQueryExpression()
        
        exp.keyConditionExpression = "#userId = :userId"
        exp.expressionAttributeNames = ["#userId": "userId",]
        exp.expressionAttributeValues = [":userId" : userId as Any]

        dynamoDBObjectMapper.query(History.self, expression: exp).continue({ (task:AWSTask!) -> Any? in
            if let error = task.error as NSError? {
                debugPrint("\nThe load request failed. \nError: \(error)\n")

                let alertController = UIAlertController(title: "Load Failed", message: "Your rides could not be loaded. Try again?", preferredStyle: .alert)
                let yesAlertButton = UIAlertAction(title: "Yes", style: .default, handler: {
                    action in
                    self.loadDB(controller: controller, userId: userId)
                })
                let noAlertButton = UIAlertAction(title: "No", style: .destructive, handler: nil)

                alertController.addAction(yesAlertButton)
                alertController.addAction(noAlertButton)
                controller.present(alertController, animated: true, completion: nil)
            }
            else if let paginatedOutput = task.result {
                for ride in paginatedOutput.items {
                    debugPrint (ride)
                }
            }
            return nil
        })
    }
};

class History : AWSDynamoDBObjectModel, AWSDynamoDBModeling  {
    var RideID:NSNumber?
    var userId:NSNumber?
    var avgSpeed:NSNumber?
    var calBurned:NSNumber?
    var distance:NSNumber?
    var fName:String?
    var lName:String?
    var time:String?
    
    class func dynamoDBTableName() -> String {
        return "History"
    }
    
    class func hashKeyAttribute() -> String {
        return "userId"
    }
    
    class func rangeKeyAttribute() -> String {
        return "RideID"
    }
}


class myHistory : AWSDynamoDBObjectModel, AWSDynamoDBModeling  {
    private override init() {super.init()}
    
    required init!(coder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    static let shared: myHistory = myHistory()

    var RideID:NSNumber?
    var userId:NSNumber?
    var avgSpeed:NSNumber?
    var calBurned:NSNumber?
    var distance:NSNumber?
    var fName:String?
    var lName:String?
    var time:String?

    class func dynamoDBTableName() -> String {
        return "History"
    }

    class func hashKeyAttribute() -> String {
        return "userId"
    }

    class func rangeKeyAttribute() -> String {
        return "RideID"
    }
}
