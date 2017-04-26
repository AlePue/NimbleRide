//
//  Feed2ViewController.swift
//  NimbleRide
//
//  Created by Alejandro Puente on 4/25/17.
//  Copyright © 2017 Alejandro Puente. All rights reserved.
//

import UIKit

let cellId = "cellID"


class Feed2ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        // Do any additional setup after loading the view.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3 // number of actual card to show
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.frame.width, height: 400)
        return size
//        return CGSizeMake(view.frame.width, 50)
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
        label.numberOfLines = 2
        
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
        attributedText.append(NSAttributedString(string: dateOfRide, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.rgb(red: 83, green: 115, blue: 125)]))

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
        textView.text = "YEAH i do drugs everyday but 420 is special man, jah lives and jah will provide"
        textView.font = UIFont.systemFont(ofSize: 14)
        
        return textView
    }()
    
    let rideImageView: UIImageView = {
        let rideImage = UIImageView()
        rideImage.image = UIImage(named: "map")
        rideImage.contentMode = .scaleAspectFill
        rideImage.layer.masksToBounds = true
        
        return rideImage
    }()
    
    let actionsLabel: UILabel = {
       let actionLabel = UILabel()
        actionLabel.text = "1 Like     0 Comments"
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
        
        addConstraintsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)  //1
        
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: rideTextView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: rideImageView)
        
        addConstraintsWithFormat(format: "H:|-12-[v0]|", views: actionsLabel)
        
        addConstraintsWithFormat(format: "V:|-12-[v0]", views: nameLabel)                                  //2
        
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: dividerView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: likeButton)
        
        addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1(50)]-4-[v2]-8-[v3(25)]-8-[v4(0.5)][v5(40)]|", views: profileImageView, rideTextView, rideImageView, actionsLabel, dividerView, likeButton)                    //3
       
        
        
        
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0(44)]-8-[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": profileImageView, "v1": nameLabel]))    //1
//        
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))   //2
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0(44)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": profileImageView]))   //3
        
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










