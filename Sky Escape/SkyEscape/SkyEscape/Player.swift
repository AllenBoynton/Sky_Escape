//
//  Player.swift
//  SkyEscape
//
//  Created by Allen Boynton on 8/30/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//


import SpriteKit


class Player: SKSpriteNode {
    
    // MyPlane animation setup
    var node = SKNode()
    var myPlane = SKSpriteNode()
    var planeArray = [SKTexture]()
    
    // Image atlas's for animation
    var animation = SKAction()
    var animationFrames = [SKTexture]()
    
    // Shooting
    private var canFire = true
    
    init() {
        let texture = SKTexture(imageNamed: "1Fokker_default_1")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        animate()
    }
    
    // protocol init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Default animation of myPlane's flight in battle
    private func animate() {
        
        let myPlaneAtlas: SKTextureAtlas = SKTextureAtlas(named: "Attack")
        
        for i in 1...myPlaneAtlas.textureNames.count {
            let plane = "MyFokker\(i)"
            planeArray.append(SKTexture(imageNamed: plane))
        }
        
        // Add user's animated bi-plane
        myPlane = SKSpriteNode(imageNamed: myPlaneAtlas.textureNames[0])
        animation = SKAction.repeatActionForever( SKAction.animateWithTextures(planeArray, timePerFrame: 0.1))
        self.runAction(animation)
    }
    
    // myPlane flying downward / no animation
    func playerDown() {
        
        myPlane = SKSpriteNode(imageNamed: "1Fokker_down_1")
    }
    
    // myPlane flying upwards / no animation
    func playerUp() {
        
        myPlane = SKSpriteNode(imageNamed: "1Fokker_up_1")
    }
    
    // myPlane hit in battle
    func playerHit() {
        
        let myPlaneAtlas: SKTextureAtlas = SKTextureAtlas(named: "Hit")
        
        for i in 1...myPlaneAtlas.textureNames.count {
            let plane = "1Fokker_hit_\(i)"
            planeArray.append(SKTexture(imageNamed: plane))
        }
        
        // Add user's animated bi-plane
        myPlane = SKSpriteNode(imageNamed: myPlaneAtlas.textureNames[0])
        
        animation = SKAction.repeatActionForever( SKAction.animateWithTextures(planeArray, timePerFrame: 0.1))
        self.runAction(animation)
    }
    
    // myPlane hit in battle and damaged with bullets
    func hitDamaged() {
        
        let myPlaneAtlas: SKTextureAtlas = SKTextureAtlas(named: "HitDamaged")
        
        for i in 1...myPlaneAtlas.textureNames.count {
            let plane = "1Fokker_hit_damaged_\(i)"
            planeArray.append(SKTexture(imageNamed: plane))
        }
        
        // Add user's animated bi-plane
        myPlane = SKSpriteNode(imageNamed: myPlaneAtlas.textureNames[0])
        
        animation = SKAction.repeatActionForever( SKAction.animateWithTextures(planeArray, timePerFrame: 0.1))
        self.runAction(animation)
    }
    
    func upDamaged() {
        
        let myPlaneAtlas: SKTextureAtlas = SKTextureAtlas(named: "UpDamage")
        
        for i in 1...myPlaneAtlas.textureNames.count {
            let plane = "1Fokker_up_damaged_\(i)"
            planeArray.append(SKTexture(imageNamed: plane))
        }
        
        // Add user's animated bi-plane
        myPlane = SKSpriteNode(imageNamed: myPlaneAtlas.textureNames[0])
        
        animation = SKAction.repeatActionForever( SKAction.animateWithTextures(planeArray, timePerFrame: 0.1))
        self.runAction(animation)
    }
    
    func downDamaged() {
        
        let myPlaneAtlas: SKTextureAtlas = SKTextureAtlas(named: "DownDamage")
        
        for i in 1...myPlaneAtlas.textureNames.count {
            let plane = "1Fokker_down_damaged_\(i)"
            planeArray.append(SKTexture(imageNamed: plane))
        }
        
        // Add user's animated bi-plane
        myPlane = SKSpriteNode(imageNamed: myPlaneAtlas.textureNames[0])
        
        animation = SKAction.repeatActionForever( SKAction.animateWithTextures(planeArray, timePerFrame: 0.1))
        self.runAction(animation)
    }
    
    func attackDamaged() {
        
        let myPlaneAtlas: SKTextureAtlas = SKTextureAtlas(named: "AttackDamaged")
        
        for i in 1...myPlaneAtlas.textureNames.count {
            let plane = "1Fokker_attack_damaged_\(i)"
            planeArray.append(SKTexture(imageNamed: plane))
        }
        
        // Add user's animated bi-plane
        myPlane = SKSpriteNode(imageNamed: myPlaneAtlas.textureNames[0])
        
        animation = SKAction.repeatActionForever( SKAction.animateWithTextures(planeArray, timePerFrame: 0.1))
        self.runAction(animation)
    }
    
    func death() {
        
        let myPlaneAtlas: SKTextureAtlas = SKTextureAtlas(named: "Death")
        
        for i in 1...myPlaneAtlas.textureNames.count {
            let plane = "1Fokker_death_\(i)"
            planeArray.append(SKTexture(imageNamed: plane))
        }
        
        // Add user's animated bi-plane
        myPlane = SKSpriteNode(imageNamed: myPlaneAtlas.textureNames[0])
        
        animation = SKAction.repeatActionForever( SKAction.animateWithTextures(planeArray, timePerFrame: 0.1))
        self.runAction(animation)
    }
    
    func fireBullet(scene: SKScene){
        
        let myPlaneAtlas: SKTextureAtlas = SKTextureAtlas(named: "Attack")
        
        for i in 1...myPlaneAtlas.textureNames.count {
            let plane = "MyFokker\(i)"
            planeArray.append(SKTexture(imageNamed: plane))
        }
        
        // Add user's animated bi-plane
        myPlane = SKSpriteNode(imageNamed: myPlaneAtlas.textureNames[0])
        
        animation = SKAction.repeatActionForever( SKAction.animateWithTextures(planeArray, timePerFrame: 0.1))
        self.runAction(animation)
    }
    
    func respawn() {
        
    }
}
