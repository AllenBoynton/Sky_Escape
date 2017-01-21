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

let leaderboardID = "HIGH_SCORE"
let ach500KillsID = "50_Kills"
let achPowerUpID  = "Extra_Life"

/************************************ Game Center Methods *****************************************/
// MARK: - Game Center Methods

class GameViewController: UIViewController, GKGameCenterControllerDelegate, GameSceneDelegate {
    
    var scene = GameScene()
    
    /// The local player object.
    let gameCenterPlayer = GKLocalPlayer.localPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scene.gameCenterDelegate = self
        
        if let scene = MainMenu(fileNamed: "MainMenu") {
            
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFit
            
            skView.presentScene(scene)
        }
        
        authenticatePlayer()
//        scene.updateAchievements()
    }
    
    // Authenticates the user to access to the GC
    func authenticatePlayer() {
                
        gameCenterPlayer.authenticateHandler = {
            viewController, error in
            
            guard let vc = viewController else { return }
            
            self.present(vc, animated: true, completion: nil)
        }

        NotificationCenter.default.addObserver(
            self, selector: #selector(GameViewController.authenticationDidChange(_:)),
            name: NSNotification.Name(rawValue: GKPlayerAuthenticationDidChangeNotificationName),
            object: nil
        )
    }
    
    func notificationReceived() {
        print("GKPlayerAuthenticationDidChangeNotificationName - Authentication Status: \(gameCenterPlayer.isAuthenticated)")
    }
    
    func authenticationDidChange(_ notification: Notification) {
        reportScore(1530) // report example score after user logs in
    }
    
    // Reporting score
    func reportScore(_ score: Int64) {
        
        let gkScore = GKScore(leaderboardIdentifier: leaderboardID)
        gkScore.value = score
        
        GKScore.report([gkScore], withCompletionHandler: { error in
            guard error == nil  else { return }
            
            let vc = GKGameCenterViewController()
            vc.leaderboardIdentifier = leaderboardID
            vc.gameCenterDelegate = self
            vc.viewState = .leaderboards
            
            self.present(vc, animated: true, completion: nil)   }) 
    }
    
    // Continue the Game, if GameCenter Auth state has been changed
    func gameCenterStateChanged() {
        self.scene.gamePaused = false
    }
    
    // Retrieves the GC VC leaderboard
    func showLeaderboard() {
        
        let viewController = self.view.window?.rootViewController

        let gameCenterViewController = GKGameCenterViewController()
        
        gameCenterViewController.gameCenterDelegate = self
        
        gameCenterViewController.viewState = .leaderboards
        
        gameCenterViewController.viewState = .achievements
        
        gameCenterViewController.leaderboardIdentifier = leaderboardID
        
        // Show leaderboard
        viewController?.present(gameCenterViewController, animated: true, completion: nil)
    }
    
    // Continue the game after GameCenter is closed
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {

        gameCenterViewController.dismiss(animated: true, completion: nil)
        
        scene.gameOver = false
    }

    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        }
        else if UIDevice.current.userInterfaceIdiom == .pad {
            return .landscape
        }
        else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
