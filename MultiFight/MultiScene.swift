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
    var multipleOfP1 : SKLabelNode!
    var multipleOfP2 : SKLabelNode!
    var cardStackP1 : [Card] = []
    var cardStackP2 : [Card] = []
    
    var correctArray : [Card] = []
    
    var randomMultipleP1 : Int!
    var randomMultipleP2 : Int!
    
    var gameState: GameState = .Ready
    
    var tapUpper: UITapGestureRecognizer!
    var tapLower: UITapGestureRecognizer!
    var swipeLeft: UISwipeGestureRecognizer!
    var swipeRight: UISwipeGestureRecognizer!
    
    // Might work ...
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func didMoveToView(view: SKView) {
        //cardBaseP1 = self.childNodeWithName("cardBaseP1") as! Card
        //cardBaseP2 = self.childNodeWithName("cardBaseP2") as! Card
        let cardSize = CGSize(width: 140, height: 140)
        cardBaseP1 = Card()
        cardBaseP1.position.x = 160
        cardBaseP1.position.y = 120
        cardBaseP1.size = cardSize
        cardBaseP1.color = UIColor.whiteColor()

        
        cardBaseP2 = Card()
        cardBaseP2.position.x = 160
        cardBaseP2.position.y = 450
        cardBaseP2.size = cardSize
        cardBaseP2.xScale = -1
        cardBaseP2.yScale = -1
        cardBaseP2.color = UIColor.whiteColor()

        
        multipleOfP1 = self.childNodeWithName("multipleOfP1") as! SKLabelNode
        multipleOfP2 = self.childNodeWithName("multipleOfP2") as! SKLabelNode
        
        //Both players get a random starting multiple each
        randomMultipleP1 = Int(arc4random_uniform(8) + 2)
        randomMultipleP2 = Int(arc4random_uniform(8) + 2)
        
        multipleOfP1.text = "Multiple of: \(randomMultipleP1)"
        multipleOfP2.text = "Multiple of: \(randomMultipleP2)"
        
        cardStackP1 = setCardStack(true, cardBase: cardBaseP1)
        cardStackP2 = setCardStack(false, cardBase: cardBaseP2)
        
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(SingleScene.swipedRight(_:)))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
        
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(SingleScene.swipedLeft(_:)))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
        
        tapUpper = UITapGestureRecognizer(target: self, action: #selector(MultiScene.onTapUpper(_:)))
        //view.addGestureRecognizer(tap)
        //tap.delegate = self
        tapLower = UITapGestureRecognizer(target: self, action: #selector(MultiScene.onTapLower(_:)))

        
        GameViewController.topView.addGestureRecognizer(tapUpper)
        GameViewController.bottomView.addGestureRecognizer(tapLower)
        
    }
    
    func onTapUpper(sender: UITapGestureRecognizer) {
        //Player 2 side
        removeCard("MoveUp", swipe: false, p1Action: false)
    }
    
    func onTapLower(sender: UITapGestureRecognizer) {
        //Player 1 side
        removeCard("MoveDown", swipe: false, p1Action: true)
    }

    
    func swipedRight(sender:UISwipeGestureRecognizer){

    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer){

    }
    
    func removeCard(actionName: String, swipe: Bool, p1Action: Bool) {
        var firstCard: Card!
        if p1Action {
            firstCard = cardStackP1.first as Card!
            cardStackP1.removeFirst()
        }
        else {
            firstCard = cardStackP2.first as Card!
            cardStackP2.removeFirst()
        }
        //checkCard(firstCard, swipe: swipe)
        firstCard?.flip(actionName)
        
        //moveCardStack()
    }
    
    func addCardsToScene(cards: [Card], p1: Bool) {
        let firstCard = cards[0]
        
        addChild(firstCard)
        
        for index in 1..<cards.count {
            let lastCard = cards[index - 1]
            let newCard = cards[index]
            let lastPosition = lastCard.position
            let lastZPosition = lastCard.zPosition
            
            newCard.zPosition = lastZPosition - 1
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
    func setCardStack(addToP1: Bool, cardBase: Card) -> [Card] {

        var cardStack: [Card] = []
        let wrongIntArray = fillWrongArray(addToP1)
        let correctIntArray = fillCorrectArray(addToP1)
        
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
        
        addCardsToScene(shuffledStack, p1: addToP1)

        return shuffledStack
    }
    
    func fillWrongArray(addToP1: Bool) -> [Int] {
        var wrongArray : [Int] = []
        
        while wrongArray.count < 9 {
            var randomNumber: Int!
            if addToP1 {
                let topNumber = UInt32(randomMultipleP1 * 10)
                randomNumber = Int(arc4random_uniform(topNumber - 1) + 1)
                
                if randomNumber % randomMultipleP1 != 0 {
                    wrongArray.append(randomNumber)
                }
            }
            else {
                let topNumber = UInt32(randomMultipleP2 * 10)
                randomNumber = Int(arc4random_uniform(topNumber - 1) + 1)
                
                if randomNumber % randomMultipleP2 != 0 {
                    wrongArray.append(randomNumber)
                }
            }
        }
        
        return wrongArray
    }
    
    func fillCorrectArray(addToP1: Bool) -> [Int] {
        var correctArray : [Int] = []
        
        var multiple : Int!
        if addToP1 {
            multiple = randomMultipleP1
        }
        else {
            multiple = randomMultipleP2
        }
        
        var currentMultiple: Int = multiple

        for _ in 0...9 {
            correctArray.append(currentMultiple)
            currentMultiple += multiple
        }
        
        return correctArray
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            // do something with this touch
        }
    }
    
    
    
    
}
