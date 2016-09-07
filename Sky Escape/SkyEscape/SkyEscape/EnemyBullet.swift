//
//  EnemyBullet.swift
//  SkyEscape
//
//  Created by Allen Boynton on 9/3/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import SpriteKit

class EnemyBullet: Bullets {
    
    override init(imageName: String, bulletSound: String?) {
        super.init(imageName: imageName, bulletSound: bulletSound)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fireEnemyBullets(scene: SKScene){
        let bullet = EnemyBullet(imageName: "bullet", bulletSound: "mp5Gun")
        bullet.position.x = self.position.x - self.size.width / 2
        bullet.position.y = self.position.y
        scene.addChild(bullet)
        
        // Shoot em up!
        let action = SKAction.moveTo(CGPoint(x:self.position.x,y: 0 - bullet.size.height), duration: 2.0)
        let actionDone = SKAction.removeFromParent()
        bullet.runAction(SKAction.sequence([action, actionDone]))
    }
}
