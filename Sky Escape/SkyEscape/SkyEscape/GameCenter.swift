////
////  GameCenter.swift
////  SkyEscape
////
////  Created by Allen Boynton on 9/24/16.
////  Copyright © 2016 Full Sail. All rights reserved.
////
//
//import UIKit
//import SpriteKit
//import GameKit
//
//let leaderboardID = "HIGH_SCORE"
//let ach500KillsID = "50_Kills"
//let achPowerUpID  = "Extra_Life"
//
///************************************ Game Center Methods *****************************************/
//// MARK: - Game Center Methods
//
//class GameCenter: UIViewController, GKGameCenterControllerDelegate, GameSceneDelegate {
//    
//    var scene = GameScene()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        scene.gameCenterDelegate = self
//        
//        authenticatePlayer()
//        scene.updateAchievements()
//    }
//
//    // Authenticates the user to access to the GC
//    func authenticatePlayer() {
//        
//        NSNotificationCenter.defaultCenter().addObserver(
//            
//            self, selector: #selector(GameCenter.authenticationDidChange(_:)),
//            name: GKPlayerAuthenticationDidChangeNotificationName,
//            object: nil
//        )
//        
//        GKLocalPlayer.localPlayer().authenticateHandler = {
//            viewController, error in
//            
//            guard let vc = viewController else { return }
//            
//            self.presentViewController(vc, animated: true, completion: nil)
//        }
//    }
//    
//    func authenticationDidChange(notification: NSNotification) {
//        reportScore(1530) // report example score after user logs in
//    }
//    
//    // Reporting score
//    func reportScore(score: Int64) {
//        
//        let gkScore = GKScore(leaderboardIdentifier: leaderboardID)
//        gkScore.value = score
//        
//        GKScore.reportScores([gkScore]) { error in
//            guard error == nil  else { return }
//            
//            let alController = GKGameCenterViewController()
//            alController.leaderboardIdentifier = leaderboardID
//            alController.gameCenterDelegate = self
//            alController.viewState = .Leaderboards
//            
//            self.presentViewController(alController, animated: true, completion: nil)   }
//    }
//    
//    // Continue the Game, if GameCenter Auth state has been changed
//    func gameCenterStateChanged() {
//        
//        self.scene.gamePaused = false
//    }
//    
//    // Retrieves the GC VC leaderboard
//    func showLeaderboard() {
//        
//        let viewController = self.view.window?.rootViewController
//        
//        let gameCenterViewController = GKGameCenterViewController()
//        
//        gameCenterViewController.gameCenterDelegate = self
//        
//        gameCenterViewController.viewState = .Leaderboards
//        
//        gameCenterViewController.viewState = .Achievements
//        
//        gameCenterViewController.leaderboardIdentifier = leaderboardID
//        
//        // Show leaderboard
//        viewController?.presentViewController(gameCenterViewController, animated: true, completion: nil)
//    }
//    
//    // Continue the game after GameCenter is closed
//    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
//        
//        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
//        
//        scene.gameOver = false
//    }
//}
