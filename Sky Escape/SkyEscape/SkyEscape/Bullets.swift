//
//  Bullets.swift
//  SkyEscape
//
//  Created by Allen Boynton on 9/3/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import SpriteKit


class Bullets: SKSpriteNode {
    
    init(imageName: String, bulletSound: String?) {
        
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        if(bulletSound != nil) {
            runAction(SKAction.playSoundFileNamed(bulletSound!, waitForCompletion: false))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
