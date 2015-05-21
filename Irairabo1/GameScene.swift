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
var last:CFTimeInterval!
class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.yellowColor()//背景色の設定
        background = SKSpriteNode(imageNamed:"sampleStage")//背景画像の設定
        background.position = CGPointMake(self.size.width*0.5-500,self.size.height*0.5)
        self.addChild(background)

        ball = SKSpriteNode(imageNamed:"sampleBall")
        ball.position = CGPointMake(self.size.width*0.5+200,self.size.height*0.5)
        self.addChild(ball)
        }
    
    override func touchesMoved(touches: Set<NSObject>,withEvent event: UIEvent){//ドラッグ処理
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)//現在位置の座標を取得
            ball.position = CGPointMake(location.x,location.y)//ボールの位置変更
        }
    }
   
    
    override func update(currentTime: CFTimeInterval) {//毎時行うメソッド。上手く画面遷移しないから画面遷移の処理だけ1秒ごとに行う。
        // lastが未定義ならば、今の時間を入れる。
        if !(last != nil) {
            last = currentTime
        }
        
        // 1秒おきに行う処理をかく。
        if last + 1 <= currentTime {
            if background.position.x >= self.size.width + 300{//ゲームをクリアした場合
                let tr = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1)
                let newScene = GameClearScene(size: self.scene!.size)
                newScene.scaleMode = SKSceneScaleMode.AspectFill
                self.view?.presentScene(newScene, transition: tr)
                last = currentTime
            }
        }
        var slideSpeed:CGFloat = 5
        background.position.x += slideSpeed //画像の位置
        
        
    }
}

