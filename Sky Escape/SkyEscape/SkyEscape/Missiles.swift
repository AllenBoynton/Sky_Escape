//
//  Missiles.swift
//  SkyEscape
//
//  Created by Allen Boynton on 9/4/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import SpriteKit


class Missiles: SKSpriteNode {

    init(imageName: String, missileSound: String?) {
        
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        if(missileSound != nil) {
            
            runAction(SKAction.playSoundFileNamed(missileSound!, waitForCompletion: false))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
