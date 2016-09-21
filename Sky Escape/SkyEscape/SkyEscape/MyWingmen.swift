//
//  MyWingmen.swift
//  SkyEscape
//
//  Created by Allen Boynton on 9/19/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import SpriteKit

class MyWingmen: SKSpriteNode {
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(imageNamed: String) {
        
        let imageTexture = SKTexture(imageNamed: imageNamed)
        super.init(texture: imageTexture, color: UIColor(), size: imageTexture.size())
        
        let body: SKPhysicsBody = SKPhysicsBody(rectangleOfSize: imageTexture.size())
        // Body physics for plane's bombs
        body.dynamic = false
        body.categoryBitMask = PhysicsCategory.PlayerMask
        body.contactTestBitMask = PhysicsCategory.SkyBombMask
        body.collisionBitMask = 0
        
        self.physicsBody = body
    }
        
}
