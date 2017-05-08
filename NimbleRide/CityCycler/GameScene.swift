//
//  GameScene.swift
//  CityCycler
//
//  Created by Alejandro Puente on 11/18/16.
//  Copyright © 2016 Alejandro Puente. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let player : UInt32 = 0x01 << 1
    static let enemy : UInt32 = 0x01 << 2
}

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
//        var Player = GameViewController.sharedInstance.player
    
        
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
       //createObstacles()
    }
    
//    func createObstacles() {
//        
//        
//        let ObstaclePair = SKNode() // add obstacles to node, then be able to edit position.
//        let leftObstacle = SKSpriteNode(imageNamed: "leftObstacle")
//        let rightObstacle = SKSpriteNode(imageNamed: "rightObstacle")  // name of left and right could be the same
//        
//        leftObstacle.position = CGPoint(x: self.frame.width / 4, y: self.frame.height / 2 + 500)
//        rightObstacle.position = CGPoint(x: self.frame.width / 4, y: self.frame.height / 2)
//        
//        leftObstacle.setScale(0.5)
//        rightObstacle.setScale(0.5)
//        
//        
//        ObstaclePair.addChild(leftObstacle)
//        ObstaclePair.addChild(rightObstacle)
//        
//        
//        self.addChild(ObstaclePair)
//        
//    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
