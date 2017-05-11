//
//  FeedViewController.swift
//  NimbleRide
//
//  Created by Alejandro Puente on 4/25/17.
//  Copyright © 2017 Alejandro Puente. All rights reserved.
//

import UIKit
import AWSDynamoDB

let cellId = "cellID"
struct feedData{
    static  var Data = Array<History>()
}


class FeedViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
    var refreshControl:UIRefreshControl!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        // Do any additional setup after loading the view.
        collectionView?.reloadData()
        
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        collectionView!.addSubview(refreshControl)
    }

    func refresh(sender:AnyObject){
        feedData.Data.removeAll()
        loadDB(controller: self, userId: NSNumber(value: FtueViewController.FBuser.id))
        for friend in FtueViewController.FBuser.friendList{
            loadDB(controller: self, userId: NSNumber(value: friend))
        }
        feedData.Data = feedData.Data.sorted { (History1: History, History2: History) -> Bool in
            return History1.RideID?.compare(History2.RideID!) == ComparisonResult.orderedDescending
        }
        collectionView?.reloadData()
        refreshControl.endRefreshing()
        performSegue(withIdentifier: "fake", sender: AnyObject.self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        Data.removeAll()
//        loadDB(controller: self, userId: NSNumber(value: FtueViewController.FBuser.id))
//        for friend in FtueViewController.FBuser.friendList{
//            loadDB(controller: self, userId: NSNumber(value: friend))
//        }
        feedData.Data = feedData.Data.sorted { (History1: History, History2: History) -> Bool in
            return History1.RideID?.compare(History2.RideID!) == ComparisonResult.orderedDescending
        }
        collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedData.Data.count // number of actual card to show
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell

        let picURL = NSURL(string: "https://graph.facebook.com/\(String(describing: feedData.Data[indexPath.row].userId as! Int))/picture?type=large&return_ssl_resources=1")
        cell.profileImageView.image = UIImage(data: NSData(contentsOf: picURL! as URL)! as Data)

        let nameDate = NSMutableAttributedString(string: feedData.Data[indexPath.row].fName! + " " + feedData.Data[indexPath.row].lName!, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
        let rideDate = getDate(epochDB: feedData.Data[indexPath.row].RideID!)
        let rideDateDate = "\n" + rideDate
        let date = NSAttributedString(string: rideDateDate, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 10), NSForegroundColorAttributeName: UIColor.rgb(red: 83, green: 115, blue: 125)])
        nameDate.append(date)
        let rideLocation = "\n" + feedData.Data[indexPath.row].landmark! + "\n" + feedData.Data[indexPath.row].city! + ", " + feedData.Data[indexPath.row].state! + ", " + feedData.Data[indexPath.row].country!
        let locationText = NSAttributedString(string: rideLocation, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 10), NSForegroundColorAttributeName: UIColor.rgb(red: 83, green: 115, blue: 125)])
        nameDate.append(locationText)
        cell.nameLabel.attributedText = nameDate

        let avgSpeed = "Average Speed  - " + String(describing: feedData.Data[indexPath.row].avgSpeed as! Float) + " mph" + "\n"
        let cals = "Calories Burned  - " + String(describing: feedData.Data[indexPath.row].calBurned as! Int) + "\n"
        let dist = "Distance  - " + String(describing: feedData.Data[indexPath.row].distance as! Float) + " miles" + "\n"
        let time = "Time  - " + feedData.Data[indexPath.row].time!
        cell.rideTextView.text = avgSpeed + cals + dist + time

        let cSelector = #selector(deleteCard)
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: cSelector )
        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
        cell.addGestureRecognizer(rightSwipe)
        
        let cSelector1 = #selector(newLike)
        let likeTap = UITapGestureRecognizer(target: self, action: cSelector1 )
        cell.likeButton.addGestureRecognizer(likeTap)
        
        return cell
    }

    func deleteCard(sender: UISwipeGestureRecognizer){
        let cell = sender.view as! UICollectionViewCell
        let i = self.collectionView?.indexPath(for: cell)!
        let dataToDelete = feedData.Data[(i?.row)!]

        if (FtueViewController.FBuser.id == dataToDelete.userId as! Int){
            let alertController = UIAlertController(title: "Delete Ride", message: "Would you like to delete your ride?", preferredStyle: .alert)
            let yesAlertButton = UIAlertAction(title: "Yes", style: .default, handler: {
                action in
                feedData.Data.remove(at: (i?.row)!)
                self.collectionView?.deleteItems(at: [i!])
                self.deleteDB(controller: self, history: dataToDelete)
            })
            let noAlertButton = UIAlertAction(title: "No", style: .destructive, handler: nil)

            alertController.addAction(yesAlertButton)
            alertController.addAction(noAlertButton)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func newLike(sender: UITapGestureRecognizer){
        let cellInit = sender.location(in: self.collectionView)
        let i: NSIndexPath = self.collectionView?.indexPathForItem(at: cellInit)! as! NSIndexPath
        let cell = self.collectionView?.cellForItem(at: i as IndexPath) as! FeedCell
        let strLikes = cell.actionsLabel.text?.components(separatedBy: " ")
        let strCurrentLikes = strLikes?.first
        if cell.likeButton.title(for: .normal) == "Unlike"{
            var intLikes = Int(strCurrentLikes!)! - 1
            cell.actionsLabel.text = "\(intLikes) Likes"
            cell.likeButton.setTitleColor(UIColor.rgb(red: 166, green: 161, blue: 171), for: .normal)
            cell.likeButton.setTitle("Like", for: .normal)
        }
        else{
            var intLikes = Int(strCurrentLikes!)! + 1
            cell.actionsLabel.text = "\(intLikes) Likes"
            cell.likeButton.setTitleColor(UIColor.red, for: .normal)
            cell.likeButton.setTitle("Unlike", for: .normal)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.frame.width, height: 400)
        return size
//        return CGSizeMake(view.frame.width, 50)
    }

    func deleteDB(controller: UIViewController, history: History){
        dynamoDBObjectMapper.remove(history).continue({ (task:AWSTask!) -> Any? in
            if let error = task.error as NSError? {
                debugPrint("\nThe deletion request failed. \nError: \(error)\n")
                
                let alertController = UIAlertController(title: "Deletion Failed", message: "Your ride could not be deleted. Try again?", preferredStyle: .alert)
                let yesAlertButton = UIAlertAction(title: "Yes", style: .default, handler: {
                    action in
                    self.deleteDB(controller: controller, history: history)
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
//                    debugPrint(ride)
                    feedData.Data.append(ride as! History)
                }
            }
            return nil
        })
    }

    func getDate (epochDB : NSNumber) -> String{
        let dateOfRideEpoch = TimeInterval(epochDB)
        let formattedEpoch = Date(timeIntervalSince1970:  dateOfRideEpoch)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a" // EX: Apr 29, 2017 09:52 PM
        let dateOfRide = dateFormatter.string(from: formattedEpoch)

        return dateOfRide
    }
}

class FeedCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        
        let attributedText = NSMutableAttributedString(string: " King Nick R", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])

        let dateOfRideEpoch = TimeInterval(1493182377.904576)// Test: 2017-04-25 09:52:57 PM
//        let dateOfRideEpoch = TimeInterval(1493209753)// Test: 2017-04-26 05:29:13 AM
        let formattedEpoch = Date(timeIntervalSince1970:  dateOfRideEpoch)
        var dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
        var dateOfRide = dateFormatter.string(from: formattedEpoch)
        dateOfRide = "   " + dateOfRide

        print (dateOfRide)
        attributedText.append(NSAttributedString(string: dateOfRide, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 10), NSForegroundColorAttributeName: UIColor.rgb(red: 83, green: 115, blue: 125)]))

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4

        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.characters.count))

        let littleImage = NSTextAttachment()
        littleImage.image = UIImage(named: "NimbleRideLogo")
        littleImage.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
        attributedText.append(NSAttributedString(attachment: littleImage))

        label.attributedText = attributedText

        return label
    }()

    let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "NickR")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let rideTextView: UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isEditable = false
        textView.isScrollEnabled = false
        
        return textView
    }()
    
    let rideImageView: UIImageView = {
        let rideImage = UIImageView()
        rideImage.image = UIImage(named: "map")
        rideImage.contentMode = .scaleAspectFill
        rideImage.layer.masksToBounds = true
//        rideImage.layer.shadowColor = UIColor.black.cgColor
//        rideImage.layer.shadowOpacity = 1
//        rideImage.layer.shadowOffset = CGSize.zero
//        rideImage.layer.shadowRadius = 0
//        rideImage.layer.shouldRasterize = true

        return rideImage
    }()
    
    let actionsLabel: UILabel = {
       let actionLabel = UILabel()
        actionLabel.text = "1 Like"
        actionLabel.font = UIFont.systemFont(ofSize: 12)
        actionLabel.textColor = UIColor.rgb(red: 166, green: 161, blue: 171)
        return actionLabel
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 83, green: 115, blue: 125)
        
        return view
    }()
    
    let likeButton: UIButton = {
        let actionButton = UIButton()
        actionButton.setTitle("Like", for: .normal)
        actionButton.setTitleColor(UIColor.rgb(red: 143, green: 150, blue: 163), for: .normal)
//        actionButton.sendAction(<#T##action: Selector##Selector#>, to: <#T##Any?#>, for: <#T##UIEvent?#>)
        return actionButton
    }()
    
    func setupViews() {
        backgroundColor = UIColor.white

        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(rideTextView)
        addSubview(rideImageView)
        addSubview(actionsLabel)
        addSubview(dividerView)
        addSubview(likeButton)

        addConstraintsWithFormat(format: "H:|-8-[v0(50)]-8-[v1]|", views: profileImageView, nameLabel)  //1
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: rideTextView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: rideImageView)
        addConstraintsWithFormat(format: "H:|-12-[v0]|", views: actionsLabel)
        addConstraintsWithFormat(format: "V:|-5-[v0]", views: nameLabel)                                  //2
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: dividerView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: likeButton)

        addConstraintsWithFormat(format: "V:|-8-[v0(50)]-4-[v1(85)]-4-[v2]-8-[v3(25)]-8-[v4(0.5)][v5(40)]|", views: profileImageView, rideTextView, rideImageView, actionsLabel, dividerView, likeButton)             //3

    }
    
}




extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for(index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255 , blue: blue/255 , alpha: 1)
    }
}

class History : AWSDynamoDBObjectModel, AWSDynamoDBModeling  {
    var RideID:NSNumber?
    var userId:NSNumber?
    var avgSpeed:NSNumber?
    var calBurned:NSNumber?
    var distance:NSNumber?
    var fName:String?
    var lName:String?
    var time:String?
    var city:String?
    var state:String?
    var country:String?
    var landmark:String?
    
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
    var city:String?
    var state:String?
    var country:String?
    var landmark:String?
    
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





