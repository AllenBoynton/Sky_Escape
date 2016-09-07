//
//  Bombs.swift
//  SkyEscape
//
//  Created by Allen Boynton on 9/4/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import SpriteKit


class Bombs: SKSpriteNode {

    init(imageName: String, bombSound: String?) {
        
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        if(bombSound != nil) {
            runAction(SKAction.playSoundFileNamed(bombSound!, waitForCompletion: false))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
