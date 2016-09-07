////
////  Tanks.swift
////  SkyEscape
////
////  Created by Allen Boynton on 9/3/16.
////  Copyright © 2016 Full Sail. All rights reserved.
////
//
//import SpriteKit
//
//
//class Tanks: SKSpriteNode {
//    
//    // Tank setup
//    var node = SKNode()
//    var tanks = SKSpriteNode()
//    var tankArray = [SKTexture]()
//    
//    // Tank's animation setup
//    var animation = SKAction()
//    var animationFrames = [SKTexture]()
//    
//    init() {
//        let texture = SKTexture(imageNamed: "tank_move_forward_4")
//        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
//        animate()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    private func animate(){
//        
//        let enemyAtlas: SKTextureAtlas = SKTextureAtlas(named: "TankForward")
//        
//        for i in 1...enemyAtlas.textureNames.count {
//            let myEnemy = "tank_move_forward_\(i)"
//            tankArray.append(SKTexture(imageNamed: myEnemy))
//        }
//        
//        // Add animated tank
////        tanks = SKSpriteNode(imageNamed: enemyAtlas.textureNames[0])
//        
//        let action = SKAction.moveToX(-200, duration: 8.0)
//        let actionDone = SKAction.removeFromParent()
//        self.runAction(SKAction.sequence([action, actionDone]))
//        
//        animation = SKAction.repeatActionForever( SKAction.animateWithTextures(tankArray, timePerFrame: 0.1))
//        self.runAction(animation)
//    }
//    
//    func animateAttack() {
//        
//        let enemyAtlas: SKTextureAtlas = SKTextureAtlas(named: "TankAttack")
//        
//        for i in 1...enemyAtlas.textureNames.count {
//            let myEnemy = "tank_attack_\(i)"
//            tankArray.append(SKTexture(imageNamed: myEnemy))
//        }
//        
//        // Add animated tank
//        tanks = SKSpriteNode(imageNamed: enemyAtlas.textureNames[0])
//        animation = SKAction.repeatActionForever( SKAction.animateWithTextures(tankArray, timePerFrame: 0.1))
//        self.runAction(animation)
//    }
//    
//    func move() {
//        
//        let enemyAtlas: SKTextureAtlas = SKTextureAtlas(named: "TankForward")
//        
//        for i in 1...enemyAtlas.textureNames.count {
//            let myEnemy = "tank_move_forward_\(i)"
//            tankArray.append(SKTexture(imageNamed: myEnemy))
//        }
//        
//        // Add animated tank
////        tanks = SKSpriteNode(imageNamed: enemyAtlas.textureNames[0])
//
//        // Shoot em up!
//        let action = SKAction.moveToX(-200, duration: 8.0)
//        let actionDone = SKAction.removeFromParent()
//        self.runAction(SKAction.sequence([action, actionDone]))
//        
//        animation = SKAction.repeatActionForever(SKAction.animateWithTextures(tankArray, timePerFrame: 0.1))
//        self.runAction(animation)
//    }
//    
//    func die() {
//        
//    }
//    
//    func respawn() {
//        
//    }
//    
//    func fireBullet(scene: SKScene) {
//        
//    }
//}
