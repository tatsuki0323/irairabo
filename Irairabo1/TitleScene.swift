//
//  TitleScene.swift
//  Irairabo1
//
//  Created by 川崎　樹 on 2015/04/30.
//  Copyright (c) 2015年 川崎　樹. All rights reserved.
//

import SpriteKit

class TitleScene: SKScene {
    
    private var sky1 = SKSpriteNode(imageNamed:"sky1")//背景
    private var sky2 = SKSpriteNode(imageNamed:"sky2")//背景
    
    override func didMoveToView(view: SKView) {
        //self.backgroundColor = UIColor(red:0,green:0,blue:0,alpha:0)//背景色の設定
        
        //背景1
        sky1.name = "sky1"
        sky1.physicsBody?.dynamic = false//動かないようにする
        //back.position = CGPointMake(-self.size.width*0.3,self.size.height*0.5)
        sky1.position = CGPointMake(self.size.width/2,self.size.height/2)
        self.addChild(sky1)
        
        
        //背景2
        sky2.name = "sky2"
        sky2.physicsBody?.dynamic = false//動かないようにする
        sky2.position = CGPointMake(-self.size.width*0.5,self.size.height*0.5)
        self.addChild(sky2)

        let startLabel = SKLabelNode(fontNamed: "Chalkduster")//スタートラベル
        startLabel.text = "すたーと"
        startLabel.fontSize = 50
        startLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        startLabel.name = "Start"
        self.addChild(startLabel)
        
        let titleLabel = SKLabelNode(fontNamed: "Chalkduster")//タイトルラベル
        titleLabel.text = "いらいらぼー"
        titleLabel.fontSize = 70
        titleLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)+100)
        titleLabel.name = "irairabo"
        self.addChild(titleLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let location = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(location)
        
        if touchedNode.name == "Start" {
            sky1.removeFromParent()
            sky2.removeFromParent()
            let tr = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1)
            let newScene = GameScene(size: self.scene!.size)
            newScene.scaleMode = SKSceneScaleMode.AspectFill
            self.view?.presentScene(newScene, transition: tr)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        sky1.position.x += 1
        sky2.position.x += 1
        if(sky1.position.x >= self.size.width*1.5){
            sky1.position.x = -self.size.width*0.5
        }
        if(sky2.position.x >= self.size.width*1.5){
            sky2.position.x = -self.size.width*0.5
        }
    }
}


