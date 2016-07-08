//
//  MultiScene.swift
//  MultiFight
//
//  Created by Norma Tu on 7/5/16.
//  Copyright © 2016 NormaTu. All rights reserved.
//

import SpriteKit
import GameplayKit

class MultiScene: SKScene, UIGestureRecognizerDelegate {
    var cardBaseP1 : Card!
    var cardBaseP2 : Card!
    
    var multipleLabelP1: SKLabelNode!
    var multipleLabelOutlineP1: SKLabelNode!
    var multipleLabelP2: SKLabelNode!
    var multipleLabelOutlineP2: SKLabelNode!
    
    var doneLabelP1: SKLabelNode!
    var doneLabelP2: SKLabelNode!
    var timerP1: SKSpriteNode!
    var timerP2: SKSpriteNode!
    var timerHolder1: SKSpriteNode!
    var timerHolder2: SKSpriteNode!
    var endScreen: SKSpriteNode!
    var winnerLabel: SKLabelNode!
    var scoreLabelP1: SKLabelNode!
    var scoreLabelP2: SKLabelNode!
    var playButton: MSButtonNode!
    var homeButton: MSButtonNode!
    var backgroundMusic: SKAudioNode!
    
    var timer: CGFloat = 1 {
        didSet {
            if timer < 0 {
                timer = 0
            }
            
            timerP1.xScale = timer
            timerP2.xScale = -timer
        }
    }
    
    var cardStackP1 : [Card] = []
    var cardStackP2 : [Card] = []

    var randomMultiple : Int!
    
    var scoreP1: Int = 0
    var scoreP2: Int = 0
    
    var gameState: GameState = .Ready
    
    var tapUpper: UITapGestureRecognizer!
    var tapLower: UITapGestureRecognizer!
    
    var swipeLeftUpper: UISwipeGestureRecognizer!
    var swipeRightUpper: UISwipeGestureRecognizer!
    
    var swipeLeftLower: UISwipeGestureRecognizer!
    var swipeRightLower: UISwipeGestureRecognizer!
    
