//
//  CreditsScene.swift
//  SkyEscape
//
//  Created by Allen Boynton on 9/13/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import SpriteKit

class CreditsScene: SKScene {

    override func didMoveToView(view: SKView) {
        
        //init
        self.runAction(SKAction.playSoundFileNamed("bGCannons", waitForCompletion: false))        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Brings user back to main menu
        let game: MainMenu = MainMenu(fileNamed: "MainMenu")!
        game.scaleMode = .AspectFit
        let transition: SKTransition = SKTransition.doorsOpenVerticalWithDuration(3.0)
        self.view?.presentScene(game, transition: transition)
    }
}
