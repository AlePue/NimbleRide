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
        myHistory?.userId = "Test User ID"
        myHistory?.RideID = "Test Ride ID"
        dynamoDBObjectMapper.save(myHistory!).continue({ (AWSTask: AnyObject) -> Any? in
            print("saved")
        })
//        dynamoDBObjectMapper.save(myHistory!).continue(block: (task:AWSTask<AnyObject>!) -> Any?)
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

}

class History : AWSDynamoDBObjectModel, AWSDynamoDBModeling  {
    var RideID:String?
    var userId:String?

    class func dynamoDBTableName() -> String {
        return "History"
    }

    class func hashKeyAttribute() -> String {
        return "userId"
    }
}
