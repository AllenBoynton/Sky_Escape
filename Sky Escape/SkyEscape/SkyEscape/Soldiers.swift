////
////  Soldiers.swift
////  SkyEscape
////
////  Created by Allen Boynton on 9/3/16.
////  Copyright © 2016 Full Sail. All rights reserved.
////
//
//import SpriteKit
//
//
//class Soldiers: SKSpriteNode {
//    
//    // Soldier setup
//    var node = SKNode()
//    var soldier = SKSpriteNode()
//    var soldierArray = [SKTexture]()
//    
//    // soldier's animation setup
//    var animation = SKAction()
//    var animationFrames = [SKTexture]()
//    
//    init() {
//        let texture = SKTexture(imageNamed: "Soldier1_walk_1")
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
//        let enemyAtlas: SKTextureAtlas = SKTextureAtlas(named: "SoldierWalk")
//        
//        for i in 1...enemyAtlas.textureNames.count {
//            let myEnemy = "Soldier1_walk_\(i)"
//            soldierArray.append(SKTexture(imageNamed: myEnemy))
//        }
//        
//        // Add animated soldier
//        soldier = SKSpriteNode(imageNamed: enemyAtlas.textureNames[0])
//        animation = SKAction.repeatActionForever( SKAction.animateWithTextures(soldierArray, timePerFrame: 0.1))
//        self.runAction(animation)
//        
//        // Soldiers walk
//        let action = SKAction.moveToY(-20 + soldier.size.height, duration: 20.0)
//        let actionDone = SKAction.removeFromParent()
//        soldier.runAction(SKAction.sequence([action, actionDone]))
//    }
//    
//    func shoot(){
//        
//        let enemyAtlas: SKTextureAtlas = SKTextureAtlas(named: "SoldierShoot")
//        
//        for i in 1...enemyAtlas.textureNames.count {
//            let myEnemy = "Soldier1_shot_up_\(i)"
//            soldierArray.append(SKTexture(imageNamed: myEnemy))
//        }
//        
//        // Add animated soldier
//        soldier = SKSpriteNode(imageNamed: enemyAtlas.textureNames[0])
//        animation = SKAction.repeatActionForever( SKAction.animateWithTextures(soldierArray, timePerFrame: 0.1))
//        self.runAction(animation)
//    }
//    
//    func respawn(){
//        
//    }
//    
//    func fireBullet(scene: SKScene){
//        
//    }
//}
