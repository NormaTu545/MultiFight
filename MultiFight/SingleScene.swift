//
//  GameScene.swift
//  MultiFight
//
//  Created by Norma Tu & Carlos Diez on 7/5/16.
//  Copyright (c) 2016 NormaTu & CarlosDiez. All rights reserved.
//  User must keep finding multiples of the designated multiple
//  until time runs out or they mess up.  Card stack is endless, 
//  and continuously generates.

import SpriteKit

//1-50 range of easy
//1-100 range of medium
//50 - 150 range of hard
//More time rewarded for harder cards in stack
enum Difficulty {
    case Easy, Medium, Hard
}

enum GameState {
    case Ready, Playing, GameOver
}

class SingleScene: SKScene {
    var cardBase : Card!
    var multipleOf : SKLabelNode!
    var cardStack: [Card] = []
    var scoreLabel: SKLabelNode!
    var gameState: GameState = .Ready
    var currentDifficulty: Difficulty = .Easy
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    //Gives random number from 1 to 10
    let randomMultiple: Int = Int(arc4random_uniform(10) + 1)
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        cardBase = self.childNodeWithName("cardBase") as! Card
        multipleOf = self.childNodeWithName("multipleOf") as! SKLabelNode
        scoreLabel = self.childNodeWithName("scoreLabel") as! SKLabelNode
        
        multipleOf.text = "Multiple of: \(randomMultiple)"
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SingleScene.swipedRight(_:)))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SingleScene.swipedLeft(_:)))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SingleScene.onTap(_:)))
        view.addGestureRecognizer(tap)
        
        cardStack.append(cardBase)
        addRandomCards(2)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
    /*for touch in touches {

        }*/
    }
    
    func onTap(sender: UITapGestureRecognizer) {
        removeCard("MoveDown", swipe: false)
    }
    
    func swipedRight(sender:UISwipeGestureRecognizer){
        removeCard("FlipRight", swipe: true)
    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer){
        removeCard("FlipLeft", swipe: true)
    }
    
    func removeCard(actionName: String, swipe: Bool) {
        let firstCard = cardStack.first as Card!
        checkCard(firstCard, swipe: swipe)
        firstCard?.flip(actionName)
        
        cardStack.removeFirst()
        addRandomCards(1)
        moveCardStack()
    }
    
    func checkCard(card: Card, swipe: Bool) {
        if swipe {
            //Gives point if you swipe a non-multiple
            if card.number % randomMultiple != 0 {
                score += 1
                //add time
            }
            //removes time if you swipe a multiple
            else {
                //decrease time
            }
        }
        else {
            //gives point if you tap a multiple
            if card.number % randomMultiple == 0 {
                score += 1
                //add time
            }
            //removes time if you tap a non-multiple
            else {
                //decrease time
            }
        }
        
    }
    
    func addCard(number: Int) {
        let lastCard = cardStack.last

        let newCard = lastCard?.copy() as! Card
        
        newCard.connectNumber() //connects label
        
        let lastCardPosition = lastCard?.position ?? cardBase.position
        
        newCard.position = lastCardPosition + CGPoint(x: 15, y: -15) //Placing card behind
        
        let lastZposition = lastCard?.zPosition ?? cardBase.zPosition
        newCard.zPosition = lastZposition - 1
        
        newCard.number = number
        
        addChild(newCard) //attaches the node to the scene
        
        cardStack.append(newCard)
        
    }
    
    func addRandomCards(total: Int) {
        for _ in 1...total {
            switch currentDifficulty {
            case .Easy:
                let randomInt = Int(arc4random_uniform(19) + 1)
                addCard(randomInt)
                break
            case .Medium:
                let randomInt = Int(arc4random_uniform(49) + 1)
                addCard(randomInt)
                break
            case .Hard:
                let randomInt = Int(arc4random_uniform(99) + 1)
                addCard(randomInt)
                break
            }
        }
    }
    
    func moveCardStack() {
        for node:Card in cardStack {
            node.runAction(SKAction.moveBy(CGVector(dx: -15, dy: 15), duration: 0.10))
            
            node.zPosition += 1
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
