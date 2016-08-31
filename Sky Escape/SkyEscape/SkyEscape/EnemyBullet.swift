//
//  AirEnemy.swift
//  SkyEscape
//
//  Created by Allen Boynton on 8/30/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import SpriteKit

class InvaderBullet: Bullet {
    
    // Takes parameters from superclass Bullet
    override init(imageName: String, bulletSound:String?){
        
        super.init(imageName: imageName, bulletSound: bulletSound)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}
