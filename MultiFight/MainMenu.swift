//
//  MainMenu.swift
//  MultiFight
//
//  Created by Norma Tu on 7/5/16.
//  Copyright © 2016 NormaTu. All rights reserved.
//

import Foundation
import SpriteKit

enum GameState {
    case Ready, Playing, GameOver, PlayerFinished
}

enum Mode {
    case None, Single, Multi
}

class MainMenu: SKScene {
    
    var button1 : MSButtonNode!
    var button2 : MSButtonNode!
    var tutorialScreen: SKSpriteNode!
    
    var mode: Mode = .None
    
    var backgroundMusic: SKAudioNode!
    
    override func didMoveToView(view: SKView) {
        button1 = self.childNodeWithName("button1") as! MSButtonNode
        button2 = self.childNodeWithName("button2") as! MSButtonNode
        tutorialScreen = self.childNodeWithName("tutorialScreen") as! SKSpriteNode
        
        if let musicURL = NSBundle.mainBundle().URLForResource("mainMenu", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(URL: musicURL)
            addChild(backgroundMusic)
        }
        
        button1.selectedHandler =  {
            self.mode = .Single
            
            let dropScreen = SKAction(named: "dropScreen")!
            self.tutorialScreen.runAction(dropScreen)
        }
        
        button2.selectedHandler = {
            self.mode = .Multi
            
            let dropScreen = SKAction(named: "dropScreen")!
            self.tutorialScreen.runAction(dropScreen)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if mode == .None {
            return
        }
        else if mode == .Single {
            if let scene = SingleScene(fileNamed:"SingleScene") {
                // Configure the view.
                let skView = self.view!
                skView.showsFPS = true
                skView.showsNodeCount = true
                
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .AspectFill
                
                skView.presentScene(scene)
            }
        }
        else {
            if let scene = MultiScene(fileNamed:"MultiScene") {
                // Configure the view.
                let skView = self.view!
                skView.showsFPS = true
                skView.showsNodeCount = true
                
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .AspectFill
                
                skView.presentScene(scene)
            }
        }
    }
    
}