//
//  TitleScene.swift
//  Irairabo1
//
//  Created by 川崎　樹 on 2015/04/30.
//  Copyright (c) 2015年 川崎　樹. All rights reserved.
//

import SpriteKit

class TitleScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(red:0,green:0,blue:0,alpha:0)
        let startLabel = SKLabelNode(fontNamed: "Chalkduster")
        startLabel.text = "すたーと"
        startLabel.fontSize = 50
        startLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        startLabel.name = "Start"
        self.addChild(startLabel)
        
        
        let titleLabel = SKLabelNode(fontNamed: "Chalkduster")
        titleLabel.text = "いらいらぼー"
        titleLabel.fontSize = 70
        titleLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)+100)
        titleLabel.name = "irairabo"
        self.addChild(titleLabel)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        let touch: AnyObject = touches.anyObject()!
        let location = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(location)
        
        if touchedNode.name == "Start" {
            let tr = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1)
            let newScene = GameScene(size: self.scene!.size)
            newScene.scaleMode = SKSceneScaleMode.AspectFill
            self.view?.presentScene(newScene, transition: tr)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {}
}


