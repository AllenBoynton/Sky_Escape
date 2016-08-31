//
//  SkyEnemy.swift
//  SkyEscape
//
//  Created by Allen Boynton on 8/30/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import SpriteKit


class SkyEnemy: SKSpriteNode {
    
    // Enemy planes / Ground / weapons
    var enemy1 = SKSpriteNode(imageNamed: "enemy1")
    var enemy2 = SKSpriteNode(imageNamed: "enemy2")
    var enemy3 = SKSpriteNode(imageNamed: "enemy3")
    var enemy4 = SKSpriteNode(imageNamed: "enemy4")
    var enemyArray: [SKSpriteNode] = []
    var randomEnemy = SKSpriteNode()
    var enemyFire = SKSpriteNode()
    

    // Initiate enemy with 2 parameters
    init() {
        let texture = SKTexture(imageNamed: "randomEnemy")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        self.name = "randomEnemy"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // SkyEnemy flying spawning
    func setupSkyEnemy() {
        
        // Sky enemy array
        enemyArray = [enemy1, enemy2, enemy3, enemy4]
        
        // Generate a random index
        let randomIndex = Int(arc4random_uniform(UInt32(enemyArray.count)))
        
        // Get a random enemy
        randomEnemy = enemyArray[randomIndex]

    }
    

    
    func fireBullet(scene: SKScene){
     
        
    }
}
