//
//  GameScene.swift
//  MultiFight
//
//  Created by Norma Tu & Carlos Diez on 7/5/16.
//  Copyright (c) 2016 NormaTu. All rights reserved.
//

import SpriteKit

//1-50 range of easy
//1-100 range of medium
//50 - 150 range of hard
//More time rewarded for harder cards in stack
enum Difficulty {
    case Easy, Medium, Hard
}

class SingleScene: SKScene {
    var card : Card!
    var multipleOf : SKLabelNode!
    var cardStack: [Card] = []
    
    //Gives random number from 1 to 10
    let randomMultiple: Int = Int(arc4random_uniform(10) + 1)
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        card = self.childNodeWithName("card") as! Card
        multipleOf = self.childNodeWithName("multipleOf") as! SKLabelNode
        
        multipleOf.text = "Multiple of: \(randomMultiple)"
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {


        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
