//
//  GameScene.swift
//  Irairabo1
//
//  Created by 川崎　樹 on 2015/03/23.
//  Copyright (c) 2015年 川崎　樹. All rights reserved.
//

import SpriteKit

private var back_top = SKSpriteNode(imageNamed:"sampleStage4")//背景
private var back_bottom = SKSpriteNode(imageNamed:"sampleStage2_bottom")//背景
private var ball = SKSpriteNode(imageNamed:"sampleBall")//ボール画像
private var last: CFTimeInterval!

let stageLabel = SKLabelNode(fontNamed: "Chalkduster")//ステージラベル
let startStageLabel = SKLabelNode(fontNamed: "Chalkduster")//今のステージを表示するラベル

class GameScene: SKScene,SKPhysicsContactDelegate{
    
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = UIColor.yellowColor()//背景色の設定
        
        //ステージ上側
        back_top.name = "backTop"
        back_top.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "sampleStage4.png"),size:back_top.size)
        back_top.physicsBody?.dynamic = false//動かないようにする
        //back_top.position = CGPointMake(-self.size.width*0.3,self.size.height*0.5)
        back_top.position = CGPointMake(self.size.width*0.1,self.size.height*0.5)
        self.addChild(back_top)
       /*
        //ステージ下側
        back_bottom.name = "backBottom"
        back_bottom.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "sampleStage2_bottom.png"),size:back_bottom.size)
        back_bottom.physicsBody?.dynamic = false//動かないようにする
        back_bottom.position = CGPointMake(-self.size.width*0.3,self.size.height*0.5)
        self.addChild(back_bottom)
        */

        //重力設定
        self.physicsWorld.gravity = CGVector(dx:0,dy:0)
        self.physicsWorld.contactDelegate = self

        /*
        //ステージの移動
        let moveA = SKAction.moveTo(CGPoint(x:1300,y:self.size.height*0.5), duration: 50)
        let moveSequence = SKAction.sequence([moveA])
        let moveRepeatAction = SKAction.repeatActionForever(moveSequence)
        back_top.runAction(moveRepeatAction)
        back_bottom.runAction(moveRepeatAction)
        */

        
        //ボール作成
        ball.name = "ball"
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        ball.physicsBody?.contactTestBitMask = 1
        ball.position = CGPointMake(self.size.width*0.60,self.size.height*0.5)
        self.addChild(ball)
        
        //ステージ数を左上に表示
        stageLabel.text = "すてーじ1"
        stageLabel.fontSize = 20
        //stageLabel.position = CGPoint(x:CGRectGetMidX(self.frame)*0.7, y:CGRectGetMidY(self.frame)*2-50)
        stageLabel.position = CGPoint(x:300, y:750)
        stageLabel.name = "Stage1"
        self.addChild(stageLabel)
        
        //ステージのはじめに表示
        startStageLabel.text = "すてーじ1"
        startStageLabel.fontSize = 20
        startStageLabel.fontColor = UIColor.blueColor()
        startStageLabel.position = CGPoint(x:self.size.width*0.5,y:self.size.height*0.8)
        startStageLabel.name = "CurrentStage"
        self.addChild(startStageLabel)
        
        var labelfadeAction = SKAction.fadeAlphaTo(0, duration: 2.0)
        startStageLabel.runAction(labelfadeAction)
    }
    
    override func touchesMoved(touches: Set<NSObject>,withEvent event: UIEvent){//ドラッグ処理
        // タッチイベントを取得.
        let aTouch = touches.first as! UITouch
        
        // 移動した先の座標を取得.
        let location = aTouch.locationInView(self.view)
        
        // 移動する前の座標を取得.
        let prevLocation = aTouch.previousLocationInView(self.view)
        
        
        // ドラッグで移動したx, y距離をとる.
        let deltaX: CGFloat = location.x - prevLocation.x
        let deltaY: CGFloat = location.y - prevLocation.y
        
        // 移動した分の距離をmyFrameの座標にプラス、マイナスする.
        ball.position.x += deltaX
        ball.position.y -= deltaY
        
        /*
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)//現在位置の座標を取得
            ball.position = CGPointMake(location.x,location.y)//ボールの位置変更
        }
        */
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if let nodeA = contact.bodyA.node {
            if let nodeB = contact.bodyB.node {
                if nodeA.name == "backTop" ||
                   nodeB.name == "backTop" ||
                   nodeA.name == "backBottom" ||
                   nodeB.name == "backBottom" ||
                   nodeA.name == "ball" ||
                   nodeB.name == "ball"
                {
                    //ここに衝突が発生したときの処理を書く
                    //パーティクルの作成
                    let particle = SKEmitterNode(fileNamed: "SampleParticle.sks")
                    self.addChild(particle)
                    
                    // particleのもろもろの設定
                    particle.numParticlesToEmit = 1000 // 何個、粒を出すか。
                    particle.particleBirthRate = 500 // 一秒間に何個、粒を出すか。
                    particle.particleSpeed = 100 // 粒の速度
                    particle.xAcceleration = 0
                    particle.yAcceleration = 0 // 加速度を0にすることで、重力がないようになる。

                    //１秒後にパーティクルを削除する ぶつかるたびにパーティクルが増えて重くなる
                    //var removeAction = SKAction.removeFromParent()
                    //var durationAction = SKAction.waitForDuration(1)
                    //var sequenceAction = SKAction.sequence([durationAction,removeAction])
                    //particle.runAction(sequenceAction)
                    
                    //ボールの位置にパーティクル移動
                    //particle.position = CGPoint(x:ball.position.x, y:ball.position.y)
                    //particle.alpha = 1
                    //画面線した場合にまたラベルを表示させる
                    startStageLabel.alpha = 1.0;
                    
                    //var fadeAction = SKAction.fadeAlphaTo(0, duration: 1.0)
                    //particle.runAction(fadeAction)
                    
                    startStageLabel.removeFromParent()
                    ball.removeFromParent()
                    back_top.removeFromParent()
                    back_bottom.removeFromParent()
                   
                    let tr = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1)
                    let newScene = GameOverScene(size: self.scene!.size)
                    newScene.scaleMode = SKSceneScaleMode.AspectFill
                    self.view?.presentScene(newScene, transition: tr)
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {//毎時行うメソッド。画面遷移する際に1秒他の動作をしないようにする
        
        // lastが未定義ならば、今の時間を入れる。
        if !(last != nil) {
            last = currentTime
        }
        
        if last + 1 <= currentTime {
            if back_top.position.x >= self.size.width + 500{//ゲームをクリアした場合
                startStageLabel.alpha = 1.0;
                startStageLabel.removeFromParent()
                ball.removeFromParent()
                back_top.removeFromParent()
                back_bottom.removeFromParent()

                
                let tr = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1)
                let newScene = GameClearScene(size: self.scene!.size)
                newScene.scaleMode = SKSceneScaleMode.AspectFill
                last = currentTime//lastを初期化
                self.view?.presentScene(newScene, transition: tr)
            }
        }
        back_top.position.x += 1;
        back_bottom.position.x += 1;
    }
}

