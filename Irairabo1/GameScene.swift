//
//  GameScene.swift
//  Irairabo1
//
//  Created by 川崎　樹 on 2015/03/23.
//  Copyright (c) 2015年 川崎　樹. All rights reserved.
//

import SpriteKit

private var back_top = SKSpriteNode(imageNamed:"sampleStage_top")//背景
private var back_bottom = SKSpriteNode(imageNamed:"sampleStage_bottom")//背景
private var ball = SKSpriteNode(imageNamed:"sampleBall")//ボール画像
private var last: CFTimeInterval!

private let stageLabel = SKLabelNode(fontNamed: "Chalkduster")//スタートラベル


class GameScene: SKScene,SKPhysicsContactDelegate{
    
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = UIColor.yellowColor()//背景色の設定
        back_top.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "sampleStage_top.png"),size:back_top.size)
        back_top.physicsBody?.dynamic = false//動かないようにする
        back_top.position = CGPointMake(-self.size.width*0.3,self.size.height*0.5)
        self.addChild(back_top)
        
        back_bottom.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "sampleStage_bottom.png"),size:back_top.size)
        back_bottom.physicsBody?.dynamic = false//動かないようにする
        back_bottom.position = CGPointMake(-self.size.width*0.3,self.size.height*0.5)
        self.addChild(back_bottom)

       //self.size = CGSize(width: 1024, height: 768)
        //重力設定
        self.physicsWorld.gravity = CGVector(dx:0,dy:0)
        self.physicsWorld.contactDelegate = self

        //移動
        let moveA = SKAction.moveTo(CGPoint(x:1000,y:self.size.height*0.5), duration: 100)
        //let moveB = SKAction.moveTo(CGPoint(x:200,y:300), duration: 1)
        let moveSequence = SKAction.sequence([moveA])
        let moveRepeatAction =  SKAction.repeatActionForever(moveSequence)
        back_top.runAction(moveRepeatAction)
        back_bottom.runAction(moveRepeatAction)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        ball.physicsBody?.contactTestBitMask = 1
        ball.position = CGPointMake(self.size.width*0.60,self.size.height*0.5)
        self.addChild(ball)
        
        
        stageLabel.text = "すてーじ1"
        stageLabel.fontSize = 20
        //stageLabel.position = CGPoint(x:CGRectGetMidX(self.frame)*0.7, y:CGRectGetMidY(self.frame)*2-50)
        stageLabel.position = CGPoint(x:50, y:1000)
        stageLabel.name = "Stage1"
        self.addChild(stageLabel)
        }
    
    override func touchesMoved(touches: Set<NSObject>,withEvent event: UIEvent){//ドラッグ処理
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)//現在位置の座標を取得
            ball.position = CGPointMake(location.x,location.y)//ボールの位置変更
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if let nodeA = contact.bodyA.node {
            if let nodeB = contact.bodyB.node {
                if nodeA.name == "sampleStage_top" ||
                   nodeB.name == "sampleStage_top" ||
                   nodeA.name == "sampleStage_bottom" ||
                   nodeB.name == "sampleStage_bottom" ||
                   nodeA.name == "sampleBall" ||
                   nodeB.name == "sampleBall"
                {
                        //ここに衝突が発生したときの処理を書く


                    
                    let tr = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1)
                    let newScene = GameOverScene(size: self.scene!.size)
                    newScene.scaleMode = SKSceneScaleMode.AspectFill
                    self.view?.presentScene(newScene, transition: tr)
                }
            }
        }
    }
    
  /*  override func update(currentTime: CFTimeInterval) {//毎時行うメソッド。画面遷移する際に1秒他の動作をしないようにする
        // lastが未定義ならば、今の時間を入れる。
        if !(last != nil) {
            last = currentTime
        }
        
        if last + 1 <= currentTime {
            if back.position.x >= self.size.width + 300{//ゲームをクリアした場合
                let tr = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1)
                let newScene = GameClearScene(size: self.scene!.size)
                newScene.scaleMode = SKSceneScaleMode.AspectFill
                last = currentTime//lastを初期化
                self.view?.presentScene(newScene, transition: tr)
            }
            if (ball.position.y <= self.size.height*0.5-10.0) || (self.size.height*0.5+10.0 <= ball.position.y){//ゲームをクリアできなかった場合
                let tr = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1)
                let newScene = GameOverScene(size: self.scene!.size)
                newScene.scaleMode = SKSceneScaleMode.AspectFill
                last = currentTime//lastを初期化
                self.view?.presentScene(newScene, transition: tr)
            }
        }
        var slideSpeed:CGFloat = 1
        back.position.x += slideSpeed //画像の位置変更
    }*/
}

