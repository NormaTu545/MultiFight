//
//  MultiScene.swift
//  MultiFight
//
//  Created by Norma Tu on 7/5/16.
//  Copyright © 2016 NormaTu. All rights reserved.
//

import SpriteKit
import GameplayKit

class MultiScene: SKScene {
    var cardBaseP1 : Card!
    var cardBaseP2 : Card!
    var multipleOfP1 : SKLabelNode!
    var multipleOfP2 : SKLabelNode!
    var cardStackP1 : [Card] = []
    var cardStackP2 : [Card] = []
    
    var correctArray : [Card] = []
    
    var randomMultipleP1 : Int!
    var randomMultipleP2 : Int!
    
    override func didMoveToView(view: SKView) {
        //cardBaseP1 = self.childNodeWithName("cardBaseP1") as! Card
        //cardBaseP2 = self.childNodeWithName("cardBaseP2") as! Card
        let cardSize = CGSize(width: 140, height: 140)
        cardBaseP1 = Card()
        cardBaseP1.position.x = 160
        cardBaseP1.position.y = 120
        cardBaseP1.size = cardSize
        cardBaseP1.color = UIColor.whiteColor()
        cardBaseP1.connectNumberMulti()
        
        cardBaseP2 = Card()
        cardBaseP2.position.x = 160
        cardBaseP2.position.y = 450
        cardBaseP2.size = cardSize
        cardBaseP2.xScale = -1
        cardBaseP2.yScale = -1
        cardBaseP2.color = UIColor.whiteColor()
        cardBaseP2.connectNumberMulti()
        
        multipleOfP1 = self.childNodeWithName("multipleOfP1") as! SKLabelNode
        multipleOfP2 = self.childNodeWithName("multipleOfP2") as! SKLabelNode
        
        //Both players get a random starting multiple each
        randomMultipleP1 = Int(arc4random_uniform(8) + 2)
        randomMultipleP2 = Int(arc4random_uniform(8) + 2)
        
        multipleOfP1.text = "Multiple of: \(randomMultipleP1)"
        multipleOfP2.text = "Multiple of: \(randomMultipleP2)"
        
        cardStackP1 = setCardStack(true, cardBase: cardBaseP1)
        cardStackP2 = setCardStack(false, cardBase: cardBaseP2)
    }
    
    func addCard(number: Int, addToP1: Bool) {
        var lastCard : Card!
        
        if addToP1 {
            lastCard = cardStackP1.last
        }
        else {
            lastCard = cardStackP2.last
        }
        
        let newCard = lastCard.copy() as! Card
        
        newCard.connectNumber() //connects label
        
        let lastCardPosition = lastCard.position
        
        newCard.position = lastCardPosition + CGPoint(x: 15, y: -15) //Placing card behind
        
        let lastZposition = lastCard.zPosition
        newCard.zPosition = lastZposition - 1
        
        newCard.number = number
        
        addChild(newCard) //attaches the node to the scene
        
        if addToP1 {
            cardStackP1.append(newCard)
        }
        else {
            cardStackP2.append(newCard)
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
        
        cardStack.append(cardBase)
        
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
}
