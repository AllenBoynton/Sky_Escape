//
//  GameCenter.swift
//  SkyEscape
//
//  Created by Allen Boynton on 9/15/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import UIKit
import GameKit

class GameCenter: UIViewController, GKGameCenterControllerDelegate {
    
    var scene = GameScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a fullscreen Scene object
        scene = GameScene(size: CGSizeMake(scene.frame.width, scene.frame.height))
        scene.scaleMode = .AspectFit

        authenticatePlayer()
    }
    
    // Authenticates the user to access to the GC
    func authenticatePlayer() {
        
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {
            (view, error) in
            
            if view != nil {
                
                self.presentViewController(view!, animated: true, completion: nil)
            }
            else {
                print(GKLocalPlayer.localPlayer().authenticated)
            }
        }
    }
    
    // Continue the Game, if GameCenter Auth state has been changed
    func gameCenterStateChanged() {
        
        self.scene.gamePaused = false
    }
    
    // Retrieves the GC VC leaderboard
    func showLeaderBoard() {
        
        let gameCenterViewController = GKGameCenterViewController()
        
        gameCenterViewController.gameCenterDelegate = self
        
        gameCenterViewController.viewState = GKGameCenterViewControllerState.Leaderboards
        
        gameCenterViewController.leaderboardIdentifier = "HIGH_SCORE"
        
        // Show leaderboard
        self.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    
    // Continue the game after GameCenter is closed
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
        scene.gameOver = false
        
    }
}
