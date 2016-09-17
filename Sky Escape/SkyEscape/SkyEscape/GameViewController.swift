//
//  GameViewController.swift
//  SkyEscape
//
//  Created by Allen Boynton on 8/3/16.
//  Copyright (c) 2016 Full Sail. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class GameViewController: UIViewController, GKGameCenterControllerDelegate, GameSceneDelegate {
    
    var scene = GameScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticatePlayer()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Detect the screensize
        let sizeRect = UIScreen.mainScreen().bounds
        let width = sizeRect.size.width * UIScreen.mainScreen().scale
        let height = sizeRect.size.height * UIScreen.mainScreen().scale
        
        // Create a fullscreen Scene object
        scene = GameScene(size: CGSizeMake(width, height))
        
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFit
        
        skView.presentScene(scene)
        
        scene.gameCenterDelegate = self
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .Landscape
        } else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return .Landscape
        } else {
            return .All
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // Authenticates the user to access to the GC
    func authenticatePlayer() {
        
        // Check if user is already authenticated in game center
        if GKLocalPlayer.localPlayer().authenticated == false {
            
            // Show the Login Prompt for Game Center
            GKLocalPlayer.localPlayer().authenticateHandler = {(viewController, error) -> Void in
                if viewController != nil {
                    self.scene.gamePaused = true
                    self.presentViewController(viewController!, animated: true, completion: nil)
                    
                    // Add an observer which calls 'gameCenterStateChanged' to handle a changed game center state
                    let notificationCenter = NSNotificationCenter.defaultCenter()
                    notificationCenter.addObserver(self, selector:#selector(GameCenter.gameCenterStateChanged), name: "GKPlayerAuthenticationDidChangeNotificationName", object: nil)
                }
            }
        }
        
//        let localPlayer = GKLocalPlayer.localPlayer()
//        
//        localPlayer.authenticateHandler = {
//            (view, error) in
//
//            if view != nil {
//
//                self.presentViewController(view!, animated: true, completion: nil)
//            }
//            else {
//                print(GKLocalPlayer.localPlayer().authenticated)
//            }
//        }
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

// Checks font names available for code use
//        print("\(checkPhysics())")
