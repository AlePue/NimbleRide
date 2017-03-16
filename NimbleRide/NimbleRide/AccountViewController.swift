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


class AccountViewController: UIViewController, RPPreviewViewControllerDelegate {

    @IBOutlet weak var FBloginButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var profilePictureView: UIImageView!
    var userData = NSDictionary()
    let recorder = RPScreenRecorder.shared()

    override func viewDidLoad() {
        super.viewDidLoad()

        }

    @IBAction func FBloginButton(_ sender: AnyObject) {
        print("BUTTON PRESSED")
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from:self) { (result, error) -> Void in
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

//                    EXAMPLE OUTPUT
//                    {
//                        "first_name" = fName;
//                        id = XXXXXXXXXXXXXXXX;
//                        "last_name" = rName;
//                        picture =     {
//                            data =         {
//                                "is_silhouette" = 0;
//                                url = "https://scontent.xx.fbcdn.net/v/t1.0-1/p200x200/10616212_810595085656784_6649283448814146059_n.jpg?oh=94758241ed6a922c90fdd3b96f59bb01&oe=5964FD3A";
//                            };
//                        };
//                    }


                    self.userData = FBuserData as! NSDictionary
//                    for (key, value) in self.userData {
//                        print("\(key) -> \(value)")
//                    }
//                    print(self.userData["first_name"]!)
////                    print(self.userData)
                    self.firstNameLabel.text = String (describing: self.userData["first_name"]!)
                    self.lastNameLabel.text = String (describing: self.userData["last_name"]!)
                    let FBid = self.userData["id"] as? String
                    let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
                    self.profilePictureView.image = UIImage(data: NSData(contentsOf: url! as URL)! as Data)
//                    self.profilePictureView.image = UIImage (data: self.userData[data]!)
                }
            })
        }
    }

    @IBAction func record (_ sender: AnyObject){
        if (recorder.isRecording){
            recorder.stopRecording{ (preview, error) in
                
                if preview != nil{
                    preview?.previewControllerDelegate = self
                    self.present(preview!, animated: true, completion: nil)
                }
                else {
                    print("Error" + error!.localizedDescription)
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
                    print("Error" + error!.localizedDescription)
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
