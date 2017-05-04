//
//  RideViewController.swift
//  NimbleRide
//
//  Created by Nicholas Randhawa on 11/11/16.
//  Copyright © 2016 Alejandro Puente. All rights reserved.
//

import ReplayKit
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import AWSDynamoDB

class AccountViewController: UIViewController, RPPreviewViewControllerDelegate {

    @IBOutlet weak var FBloginButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var profilePictureView: UIImageView!
    var userData = NSDictionary()
    let recorder = RPScreenRecorder.shared()

    
    @IBOutlet weak var followers: UILabel! 
    @IBOutlet weak var following: UILabel!
    
//    followers.text = "0"
//    following.text = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    self.getUserData()
    }

    @IBAction func FBloginButton(_ sender: AnyObject) {
        debugPrint("BUTTON PRESSED")
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email", "user_friends", "public_profile"], from:self) { (result, error) -> Void in
            if (error == nil){
                let loginResult : FBSDKLoginManagerLoginResult = result!
                if loginResult.grantedPermissions != nil{
                    if(loginResult.grantedPermissions.contains("email"))
                    {
                        self.getUserData()
                    }
                }
            }
        }
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
                        self.firstNameLabel.text = FBuser.firstName
                        self.lastNameLabel.text = FBuser.lastName
//                        let url = NSURL(string: "https://graph.facebook.com/\(FBuser.id)/picture?type=large&return_ssl_resources=1")
                        self.profilePictureView.image = UIImage(data: NSData(contentsOf: FBuser.picURL! as URL)! as Data)
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

    @IBAction func record (_ sender: AnyObject){
        if (recorder.isRecording){
            recorder.stopRecording{ (preview, error) in
                
                if preview != nil{
                    preview?.previewControllerDelegate = self
                    self.present(preview!, animated: true, completion: nil)
                }
                else {
                    debugPrint("Error" + error!.localizedDescription)
                }
                
            }
            
            recordButton.setTitle("Record", for: .normal)
            recordButton.setTitleColor(UIColor.blue, for: .normal)
            recordButton.sizeToFit()
            recordButton.center.x = self.view.center.x
        }

        else{
            recorder.startRecording{(error) in
                if error != nil {
                    debugPrint("Error" + error!.localizedDescription)
                }
                else{
                    self.recordButton.setTitle("Stop Recording", for: .normal)
                    self.recordButton.setTitleColor(UIColor.red, for: .normal)
                    self.recordButton.sizeToFit()
                    self.recordButton.center.x = self.view.center.x
                }
            }
        }
    }

    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        dismiss(animated: true)
    }

}
