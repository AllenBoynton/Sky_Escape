//
//  GameViewController.swift
//  SkyEscape
//
//  Created by Allen Boynton on 8/3/16.
//  Copyright (c) 2016 Full Sail. All rights reserved.
//

import UIKit
import SpriteKit
//import Shephertz_App42_iOS_API

class GameViewController: UIViewController {
    
//    var userName = "ABtech"
//    var pwd = "Acb8645673022"
//    var emailId = "alboynton4@gmail.com"
//    var userService = App42API.buildUserService()
//    var createUser = userService()
//    var password = userName()
//    var emailAddress = pwd()
//    var completionBlock = emailId()
//    var responseObj = BOOL success id()
//    var App42Exception = BOOL success id()
//    exception
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if success {
//            var user = (responseObj as! User)
//            print("userName is \(user.userName)")
//            print("emailId is \(user.email)")
//            print("SessionId is \(user.sessionId)")
//            var jsonResponse = user.toString()
//        }
//        
//        do {
//            print("Exception is \(exception.reason!)")
//            print("HTTP error Code is \(exception.httpErrorCode())")
//            print("App Error Code is \(exception.appErrorCode())")
//            print("User Info is \(exception.userInfo!)")
//        }
        
        if let scene = MainMenu(fileNamed: "MainMenu") {
            
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
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
}
