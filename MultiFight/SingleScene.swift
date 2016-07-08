//  GameScene.swift
//  MultiFight
//
//  Created by Norma Tu & Carlos Diez on 7/5/16.
//  Copyright (c) 2016 NormaTu & CarlosDiez. All rights reserved.
//  User must keep finding multiples of the designated multiple
//  until time runs out or they mess up.  Card stack is endless, 
//  and continuously generates.

import SpriteKit

//1 - 20 range of easy
//1 - 50 range of medium
//1 - 100 range of hard
//More time rewarded for harder cards in stack
enum Difficulty {
    case Easy, Medium, Hard
}

class SingleScene: SKScene {
    var cardBase : Card!
    var multipleOf : SKLabelNode!
    var cardStack: [Card] = []
    var scoreLabel: SKLabelNode!
    var gameState: GameState = .Ready
    var currentDifficulty: Difficulty = .Easy
    var healthBar: SKSpriteNode!
    var endScreen: SKSpriteNode!
    var highScoreLabel: SKLabelNode!
    var endScoreLabel: SKLabelNode!
    var playButton: MSButtonNode!
    var homeButton: MSButtonNode!
    
    var tap: UITapGestureRecognizer!
    var swipeLeft: UISwipeGestureRecognizer!
    var swipeRight: UISwipeGestureRecognizer!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var health: CGFloat = 1.0 {
        didSet {
            if health > 1.0 {
                health = 1.0
            }
            
            if health < 0 {
                health = 0
            }
            
            healthBar.xScale = health
        }
    }
    
    //Gives random number from 2 to 10
    let randomMultiple: Int = Int(arc4random_uniform(8) + 2)
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        cardBase = self.childNodeWithName("cardBase") as! Card
        multipleOf = self.childNodeWithName("multipleOf") as! SKLabelNode
        scoreLabel = self.childNodeWithName("scoreLabel") as! SKLabelNode
        healthBar = self.childNodeWithName("healthBar") as! SKSpriteNode
        endScreen = self.childNodeWithName("endScreen") as! SKSpriteNode
        highScoreLabel = self.childNodeWithName("//highScoreLabel") as! SKLabelNode
        endScoreLabel = self.childNodeWithName("//endScoreLabel") as! SKLabelNode
        playButton = self.childNodeWithName("//playButton") as! MSButtonNode
        homeButton = self.childNodeWithName("//homeButton") as! MSButtonNode

        multipleOf.text = "Multiple of: \(randomMultiple)"
        
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(SingleScene.swipedRight(_:)))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
        
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(SingleScene.swipedLeft(_:)))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(SingleScene.onTap(_:)))
        view.addGestureRecognizer(tap)
        
        cardBase.connectNumber()
        cardBase.number = Int(arc4random_uniform(9) + 1)//starting card is randomized
        
        cardStack.append(cardBase)
        addRandomCards(2)
        
        playButton.selectedHandler = {
            
            //Resets the game
            let skView = self.view as SKView!
            let scene = SingleScene(fileNamed: "SingleScene") as SingleScene!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
        
        homeButton.selectedHandler = {
            
            //Resets the game
            let skView = self.view as SKView!
            let scene = MainMenu(fileNamed: "MainMenu") as MainMenu!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        gameState = .Playing
    }
    
    func onTap(sender: UITapGestureRecognizer) {
        if gameState == .GameOver {
            return
        }
        removeCard("MoveDown", swipe: false)
    }
    
    func swipedRight(sender:UISwipeGestureRecognizer){
        if gameState == .GameOver {
            return
        }
        removeCard("FlipRight", swipe: true)
    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer){
        if gameState == .GameOver {
            return
        }
        removeCard("FlipLeft", swipe: true)
    }
    
    func removeCard(actionName: String, swipe: Bool) {
        let firstCard = cardStack.first as Card!
        checkCard(firstCard, swipe: swipe)
        firstCard?.zPosition += 2
        firstCard?.cardNumber.zPosition = (firstCard?.zPosition)! + 1
        firstCard?.flip(actionName)
        
        cardStack.removeFirst()
        addRandomCards(1)
        moveCardStack()
    }
    
    func checkCard(card: Card, swipe: Bool) {
        //can see color tint
        card.colorBlendFactor = 1
        
        if swipe {
            //Gives point if you swipe a non-multiple
            if card.number % randomMultiple != 0 {
                score += 1
                //add time
                health += 0.0025
                card.color = UIColor.greenColor()
                
                //CORRECT DING SOUND EFFECT HERE
                playCorrectSound()
            }
            //removes time if you swipe a multiple
            else {
                //decrease time
                health -= 0.1
                card.color = UIColor.redColor()
                
                //Wrong sound
                playWrongSound()
            }
        }
        else {
            //gives point if you tap a multiple
            if card.number % randomMultiple == 0 {
                score += 1
                //add time
                health += 0.1
                card.color = UIColor.greenColor()
                
                playCorrectSound()
            }
            //removes time if you tap a non-multiple
            else {
                //decrease time
                health -= 0.1
                card.color = UIColor.redColor()
                
                playWrongSound()
            }
        }
        checkScore()
    }
    
    func checkScore() {
        if score >= 15 && score <= 29 {
            currentDifficulty = .Medium
        }
        else if score >= 30 {
            currentDifficulty = .Hard
        }
    }
    
    func addCard(number: Int) {
        let lastCard = cardStack.last

        let newCard = lastCard?.copy() as! Card
        
        newCard.connectNumber() //connects label
        
        let lastCardPosition = lastCard?.position ?? cardBase.position
        
        newCard.position = lastCardPosition + CGPoint(x: 15, y: -15) //Placing card behind
        
        let lastZposition = lastCard?.zPosition ?? cardBase.zPosition
        newCard.zPosition = lastZposition - 2
        newCard.cardNumber.zPosition = newCard.zPosition + 1
        
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
            
            node.zPosition += 2
            node.cardNumber.zPosition = node.zPosition + 1
        }
    }
    
    func gameOver() {
        gameState = .GameOver
        
        let showEndScreen = SKAction(named: "dropScreen")!
        endScreen.runAction(showEndScreen)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var highscore = userDefaults.integerForKey("highscore")
        
        if score > highscore {
            userDefaults.setValue(score, forKey: "highscore")
            userDefaults.synchronize()
        }
        
        highscore = userDefaults.integerForKey("highscore")
        
        highScoreLabel.text = "High score: \(highscore)"
        endScoreLabel.text = "Score: \(score)"
        
        view?.removeGestureRecognizer(swipeLeft)
        view?.removeGestureRecognizer(swipeRight)
        view?.removeGestureRecognizer(tap)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if gameState != .Playing {
            return
        }
        
        //Naturally decreases time
        health -= 0.001
        
        if health <= 0 {
            //end game
            gameOver()
        }
    }
    
    func playCorrectSound () {
        let dingSFX = SKAction.playSoundFileNamed("ding", waitForCompletion: false)
        
        self.runAction(dingSFX)
    }
    
    func playWrongSound () {
        let wrongSFX = SKAction.playSoundFileNamed("wrong", waitForCompletion: false)
        
        self.runAction(wrongSFX)
    }
    
    
}
