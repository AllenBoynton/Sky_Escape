//
//  PlayerBombs.swift
//  SkyEscape
//
//  Created by Allen Boynton on 9/4/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import SpriteKit

class PlayerBombs: Bombs {

    override init(imageName: String, bombSound: String?) {
        super.init(imageName: imageName, bombSound: bombSound)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func firePlayerBomb(scene: SKScene){
        
        let bombs = PlayerBombs(imageName: "bomb", bombSound: "bombaway")
        bombs.position.x = self.position.x - self.size.width / 2
        bombs.position.y = self.position.y
        scene.addChild(bombs)
        
        // Shoot em up!
        let action = SKAction.moveToY(-100, duration: 2.0)
        let actionDone = SKAction.removeFromParent()
        bombs.runAction(SKAction.sequence([action, actionDone]))
    }
}
