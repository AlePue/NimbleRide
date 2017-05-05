//
//  FtueViewController.swift
//  NimbleRide
//
//  Created by Alejandro Puente on 4/2/17.
//  Copyright © 2017 Alejandro Puente. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import AWSDynamoDB

class FtueViewController: UIViewController {
    
    
    
    var userData = NSDictionary()
//    let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
    
    
    @IBAction func FBLoginButton(_ sender: Any) {
        
        debugPrint("BUTTON PRESSED")
                let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
                fbLoginManager.logIn(withReadPermissions: ["email", "user_friends", "public_profile"], from:self) { (result, error) -> Void in
                    if (error == nil){
                        let loginResult : FBSDKLoginManagerLoginResult = result!
                        if loginResult.grantedPermissions != nil{
                            if(loginResult.grantedPermissions.contains("email"))
                            {
                                self.getUserData()

                                self.loadDB(controller: self, userId: NSNumber(value: FtueViewController.FBuser.id))
                                for friend in FtueViewController.FBuser.friendList{
                                    self.loadDB(controller: self, userId: NSNumber(value: friend))
                                }
                                let controller = FeedViewController()
                                controller.Data = controller.Data.sorted { (History1: History, History2: History) -> Bool in
                                    return History1.RideID?.compare(History2.RideID!) == ComparisonResult.orderedDescending
                                }
                                

                                
                                
                                
                                if let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "idTabBar") as? UITabBarController {
                                    self.present(tabViewController, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                    
                }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
    
    func loadDB(controller: UIViewController, userId: NSNumber){
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()

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
                    debugPrint(ride)
                    let controller = FeedViewController()
                    controller.Data.append(ride as! History)
                }
            }
            return nil
        })
    }
    
    func getUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, last_name, picture.type(large)"]).start(completionHandler: { (connection, FBuserData, error) -> Void in
                if (error == nil){
                    print (FBuserData!)
                    
                    //                    EXAMPLE OUTPUT
                    //                    {
                    //                        "first_name" = fName;
                    //                        id = XXXXXXXXXXXXXXXX;
                    //                        "last_name" = rName;
                    //                        picture =     {
                    //                            data =         {
                    //                                "is_silhouette" = 0;
                    //                                url = "www.picture_url.com";
                    //                            };
                    //                        };
                    //                    }
                    
                    
                    self.userData = FBuserData as! NSDictionary
                    let total = self.userData.allKeys.count
                    if total > 1{
                        FBuser.firstName = String (describing: self.userData["first_name"]!)
                        FBuser.lastName = String (describing: self.userData["last_name"]!)
                        FBuser.id = (self.userData["id"]as! NSString).integerValue
//                        self.firstNameLabel.text = FBuser.firstName
//                        self.lastNameLabel.text = FBuser.lastName
                        //                        let url = NSURL(string: "https://graph.facebook.com/\(FBuser.id)/picture?type=large&return_ssl_resources=1")
//                        self.profilePictureView.image = UIImage(data: NSData(contentsOf: FBuser.picURL! as URL)! as Data)
                    }
                }
                else{
                    debugPrint ("\nUser Error")
                    debugPrint (error!)
                }
            })
            
            FBSDKGraphRequest(graphPath: "me/friends", parameters: nil).start(completionHandler: { (connection, friendsData, error) -> Void in
                if (error == nil){
                    debugPrint (friendsData!)
                    let total = self.userData.allKeys.count
                    
                    if total > 0{
                        let friendsData = friendsData as! NSDictionary
                        let data = friendsData["data"]
                        for friend in (data as? [[String: Any]])!{
                            FBuser.friendList.append((friend["id"]as! NSString).integerValue)
                        }
                    }
                    debugPrint (FBuser.friendList)
                }
                else{
                    debugPrint ("\nFriends Error")
                    debugPrint (error!)
                }
            })
            
        }
        
    }
    
    struct FBuser{
        static var firstName = String()
        static var lastName = String()
        static var id = Int()
        static var friendList = [Int]()
        static var picURL = NSURL(string: "https://graph.facebook.com/\(FBuser.id)/picture?type=large&return_ssl_resources=1")
    }


        
}
