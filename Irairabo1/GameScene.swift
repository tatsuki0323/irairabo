//
//  GameScene.swift
//  Irairabo1
//
//  Created by 川崎　樹 on 2015/10/04.
//  Copyright © 2015年 川崎　樹. All rights reserved.
//

import SpriteKit
import AVFoundation

private var myAudioPlayer : AVAudioPlayer!
private var back = SKSpriteNode(imageNamed:"stage1")//背景
private var ball = SKSpriteNode(imageNamed:"sampleBall2")//ボール画像
private var last: CFTimeInterval!

let stageLabel = SKLabelNode(fontNamed: "Chalkduster")//左上のステージラベル
let startStageLabel = SKLabelNode(fontNamed: "Chalkduster")//今のステージを表示するラベル


class GameScene: SKScene,SKPhysicsContactDelegate,AVAudioPlayerDelegate{
    override func didMoveToView(view: SKView) {
        
        //再生する音源のURLを生成.
        let soundFilePath : NSString = NSBundle.mainBundle().pathForResource("bgm_pop", ofType: "mp3")!
        let fileURL : NSURL = NSURL(fileURLWithPath: soundFilePath as String)
        
        //AVAudioPlayerのインスタンス化.
        myAudioPlayer = try? AVAudioPlayer(contentsOfURL: fileURL)
        
        //AVAudioPlayerのデリゲートをセット.
        myAudioPlayer.delegate = self
        myAudioPlayer.play()
        self.backgroundColor = UIColor.yellowColor()//背景色の設定
        //ステージ
        back.name = "back"
        back.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "stage1.png"),size:back.size)
        back.physicsBody?.dynamic = false//動かないようにする
        back.position = CGPointMake(self.size.width*0,self.size.height*0.5)
        self.addChild(back)
        
        //重力設定
        self.physicsWorld.gravity = CGVector(dx:0,dy:0)
        self.physicsWorld.contactDelegate = self
        
        //ボール作成
        ball.name = "ball"
        //ball.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "sampleBall2.png"),size:ball.size)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 48)
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
        
        let labelFadeOutAction = SKAction.fadeAlphaTo(0, duration: 1.5)
        startStageLabel.runAction(labelFadeOutAction)
        
    }
    
    override func touchesMoved(touches: Set<UITouch>,withEvent event: UIEvent?){//ドラッグ処理
        // タッチイベントを取得.
        let aTouch = touches.first! as UITouch
        //let aTouch = touches.first as! UITouch
        
        
        // 移動した先の座標を取得.
        let location = aTouch.locationInView(self.view)
        
        // 移動する前の座標を取得.
        let prevLocation = aTouch.previousLocationInView(self.view)
        
        
        // ドラッグで移動したx, y距離をとる.
        let deltaX: CGFloat = location.x - prevLocation.x
        let deltaY: CGFloat = -(location.y - prevLocation.y)
        
        // 移動した分の距離をmyFrameの座標にプラス、マイナスする.
        ball.position.x += deltaX
        ball.position.y += deltaY
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        
        if let nodeA = contact.bodyA.node {
            if let nodeB = contact.bodyB.node {
                if (nodeA.name == "back" ||
                    nodeB.name == "back" ) &&
                    (nodeA.name == "ball" ||
                        nodeB.name == "ball")
                {
                    //ここに衝突が発生したときの処理を書く
                    startStageLabel.removeFromParent()
                    ball.removeFromParent()
                    back.removeFromParent()
                    
                    //画面線した場合にまたラベルを表示させる
                    startStageLabel.alpha = 1.0
                    
                    myAudioPlayer.stop()//BGMストップ
                    
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
            if back.position.x >= self.size.width + 600{//ゲームをクリアした場合
                myAudioPlayer.stop()//BGM終了
                startStageLabel.alpha = 1.0;
                startStageLabel.removeFromParent()
                ball.removeFromParent()
                back.removeFromParent()
    
                let tr = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1)
                let newScene = GameClearScene(size: self.scene!.size)
                newScene.scaleMode = SKSceneScaleMode.AspectFill
                last = currentTime//lastを初期化
                self.view?.presentScene(newScene, transition: tr)
            }
        }
        back.position.x += 1
    }
}


