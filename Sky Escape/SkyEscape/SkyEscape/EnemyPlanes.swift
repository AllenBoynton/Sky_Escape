//
//  EnemyPlanes.swift
//  SkyEscape
//
//  Created by Allen Boynton on 9/6/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import UIKit
import SpriteKit

class EnemyPlanes: SKSpriteNode {
    
    // MyPlane setup
    var fokker1 = SKSpriteNode()
    var fokker2 = SKSpriteNode()
    var fokkerArray = [SKTexture]()
    
    // MyPlane's animation setup
    var animation = SKAction()
    
    init() {
        let texture = SKTexture(imageNamed: "enemy1_attack_1")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        animate1()
        animate2()
    }
    
    // protocol init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Default animation of myPlane's flight in battle
    private func animate1() {
        
        let myPlaneAtlas: SKTextureAtlas = SKTextureAtlas(named: "Enemy1Attack")
        
        for i in 1...myPlaneAtlas.textureNames.count {
            let fokker1 = "enemy1_attack_\(i)"
            fokkerArray.append(SKTexture(imageNamed: fokker1))
        }
        
        // Add user's animated bi-plane
        fokker1 = SKSpriteNode(imageNamed: myPlaneAtlas.textureNames[0])
        animation = SKAction.repeatActionForever(SKAction.animateWithTextures(fokkerArray, timePerFrame: 0.1))
        self.runAction(animation)
    }
    
    // Enemy plane fokker #2
    func animate2() {
        
        let enemy2Atlas = SKTextureAtlas(named: "Enemy2Attack")
        
        // Animation of second enemy random pathway plane
        for i in 1...enemy2Atlas.textureNames.count {
            let fokker2 = "enemy2_attack_\(i)"
            fokkerArray.append(SKTexture(imageNamed: fokker2))
        }
        
        // Add enemy animated bi-plane 2
        fokker2 = SKSpriteNode(imageNamed: enemy2Atlas.textureNames[0])
        animation = SKAction.repeatActionForever(SKAction.animateWithTextures(fokkerArray, timePerFrame: 0.1))
        self.runAction(animation)
    }
    
//    func fokkerDie1() {
//            
//            let die1Atlas: SKTextureAtlas = SKTextureAtlas(named: "Death")
//            
//            for i in 1...die1Atlas.textureNames.count {
//                let myEnemy1 = "1Fokker_death_\(i)"
//                die1Array.append(SKTexture(imageNamed: myEnemy1))
//            }
//            
//            // Add user's animated dying bi-plane
//            myEnemy1 = SKSpriteNode(imageNamed: die1Atlas.textureNames[0])
//            animation = SKAction.repeatActionForever( SKAction.animateWithTextures(die1Array, timePerFrame: 0.1))
//            self.runAction(animation)
//    }
//    
//    func fokkerDie2() {
//        
//        let die2Atlas: SKTextureAtlas = SKTextureAtlas(named: "Death")
//        
//        for i in 1...die2Atlas.textureNames.count {
//            let myEnemy2 = "1Fokker_death_\(i)"
//            die1Array.append(SKTexture(imageNamed: myEnemy2))
//        }
//        
//        // Add user's animated dying bi-plane
//        myEnemy2 = SKSpriteNode(imageNamed: die2Atlas.textureNames[0])
//        animation = SKAction.repeatActionForever( SKAction.animateWithTextures(die1Array, timePerFrame: 0.1))
//        self.runAction(animation)
//    }
    
    func fireEnemyBullets(scene: SKScene){
        
    }
}
