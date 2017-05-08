//
// RoadView.swift
// Generated by Core Animator version 1.0 on 24/02/15.
//
// DO NOT MODIFY THIS FILE. IT IS AUTO-GENERATED AND WILL BE OVERWRITTEN
//

import UIKit

@IBDesignable
class RoadView : UIView {

	var viewsByName: [String : UIView]!

	// - MARK: Life Cycle

	required init() {
		super.init(frame: CGRect(x: 0, y: 0, width: 414, height: 736))
		self.setupHierarchy()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setupHierarchy()
	}

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
		self.setupHierarchy()
	}

	// - MARK: Scaling

	override func layoutSubviews() {
		super.layoutSubviews()

		if let scalingView = self.viewsByName["__scaling__"] {
			var xScale = self.bounds.size.width / scalingView.bounds.size.width
			var yScale = self.bounds.size.height / scalingView.bounds.size.height
			switch contentMode {
			case .scaleToFill:
				break
			case .scaleAspectFill:
				let scale = max(xScale, yScale)
				xScale = scale
				yScale = scale
			default:
				let scale = min(xScale, yScale)
				xScale = scale
				yScale = scale
			}
			scalingView.transform = CGAffineTransform(scaleX: xScale, y: yScale)
			scalingView.center = CGPoint(x:self.bounds.midX, y:self.bounds.midY)
		}
	}

	// - MARK: Setup

	func setupHierarchy() {
		var viewsByName: [String : UIView] = [:]
		let bundle = Bundle(for:type(of: self))
		let __scaling__ = UIView()
		__scaling__.bounds = CGRect(x:0, y:0, width:414, height:736)
		__scaling__.center = CGPoint(x:207.0, y:368.0)
		self.addSubview(__scaling__)
		viewsByName["__scaling__"] = __scaling__

		let road = UIImageView()
		road.bounds = CGRect(x:0, y:0, width:621.0, height:2208.0)
		var imgRoad: UIImage!
		if let imagePath = bundle.path(forResource: "road.png", ofType:nil) {
			imgRoad = UIImage(contentsOfFile:imagePath)
		}
		road.image = imgRoad
		road.contentMode = .center;
		road.layer.position = CGPoint(x:207.862, y:0.000)
		road.transform = CGAffineTransform(scaleX: 0.67, y: 0.67)
		__scaling__.addSubview(road)
		viewsByName["road"] = road

		self.viewsByName = viewsByName
	}

	// - MARK: drive

	func addDriveAnimation() {
		addDriveAnimationWithBeginTime(beginTime: 0, fillMode: kCAFillModeBoth, removedOnCompletion: false)
	}

	func addDriveAnimation(removedOnCompletion: Bool) {
		addDriveAnimationWithBeginTime(beginTime: 0, fillMode: removedOnCompletion ? kCAFillModeRemoved : kCAFillModeBoth, removedOnCompletion: removedOnCompletion)
	}

	func addDriveAnimationWithBeginTime(beginTime: CFTimeInterval, fillMode: String, removedOnCompletion: Bool) {
		let linearTiming = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)

		let roadTranslationYAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
		roadTranslationYAnimation.duration = 2.500
		roadTranslationYAnimation.values = [0.000 as Float, 737.302 as Float]
		roadTranslationYAnimation.keyTimes = [0.000, 1.000]
		roadTranslationYAnimation.timingFunctions = [linearTiming]
		roadTranslationYAnimation.repeatCount = HUGE
		roadTranslationYAnimation.beginTime = beginTime
		roadTranslationYAnimation.fillMode = fillMode
		roadTranslationYAnimation.isRemovedOnCompletion = removedOnCompletion
		self.viewsByName["road"]?.layer.add(roadTranslationYAnimation, forKey:"drive_TranslationY")
	}

	func removeDriveAnimation() {
		self.viewsByName["road"]?.layer.removeAnimation(forKey: "drive_TranslationY")
	}

	func removeAllAnimations() {
		for subview in viewsByName.values {
			subview.layer.removeAllAnimations()
		}
	}
}
