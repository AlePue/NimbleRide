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
        let size = CGSize(width: view.frame.width, height: 300)
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
        
        attributedText.append(NSAttributedString(string: "\n April 20 Burn Trees, Get Money ", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)]))
        
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
        rideImage.image = UIImage(named: "NimbleRideLogo")
        rideImage.contentMode = .scaleAspectFill
        rideImage.layer.masksToBounds = true
        
        return rideImage
    }()
    
    
    
    func setupViews() {
        backgroundColor = UIColor.white
        
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(rideTextView)
        addSubview(rideImageView)
        
        addConstraintsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)  //1
        
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: rideTextView)
        
         addConstraintsWithFormat(format: "H:|[v0]|", views: rideImageView)
        
        addConstraintsWithFormat(format: "V:|-12-[v0]", views: nameLabel)                                  //2
        
        addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1(50)]-4-[v2]|", views: profileImageView, rideTextView, rideImageView)                    //3
       
        
        
        
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










