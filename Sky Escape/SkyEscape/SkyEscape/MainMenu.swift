//
//  MainMenu.swift
//  SkyEscape
//
//  Created by Allen Boynton on 8/20/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import SpriteKit
import AVFoundation


class MainMenu: SKScene {
    
    override func didMoveToView(view: SKView) {
        
        bgMusic = SKAudioNode(fileNamed: "bgMusic")
        bgMusic.runAction(SKAction.play())
        bgMusic.autoplayLooped = true
        
        bgMusic.removeFromParent()
        self.addChild(bgMusic)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let game: GameScene = GameScene(fileNamed: "GameScene")!
        game.scaleMode = .AspectFit
        let transition: SKTransition = SKTransition.doorsOpenHorizontalWithDuration(3.0)
        self.view?.presentScene(game, transition: transition)        
    }
}
