//
//  GameViewController.swift
//  CityCycler
//
//  Created by Alejandro Puente on 11/18/16.
//  Copyright © 2016 Alejandro Puente. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var road: RoadView!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var player: UIImageView!
    var enemy: EnemyCarView!
    var bikeMovementGestureRecognizer: UIGestureRecognizer!
    var animationTimer:Timer!
    var updateTimer:Timer!
    let leftBoarder = 90
    let rightBoarder = 180
    var isPlaying = false
    var points = 0
    //var speed = 0
    var updateRate = 0.05
    
    //var gameSpeed1 = 1
    //var gameSpeed2 = 2
    //var gameSpeed3 = 3
    
    var gameSpeed = 2.5
    var difficulty = 0.0
    var currentTime: CFTimeInterval = 1.8
    static let sharedInstance = GameViewController()
    var firstLaunch:Bool = true
    
    
    var gameSpeed1 = UserDefaults.standard.integer(forKey: "difficulty")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        road.addDriveAnimation()
        gameInit()
        
        
        //        if let view = self.view as! SKView? {
        //            // Load the SKScene from 'GameScene.sks'
        //            if let scene = SKScene(fileNamed: "GameScene") {
        //                // Set the scale mode to scale to fit the window
        //                scene.scaleMode = .aspectFill
        //
        //                // Present the scene
        //                view.presentScene(scene)
        //            }
        //
        //            view.ignoresSiblingOrder = true
        //
        //            view.showsFPS = true
        //            view.showsNodeCount = true
        //        }
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                //                print("Swiped right")
                if player.frame.origin.x < CGFloat(rightBoarder){
                    player.frame.origin.x += 90
                }
                break
            case UISwipeGestureRecognizerDirection.left:
                //                print("Swiped left")
                if player.frame.origin.x > CGFloat(leftBoarder){
                    player.frame.origin.x -= 90
                }
                break
            default:
                break
            }
        }
    }
    
    func gameInit(){
        
        if firstLaunch {
            points = 0
            scoreLabel.text = "\(points)"
            highScoreLabel.text = "\(points)"
        }
        
        isPlaying = true
        points = 0
        scoreLabel.text = "\(points)"
        difficulty = 0.0
        gameSpeed = 2.5
        
        
        //Adding the player
        player = UIImageView(image: UIImage(named: "bike"))
        player.frame = CGRect(x:0, y:0, width:60, height:80)
        player.frame.origin.y = self.view.bounds.height - player.frame.size.height - 10
        player.center.x = self.view.bounds.midX
        
        self.view.insertSubview(player, aboveSubview: road)
        
        //Adding the enemey function
        addEnemy()
        
        updateTimer = Timer.scheduledTimer(timeInterval: TimeInterval(updateRate), target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    
    func gameEnd() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as UIViewController
        self.present(nextViewController, animated:true, completion:nil)
        print("here it is")
        }
    
    
    func addEnemy(){
        if isPlaying {
            
            if gameSpeed1 == 1{
                var randomEnemyFrame = CGRect(x: 0, y:  -player.frame.size.height,width:  player.frame.size.width,height:  player.frame.size.height)
                let randomX = leftBoarder - 20 + (Int(arc4random_uniform(3)) * (rightBoarder - leftBoarder)) // generates enemy to be 1 of 3 possible locations
                randomEnemyFrame.origin.x = CGFloat(randomX)
                enemy = EnemyCarView(frame: randomEnemyFrame)
                //enemy.addPoluteAnimation() //adds pollution to the animation
                self.view.insertSubview(enemy, aboveSubview: road)
                UIView.animate(withDuration: gameSpeed, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                    self.enemy.frame.origin.y = self.view.bounds.height + self.enemy.frame.height
                }) { (success:Bool) -> Void in
                    
                    if self.isPlaying{
                        if self.firstLaunch {
                            self.firstLaunch = false
                            self.points = -1
                            self.scoreLabel.text = "\(self.points)"
                        } else {
                            
                            self.points+=1
                            self.scoreLabel.text = "\(self.points)"
                            
                            if (self.highScoreLabel.text! < self.scoreLabel.text!){
                                self.highScoreLabel.text = self.scoreLabel.text
                            }
                        }
                    }
                    self.enemy.removeFromSuperview()
                    self.addEnemy()
                }
            }
            
            else if gameSpeed1 == 2{
                var randomEnemyFrame = CGRect(x: 0, y:  -player.frame.size.height,width:  player.frame.size.width,height:  player.frame.size.height)
                let randomX = leftBoarder - 20 + (Int(arc4random_uniform(3)) * (rightBoarder - leftBoarder)) // generates enemy to be 1 of 3 possible locations
                randomEnemyFrame.origin.x = CGFloat(randomX)
                enemy = EnemyCarView(frame: randomEnemyFrame)
                //enemy.addPoluteAnimation() //adds pollution to the animation
                self.view.insertSubview(enemy, aboveSubview: road)
                UIView.animate(withDuration: gameSpeed*0.75, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                    self.enemy.frame.origin.y = self.view.bounds.height + self.enemy.frame.height
                }) { (success:Bool) -> Void in
                    
                    if self.isPlaying{
                        if self.firstLaunch {
                            self.firstLaunch = false
                            self.points = -1
                            self.scoreLabel.text = "\(self.points)"
                        } else {
                            
                            self.points+=1
                            self.scoreLabel.text = "\(self.points)"
                            
                            if (self.highScoreLabel.text! < self.scoreLabel.text!){
                                self.highScoreLabel.text = self.scoreLabel.text
                            }
                        }
                    }
                    self.enemy.removeFromSuperview()
                    self.addEnemy()
                }
            }
            
            else if gameSpeed1 == 3{
                var randomEnemyFrame = CGRect(x: 0, y:  -player.frame.size.height,width:  player.frame.size.width,height:  player.frame.size.height)
                let randomX = leftBoarder - 20 + (Int(arc4random_uniform(3)) * (rightBoarder - leftBoarder)) // generates enemy to be 1 of 3 possible locations
                randomEnemyFrame.origin.x = CGFloat(randomX)
                enemy = EnemyCarView(frame: randomEnemyFrame)
                //enemy.addPoluteAnimation() //adds pollution to the animation
                self.view.insertSubview(enemy, aboveSubview: road)
                UIView.animate(withDuration: gameSpeed * 0.4, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                    self.enemy.frame.origin.y = self.view.bounds.height + self.enemy.frame.height
                }) { (success:Bool) -> Void in
                    
                    if self.isPlaying{
                        if self.firstLaunch {
                            self.firstLaunch = false
                            self.points = -1
                            self.scoreLabel.text = "\(self.points)"
                        } else {
                            self.points+=1
                            self.scoreLabel.text = "\(self.points)"
                            
                            if (self.highScoreLabel.text! < self.scoreLabel.text! || self.highScoreLabel.text! <= String(9)){
                                self.highScoreLabel.text = self.scoreLabel.text
                            }
                            //Add condition if highscoreLabel is > scoreLabel
                        }

                    }
                    self.enemy.removeFromSuperview()
                    self.addEnemy()
                }
            }
            else if gameSpeed1 > 3 || gameSpeed1 < 1{
                //displayMyaAlertMessage(userMessage: "Can only select 1-3")
            }
                
            else{
                
                var randomEnemyFrame = CGRect(x: 0, y:  -player.frame.size.height,width:  player.frame.size.width,height:  player.frame.size.height)
                let randomX = leftBoarder - 20 + (Int(arc4random_uniform(3)) * (rightBoarder - leftBoarder)) // generates enemy to be 1 of 3 possible locations
                randomEnemyFrame.origin.x = CGFloat(randomX)
                enemy = EnemyCarView(frame: randomEnemyFrame)
                //enemy.addPoluteAnimation() //adds pollution to the animation
                self.view.insertSubview(enemy, aboveSubview: road)
                
                //updateSpeed()//update speed with each enemy created
                
                //Change duration to make the cars go faster. The lower the number the faster the car goes.
                //Change the delay to make the cars wait to be displayed on screen.
                UIView.animate(withDuration: gameSpeed, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                    self.enemy.frame.origin.y = self.view.bounds.height + self.enemy.frame.height
                }) { (success:Bool) -> Void in
                    
                    if self.isPlaying{
                        if self.firstLaunch {
                            self.firstLaunch = false
                            self.points = -1
                            self.scoreLabel.text = "\(self.points)"
                        } else {
                            
                            self.points+=1
                            self.scoreLabel.text = "\(self.points)"
                            
                            if (self.highScoreLabel.text! < self.scoreLabel.text!){
                                self.highScoreLabel.text = self.scoreLabel.text
                            }
                        }
                    }
                    self.enemy.removeFromSuperview()
                    self.addEnemy()
                }
            }
        }
    }
    
    func displayMyaAlertMessage(userMessage: String){
        let myAlert = UIAlertController(title: "Error", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }

    
    func update (time:Timer) {
        
        if difficulty < 10 {
            difficulty += updateRate
        }
        else{
            difficulty = 0.0
            if gameSpeed > 0.5{
                gameSpeed -= 0.5
            }
        }
        
        if ((player.layer.presentation()?.frame)?.intersects((enemy.layer.presentation()?.frame)!))! {
            endGame()
        }
    }
    
    func endGame() {
        isPlaying = false
        enemy.layer.removeAllAnimations()
        updateTimer.invalidate()
        
        //add explosion
        let explosion = ExplosionView(frame: CGRect(x: 0, y: 0,width: 100,height: 100))
        explosion.center = CGPoint(x:enemy.center.x,y: enemy.center.y - 250)
        explosion.contentMode = .center
        
        self.view.insertSubview(explosion, aboveSubview: player)
        
        enemy.removeFromSuperview()
        player.removeFromSuperview()
        
        explosion.addExplodeAnimation()
        
        //explosion.addExplodeAnimation { (success:Bool) -> Void in
        let alert = UIAlertController(title: "Game over!", message: "Do you want to play again?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: { (alertAction:UIAlertAction!) -> Void in self.gameEnd()}))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (alertAction:UIAlertAction!) -> Void in
            self.gameInit() }))
        
        
        self.present(alert, animated: true, completion: nil)
        explosion.removeFromSuperview()
        
        //highScoreLabel = scoreLabel
        //self.scoreLabel.text = String(0)
        //}
    }
    
    func viewDidAppera(animated: Bool){
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLogin")
        if(!isUserLoggedIn){
            self.performSegue(withIdentifier: "loginView", sender: self)
        }
    }
}





