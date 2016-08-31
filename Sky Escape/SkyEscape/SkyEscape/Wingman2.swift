//
//  Wingman2.swift
//  SkyEscape
//
//  Created by Allen Boynton on 8/30/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import SpriteKit


class Wingman2: Wingmen {
    
    // Takes parameters from superclass Bullet
    override init(imageName: String, planeSound bulletSound:String?){
        
        super.init(imageName: imageName, planeSound: bulletSound)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

