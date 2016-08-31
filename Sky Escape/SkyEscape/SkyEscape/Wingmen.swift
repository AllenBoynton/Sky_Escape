//
//  Wingmen.swift
//  SkyEscape
//
//  Created by Allen Boynton on 8/30/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import SpriteKit


class Wingmen: SKSpriteNode {
    
    
    init(imageName: String, planeSound: String?) {
        
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        if(planeSound != nil){
            
            runAction(SKAction.playSoundFileNamed(planeSound!, waitForCompletion: false))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
