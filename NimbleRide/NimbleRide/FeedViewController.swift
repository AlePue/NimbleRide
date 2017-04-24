//
//  FeedViewController.swift
//  NimbleRide
//
//  Created by Alejandro Puente on 3/19/17.
//  Copyright © 2017 Alejandro Puente. All rights reserved.
//

import UIKit
import AWSDynamoDB


class FeedViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    let myHistory = History()
    let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()

    override func viewDidLoad() {
        super.viewDidLoad()

        myHistory?.userId = "4"
        myHistory?.RideID = "2"
        saveDB()

        loadDB()
//        myHistory?.userId = "3"
//        myHistory?.RideID = "Test Ride ID"
//        deleteDB()
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

    func deleteDB(){
        dynamoDBObjectMapper.remove(myHistory!).continue({ (task:AWSTask!) -> Any? in
            if let error = task.error as NSError? {
                debugPrint("\nThe deletion request failed. \nError: \(error)\n")
                
                let alertController = UIAlertController(title: "Deletion Failed", message: "Your ride could not be deleted. Try again?", preferredStyle: .alert)
                let yesAlertButton = UIAlertAction(title: "Yes", style: .default, handler: {
                    action in
                    self.deleteDB()
                })
                let noAlertButton = UIAlertAction(title: "No", style: .destructive, handler: nil)

                alertController.addAction(yesAlertButton)
                alertController.addAction(noAlertButton)
                self.present(alertController, animated: true, completion: nil)
            }
            else{
                debugPrint("Removed")
            }
            return nil
        })
    }

    func saveDB(){
        dynamoDBObjectMapper.save(myHistory!).continue({ (task:AWSTask!) -> Any? in
            if let error = task.error as NSError? {
                debugPrint("\nThe save request failed. \nError: \(error)\n")

                let alertController = UIAlertController(title: "Save Failed", message: "Your ride could not be saved. Try again?", preferredStyle: .alert)
                let yesAlertButton = UIAlertAction(title: "Yes", style: .default, handler: {
                    action in
                    self.saveDB()
                })
                let noAlertButton = UIAlertAction(title: "No", style: .destructive, handler: nil)
                
                alertController.addAction(yesAlertButton)
                alertController.addAction(noAlertButton)
                self.present(alertController, animated: true, completion: nil)
            }
            else{
                debugPrint("Saved")
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
                    print (ride)
                }
            }
            return nil
        })
    }

    func loadDB(){
        let exp = AWSDynamoDBQueryExpression()
        
        exp.keyConditionExpression = "#userId = :userId"
        exp.expressionAttributeNames = ["#userId": "userId",]
        exp.expressionAttributeValues = [":userId" : myHistory?.userId! as Any]

        dynamoDBObjectMapper.query(History.self, expression: exp).continue({ (task:AWSTask!) -> Any? in
            if let error = task.error as NSError? {
                debugPrint("\nThe load request failed. \nError: \(error)\n")

                let alertController = UIAlertController(title: "Load Failed", message: "Your rides could not be loaded. Try again?", preferredStyle: .alert)
                let yesAlertButton = UIAlertAction(title: "Yes", style: .default, handler: {
                    action in
                    self.loadDB()
                })
                let noAlertButton = UIAlertAction(title: "No", style: .destructive, handler: nil)
                
                alertController.addAction(yesAlertButton)
                alertController.addAction(noAlertButton)
                self.present(alertController, animated: true, completion: nil)
            }
            else{
                print(task.result as Any)
            }
            return nil
        })
    }
};

class History : AWSDynamoDBObjectModel, AWSDynamoDBModeling  {
    var RideID:String?
    var userId:String?

    class func dynamoDBTableName() -> String {
        return "nimbleride-mobilehub-95138682-History"
    }

    class func hashKeyAttribute() -> String {
        return "userId"
    }

    class func rangeKeyAttribute() -> String {
        return "RideID"
    }
}
