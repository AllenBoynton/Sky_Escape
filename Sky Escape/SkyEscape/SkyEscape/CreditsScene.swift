//
//  CreditsScene.swift
//  SkyEscape
//
//  Created by Allen Boynton on 9/13/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import SpriteKit

class CreditsScene: SKScene {

    override func didMove(to view: SKView) {
        
        //init
        self.run(SKAction.playSoundFileNamed("bGCannons", waitForCompletion: false))        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Brings user back to main menu
        let game: MainMenu = MainMenu(fileNamed: "MainMenu")!
        game.scaleMode = .aspectFit
        let transition: SKTransition = SKTransition.doorsOpenVertical(withDuration: 3.0)
        self.view?.presentScene(game, transition: transition)
    }
}
