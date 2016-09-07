//
//  Turrets.swift
//  SkyEscape
//
//  Created by Allen Boynton on 9/3/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import SpriteKit


class Turrets: SKSpriteNode {
    
    // Turret setup
    var node = SKNode()
    var turret = SKSpriteNode()
    var turretArray = [SKTexture]()
    
    // turret's animation setup
    var animation = SKAction()
    var animationFrames = [SKTexture]()
    
    init() {
        let texture = SKTexture(imageNamed: "turret_1_fire_1")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        animate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func animate() {
        
        let enemyAtlas: SKTextureAtlas = SKTextureAtlas(named: "Turret")
        
        for i in 1...enemyAtlas.textureNames.count {
            let myEnemy = "turret_1_fire_\(i)"
            turretArray.append(SKTexture(imageNamed: myEnemy))
        }
        
        // Add animated turret
        turret = SKSpriteNode(imageNamed: enemyAtlas.textureNames[0])
        animation = SKAction.repeatActionForever( SKAction.animateWithTextures(turretArray, timePerFrame: 0.1))
        self.runAction(animation)
    }
    
    func shoot(){
        
    }
    
    func kill(){
        
    }
    
    func fireBullet(scene: SKScene){
        
    }
}
