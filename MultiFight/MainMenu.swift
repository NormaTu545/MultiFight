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

class MainMenu: SKScene {
    
    var button1 : MSButtonNode!
    var button2 : MSButtonNode!
    
    override func didMoveToView(view: SKView) {
        button1 = self.childNodeWithName("button1") as! MSButtonNode
        button2 = self.childNodeWithName("button2") as! MSButtonNode
        
        button1.selectedHandler =  {
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
        
        button2.selectedHandler = {
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