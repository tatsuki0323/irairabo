//
//  GameOverScene.swift
//  Irairabo1
//
//  Created by 川崎　樹 on 2015/05/26.
//  Copyright (c) 2015年 川崎　樹. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(red:0,green:0,blue:0,alpha:0)//背景色の設定
        let clearLabel = SKLabelNode(fontNamed: "Chalkduster")//スタートラベル
        clearLabel.text = "くりあーしっぱい"
        clearLabel.fontSize = 50
        clearLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        clearLabel.name = "ClearFaild"
        self.addChild(clearLabel)
        
        
        // 戻るための「Back」ラベルを作成。
        let backLabel = SKLabelNode(fontNamed: "Chalkduster")
        backLabel.text = "タイトルに戻る"
        backLabel.fontSize = 36
        backLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: 200)
        backLabel.name = "Back"
        self.addChild(backLabel)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let location = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(location)
        
        if touchedNode.name == "Back" {
            let tr = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1)
            let newScene = TitleScene(size: self.scene!.size)
            newScene.scaleMode = SKSceneScaleMode.AspectFill
            self.view?.presentScene(newScene, transition: tr)
        }
    }
}
