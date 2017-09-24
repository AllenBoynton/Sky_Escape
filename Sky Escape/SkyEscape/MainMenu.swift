//
//  MainMenu.swift
//  SkyEscape
//
//  Created by Allen Boynton on 8/20/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    
    override func didMove(to view: SKView) {
        
        self.addChild(self.infoButtonNode())
        
//        self.run(SKAction.playSoundFileNamed("bgMusic", waitForCompletion: true))
    }
    
    // Info button to show credits
    func infoButtonNode() -> SKSpriteNode {
        
        let infoNode: SKSpriteNode = SKSpriteNode(imageNamed: "info")
        infoNode.position = CGPoint(x: self.frame.width - infoNode.size.width / 2, y: self.frame.height - infoNode.size.height / 2)
        infoNode.size = CGSize(width: 95, height: 95)
        infoNode.zPosition = 5
        infoNode.name = "infoButtonNode"
        
        return infoNode
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = (touch as! UITouch).location(in: self)
            
            let node = self.atPoint(location)
            
            if (node.name! == "infoButtonNode") {
                
                let info: CreditsScene = CreditsScene(fileNamed: "CreditsScene")!
                info.scaleMode = .aspectFit
                let transition: SKTransition = SKTransition.doorsOpenHorizontal(withDuration: 2.0)
                self.view?.presentScene(info, transition: transition)
            }
            else {
                
                let game: InstructionScene = InstructionScene(fileNamed: "InstructionScene")!
                game.scaleMode = .aspectFit
                let transition: SKTransition = SKTransition.doorsOpenHorizontal(withDuration: 3.0)
                self.view?.presentScene(game, transition: transition)
            }
        }
    }
}