    // Might work ...
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func didMoveToView(view: SKView) {
        let cardSize = CGSize(width: 140, height: 140)
        cardBaseP1 = Card(texture: SKTexture(imageNamed: "card"), color: UIColor.whiteColor(), size: cardSize)
        cardBaseP1.position.x = 160
        cardBaseP1.position.y = 120
        cardBaseP1.name = "BaseP1"
        
        cardBaseP2 = Card(texture: SKTexture(imageNamed: "card"), color: UIColor.whiteColor(), size: cardSize)
        cardBaseP2.position.x = 160
        cardBaseP2.position.y = 450
        cardBaseP2.xScale = -1
        cardBaseP2.yScale = -1
        cardBaseP2.name = "BaseP2"

        multipleLabelP1 = self.childNodeWithName("multipleLabelP1") as! SKLabelNode
        multipleLabelOutlineP1 = self.childNodeWithName("multipleLabelOutlineP1") as! SKLabelNode
        multipleLabelP2 = self.childNodeWithName("multipleLabelP2") as! SKLabelNode
        multipleLabelOutlineP2 = self.childNodeWithName("multipleLabelOutlineP2") as! SKLabelNode
        doneLabelP1 = self.childNodeWithName("doneLabelP1") as! SKLabelNode
        doneLabelP2 = self.childNodeWithName("doneLabelP2") as! SKLabelNode
        timerP1 = self.childNodeWithName("timerP1") as! SKSpriteNode
        timerP2 = self.childNodeWithName("timerP2") as! SKSpriteNode
        timerHolder1 = self.childNodeWithName("timerHolder1") as! SKSpriteNode
        timerHolder2 = self.childNodeWithName("timerHolder2") as! SKSpriteNode
        endScreen = self.childNodeWithName("endScreen") as! SKSpriteNode
        winnerLabel = self.childNodeWithName("//winnerLabel") as! SKLabelNode
        scoreLabelP1 = self.childNodeWithName("//scoreLabelP1") as! SKLabelNode
        scoreLabelP2 = self.childNodeWithName("//scoreLabelP2") as! SKLabelNode
        playButton = self.childNodeWithName("//playButton") as! MSButtonNode
        homeButton = self.childNodeWithName("//homeButton") as! MSButtonNode
        
        doneLabelP1.hidden = true
        doneLabelP2.hidden = true
        timerP1.hidden = true
        timerP2.hidden = true
        timerHolder1.hidden = true
        timerHolder2.hidden = true
        
        //Both players get a random starting multiple
        randomMultiple = Int(arc4random_uniform(8) + 2)
        
        multipleLabelP1.text = String(randomMultiple)
        multipleLabelOutlineP1.text = String(randomMultiple)
        multipleLabelP2.text = String(randomMultiple)
        multipleLabelOutlineP2.text = String(randomMultiple)
        
        cardStackP1 = setCardStack(cardBaseP1)
        cardStackP2 = generateSecondCardStack(cardBaseP2)
        
        if let musicURL = NSBundle.mainBundle().URLForResource("gameplay", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(URL: musicURL)
            addChild(backgroundMusic)
        }
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        swipeRightUpper = UISwipeGestureRecognizer(target: self, action: #selector(MultiScene.swipedRightUpper(_:)))
        swipeRightUpper.direction = .Right
        
        swipeLeftUpper = UISwipeGestureRecognizer(target: self, action: #selector(MultiScene.swipedLeftUpper(_:)))
        swipeLeftUpper.direction = .Left
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        swipeRightLower = UISwipeGestureRecognizer(target: self, action: #selector(MultiScene.swipedRightLower(_:)))
        swipeRightLower.direction = .Right
        
        swipeLeftLower = UISwipeGestureRecognizer(target: self, action: #selector(MultiScene.swipedLeftLower(_:)))
        swipeLeftLower.direction = .Left
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        
        tapUpper = UITapGestureRecognizer(target: self, action: #selector(MultiScene.onTapUpper(_:)))
        tapLower = UITapGestureRecognizer(target: self, action: #selector(MultiScene.onTapLower(_:)))
        
        
        GameViewController.topView.addGestureRecognizer(tapUpper)
        GameViewController.bottomView.addGestureRecognizer(tapLower)
        
        GameViewController.topView.addGestureRecognizer(swipeLeftUpper)
        GameViewController.bottomView.addGestureRecognizer(swipeLeftLower)
        
        GameViewController.topView.addGestureRecognizer(swipeRightUpper)
        GameViewController.bottomView.addGestureRecognizer(swipeRightLower)
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        playButton.selectedHandler = {
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
        
        homeButton.selectedHandler = {
            if let scene = MainMenu(fileNamed:"MainMenu") {
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
    
    //~~~~~~~~~~~~~~~~~~~~~~~TAP/SWIPE HANDLERS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    
    func onTapUpper(sender: UITapGestureRecognizer) {
        //Player 2 side
        removeCard("MoveUp", swipe: false, p1Action: false)
    }
    
    func onTapLower(sender: UITapGestureRecognizer) {
        //Player 1 side
        removeCard("MoveDown", swipe: false, p1Action: true)
    }
    
    
    func swipedRightUpper(sender:UISwipeGestureRecognizer){
        //Player 2 side
        removeCard("FlipRight", swipe: true, p1Action: false)
    }
    
    func swipedLeftUpper(sender:UISwipeGestureRecognizer){
        //Player 2 side
        removeCard("FlipLeft", swipe: true, p1Action: false)
    }
    
    func swipedRightLower(sender:UISwipeGestureRecognizer){
        //Player 1 side
        removeCard("FlipRight", swipe: true, p1Action: true)
    }
    
    func swipedLeftLower(sender:UISwipeGestureRecognizer){
        //Player 1 side
        removeCard("FlipLeft", swipe: true, p1Action: true)
    }
    
    //~~~~~~~~~~~~~~~~~~~~~~~TAP/SWIPE HANDLERS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    
    func moveCardStack(actionP1: Bool) {
        if actionP1 {
            for node:Card in cardStackP1 {
                node.runAction(SKAction.moveBy(CGVector(dx: -5, dy: 5), duration: 0.10))
                
                node.zPosition += 2
                node.cardNumber.zPosition = node.zPosition + 1
            }
        }
        else {
            for node:Card in cardStackP2 {
                node.runAction(SKAction.moveBy(CGVector(dx: 5, dy: -5), duration: 0.10))
                
                node.zPosition += 2
                node.cardNumber.zPosition = node.zPosition + 1
            }
        }
    }
    
    func removeCard(actionName: String, swipe: Bool, p1Action: Bool) {
        var firstCard: Card!
        if p1Action {
            firstCard = cardStackP1.first as Card!
            cardStackP1.removeFirst()
            if cardStackP1.isEmpty {
                endGame(true)
            }
        }
        else {
            firstCard = cardStackP2.first as Card!
            cardStackP2.removeFirst()
            if cardStackP2.isEmpty {
                endGame(false)
            }
        }
        
        checkCard(firstCard, swipe: swipe, p1Action: p1Action)
        firstCard?.zPosition += 2 //sets z position so that card swipes don't show next card too soon
        firstCard?.flip(actionName)
        
        moveCardStack(p1Action)
    }
    
    func checkCard(card: Card, swipe: Bool, p1Action: Bool) {
        //can see color tint
        card.colorBlendFactor = 1
        
        if swipe {
            //Gives point if you swipe a non-multiple
            if card.number % randomMultiple != 0 {
                if p1Action {
                    scoreP1 += 1
                }
                else {
                    scoreP2 += 1
                }
                card.color = UIColor.greenColor()
                playCorrectSound()
            }
            else {
                card.color = UIColor.redColor()
                playWrongSound()
            }
        }
        else {
            if card.number % randomMultiple == 0 {
                if p1Action {
                    scoreP1 += 1
                }
                else {
                    scoreP2 += 1
                }
                card.color = UIColor.greenColor()
                playCorrectSound()
            }
            else {
                card.color = UIColor.redColor()
                playWrongSound()
            }
        }
    }
    
    func addCardsToScene(cards: [Card], p1: Bool) {
        let firstCard = cards[0]
        
        addChild(firstCard)
        
        for index in 1..<cards.count {
            let lastCard = cards[index - 1]
            let newCard = cards[index]
            let lastPosition = lastCard.position
            let lastZPosition = lastCard.zPosition
            
            newCard.zPosition = lastZPosition - 2
            newCard.cardNumber.zPosition = newCard.zPosition + 1
            
            if p1 {
                newCard.position = lastPosition + CGPoint(x: 5, y: -5)
            }
            else {
                newCard.position = lastPosition + CGPoint(x: -5, y: 5)
            }
            
            addChild(newCard)
        }
        
    }
    
    //This function returns a full & shuffled 20 card stack array
    func setCardStack(cardBase: Card) -> [Card]{
        
        var cardStack: [Card] = []
        let wrongIntArray = fillWrongArray()
        let correctIntArray = fillCorrectArray()
        
        for index in 0...wrongIntArray.count-1 {
            
            //make a new card object (copying card base)
            let newCard = cardBase.copy() as! Card
            newCard.connectNumberMulti() //connects label to card
            
            //that card object.number = wrongIntArray[index]
            newCard.number = wrongIntArray[index]
            
            //append to cardStack array
            cardStack.append(newCard)
        }
        
        for index in 0...correctIntArray.count-1 {
            
            //make a new card object (copying card base)
            let newCard = cardBase.copy() as! Card
            newCard.connectNumberMulti() //connects label to card
            
            //that card object.number = Array[index]
            newCard.number = correctIntArray[index]
            
            //append to cardStack array
            cardStack.append(newCard)
        }
        
        cardBase.connectNumberMulti()
        cardBase.number = 1
        cardStack.append(cardBase)
        
        //shuffles the 20 member card stack array of 10 multiples + 10 non-multiples
        let shuffledStack = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(cardStack) as! [Card]
        addCardsToScene(shuffledStack, p1: true)
        
        return shuffledStack
    }
    
    func generateSecondCardStack(cardBase: Card) -> [Card] {
        var newCardStack: [Card] = []
        
        for card: Card in cardStackP1 {
            if !(card.number == 1) {
                let newCard = cardBase.copy() as! Card
                newCard.connectNumberMulti()
                
                newCard.number = card.number
                
                newCardStack.append(newCard)
            }
        }
        
        cardBase.removeFromParent()
        cardBase.connectNumberMulti()
        cardBase.number = 1
        newCardStack.append(cardBase)
        
        let shuffledStack = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(newCardStack) as! [Card]
        
        addCardsToScene(shuffledStack, p1: false)

        return shuffledStack
    }
    
    func fillWrongArray() -> [Int] {
        var wrongArray : [Int] = []
        
        while wrongArray.count < 9 {
            var randomNumber: Int!
            let topNumber = UInt32(randomMultiple * 10)
            randomNumber = Int(arc4random_uniform(topNumber - 1) + 1)
            
            if randomNumber % randomMultiple != 0 {
                wrongArray.append(randomNumber)
            }
        }
        
        return wrongArray
    }
    
    func fillCorrectArray() -> [Int] {
        var correctArray : [Int] = []
        
        var currentMultiple: Int = randomMultiple
        
        for _ in 0...9 {
            correctArray.append(currentMultiple)
            currentMultiple += randomMultiple
        }
        
        return correctArray
    }
    
    func endGame(p1Finished: Bool) {
        // player 1 done first
        if p1Finished {
            doneLabelP1.hidden = false
            removeP1Functionality()
            
            // player 2 not done yet
            if !cardStackP2.isEmpty {
                //Start timer for p2
                gameState = .PlayerFinished
                timerP2.hidden = false
                timerHolder2.hidden = false
            }
                // player 2 done at the same time as player 1
            else {
                gameOver()
            }
        }
            // player 2 finished first
        else {
            doneLabelP2.hidden = false
            removeP2Functionality()
            
            // player 1 not done yet
            if !cardStackP1.isEmpty {
                //Start timer for p1
                gameState = .PlayerFinished
                timerP1.hidden = false
                timerHolder1.hidden = false
            }
                // player 1 done at same time as player 2
            else {
                gameOver()
            }
        }
    }
    
    func gameOver() {
        gameState = .GameOver
        removeP1Functionality()
        removeP2Functionality()
        
        let showEndScreen = SKAction(named: "dropScreen")!
        endScreen.runAction(showEndScreen)
        
        if scoreP1 > scoreP2 {
            winnerLabel.text = "Blue Wins!"
        }
        else if scoreP1 < scoreP2 {
            winnerLabel.text = "Green Wins!"
        }
        else {
            winnerLabel.text = "Tie!"
        }
        
        scoreLabelP1.text = "Blue's Score: \(scoreP1)"
        scoreLabelP2.text = "Green's Score: \(scoreP2)"
    }
    
    func removeP1Functionality() {
        GameViewController.bottomView.removeGestureRecognizer(tapLower)
        GameViewController.bottomView.removeGestureRecognizer(swipeLeftLower)
        GameViewController.bottomView.removeGestureRecognizer(swipeRightLower)
    }
    
    func removeP2Functionality() {
        GameViewController.topView.removeGestureRecognizer(tapUpper)
        GameViewController.topView.removeGestureRecognizer(swipeLeftUpper)
        GameViewController.topView.removeGestureRecognizer(swipeRightUpper)
    }
    
    override func update(currentTime: NSTimeInterval) {
        if gameState == .PlayerFinished {
            timer -= 0.01
        }
        
        if timer <= 0 {
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