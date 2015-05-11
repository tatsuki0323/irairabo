//
//  GameScene.swift
//  Irairabo1
//
//  Created by 川崎　樹 on 2015/03/23.
//  Copyright (c) 2015年 川崎　樹. All rights reserved.
//

import SpriteKit

var background: SKSpriteNode!//背景画像
var ball: SKSpriteNode!//ボール画像
class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        background = SKSpriteNode(imageNamed:"sampleStage")
        background.position = CGPointMake(-200,self.size.height*0.5)
        self.addChild(background)

        ball = SKSpriteNode(imageNamed:"ball")
        ball.position = CGPointMake(self.size.width*0.5,self.size.height*0.5)
        self.addChild(ball)
        }
    
    override func touchesMoved(touches:NSSet,withEvent event: UIEvent){//ドラッグ処理
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)//現在位置の座標を取得
            ball.position = CGPointMake(location.x,location.y)//ボールの位置変更
        }
    }
   
    override func update(currentTime: CFTimeInterval) {//毎時行うメソッド
        var slideSpeed:CGFloat = 3
        background.position.x += slideSpeed //画像の位置変更
    }
}

