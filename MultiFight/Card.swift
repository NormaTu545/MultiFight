//
//  Card.swift
//  MultiFight
//
//  Created by Norma Tu on 7/5/16.
//  Copyright © 2016 NormaTu. All rights reserved.
//

import SpriteKit

class Card: SKSpriteNode  {
    
    var cardNumber : SKLabelNode!
    
    var number: Int = 1 {
        //Updates number label on card every time it is set
        didSet {
            cardNumber.text = String(number)
        }
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func connectNumber() {
        cardNumber = self.childNodeWithName("cardNumber") as! SKLabelNode
    }
    
    func connectNumberMulti() {
        cardNumber = SKLabelNode(fontNamed: "Helvetica")
        cardNumber.fontColor = UIColor.blackColor()
        cardNumber.position.x = 0
        cardNumber.position.y = -20
        cardNumber.fontSize = 72
        cardNumber.zPosition = 1
        addChild(cardNumber)
    }
    
    func flip(actionName: String) {
        let flip = SKAction(named: actionName)!
        
        let remove = SKAction.removeFromParent()
        
        let sequence = SKAction.sequence([flip, remove])
        runAction(sequence)
    }
}
