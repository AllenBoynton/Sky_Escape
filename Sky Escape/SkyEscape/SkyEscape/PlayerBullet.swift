//
//  PlayerBullet.swift
//  SkyEscape
//
//  Created by Allen Boynton on 9/3/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import SpriteKit

class PlayerBullet: Bullets {
    
    override init(imageName: String, bulletSound:String?) {
        super.init(imageName: imageName, bulletSound: bulletSound)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func firePlayerBullet(scene: SKScene) {
        
        let bullet = PlayerBullet(imageName: "fireBullet", bulletSound: "gunfire")
        bullet.position.x = self.position.x - self.size.width / 2
        bullet.position.y = self.position.y
        scene.addChild(bullet)
        
        // Shoot em up!
        let action = SKAction.moveToY(size.width + bullet.size.width, duration: 1.5)
        let actionDone = SKAction.removeFromParent()
        bullet.runAction(SKAction.sequence([action, actionDone]))
    }
}
