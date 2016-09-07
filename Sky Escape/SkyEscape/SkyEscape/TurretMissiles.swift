//
//  TurretMissiles.swift
//  SkyEscape
//
//  Created by Allen Boynton on 9/4/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import SpriteKit

class TurretMissiles: Missiles {

    override init(imageName: String, missileSound: String?) {
        super.init(imageName: imageName, missileSound: missileSound)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fireTurretMissiles(scene: SKScene) {
        
        let missiles = TurretMissiles(imageName: "turretMissile", missileSound: "rocket")
        missiles.position.x = self.position.x - self.size.width / 2
        missiles.position.y = self.position.y
        scene.addChild(missiles)
        
        // Shoot em up!
        let action = SKAction.moveToY(self.size.height + 80, duration: 2.0)
        let actionDone = SKAction.removeFromParent()
        missiles.runAction(SKAction.sequence([action, actionDone]))
    }
}
