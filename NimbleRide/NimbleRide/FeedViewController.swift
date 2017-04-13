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

        // ============================================ TEST SAVE FUNCTION ============================================
        myHistory?.userId = "Test User ID"
        myHistory?.RideID = "Test Ride ID"

        dynamoDBObjectMapper.save(myHistory!).continue({ (task:AWSTask!) -> Any? in
            if let error = task.error as NSError? {
                print("\nThe save request failed. \nError: \(error)\n")
            }
            else{
            print("saved")
            }
            return nil
        })

        // ============================================ TEST SCAN FUNCTION ============================================
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.limit = 20
        
        dynamoDBObjectMapper.scan(History.self, expression: scanExpression).continue({ (task:AWSTask!) -> Any? in
            if let error = task.error as NSError? {
                print("\nThe scan request failed. \nError: \(error)\n")
            }
            else if let paginatedOutput = task.result {
                for ride in paginatedOutput.items {
                    print (ride)
                }
            }
            return nil
        })
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

}

class History : AWSDynamoDBObjectModel, AWSDynamoDBModeling  {
    var RideID:String?
    var userId:String?

    class func dynamoDBTableName() -> String {
        return "nimbleride-mobilehub-95138682-History"
    }

    class func hashKeyAttribute() -> String {
        return "userId"
    }
}
