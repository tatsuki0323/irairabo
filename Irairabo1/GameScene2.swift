//
//  GameScene2.swift
//  Irairabo1
//
//  Created by 川崎　樹 on 2015/08/25.
//  Copyright (c) 2015年 川崎　樹. All rights reserved.
//

import SpriteKit
import AVFoundation

private var myAudioPlayer : AVAudioPlayer!
private var back = SKSpriteNode(imageNamed:"sampleStage4")//背景
private var ball = SKSpriteNode(imageNamed:"sampleBall2")//ボール画像
//private let frictionCircle = SKShapeNode()//当たり判定用の円
private var last: CFTimeInterval!

let stageLabel2 = SKLabelNode(fontNamed: "Chalkduster")//ステージラベル
let startStageLabel2 = SKLabelNode(fontNamed: "Chalkduster")//今のステージを表示するラベル

class GameScene2: SKScene,SKPhysicsContactDelegate,AVAudioPlayerDelegate{
    
    
    override func didMoveToView(view: SKView) {
        
        //再生する音源のURLを生成.
        let soundFilePath : NSString = NSBundle.mainBundle().pathForResource("se_explosion", ofType: "mp3")!
        let fileURL : NSURL = NSURL(fileURLWithPath: soundFilePath as String)!
        
        //AVAudioPlayerのインスタンス化.
        myAudioPlayer = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
        
        //AVAudioPlayerのデリゲートをセット.
        myAudioPlayer.delegate = self
        
        self.backgroundColor = UIColor.blackColor()//背景色の設定
        //ステージ
        back.name = "back"
        back.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "sampleStage4.png"),size:back.size)
        back.physicsBody?.dynamic = false//動かないようにする
        //back.position = CGPointMake(-self.size.width*0.3,self.size.height*0.5)
        back.position = CGPointMake(self.size.width*0.1,self.size.height*0.5)
        self.addChild(back)
        
        
        //重力設定
        self.physicsWorld.gravity = CGVector(dx:0,dy:0)
        self.physicsWorld.contactDelegate = self
        
        
        //ボール作成
        ball.name = "ball"
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 49)
        ball.physicsBody?.contactTestBitMask = 1
        ball.position = CGPointMake(self.size.width*0.60,self.size.height*0.5)
        self.addChild(ball)
        
        /*
        //摩擦の判定用の円
        frictionCircle.name = "frictionCircle"
        frictionCircle.fillColor = UIColor.blueColor()
        frictionCircle.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        frictionCircle.physicsBody?.contactTestBitMask = 0
        frictionCircle.position = CGPointMake(self.size.width*0.60,self.size.height*0.5)
        self.addChild(frictionCircle)
        
        */
        
        //ステージ数を左上に表示
        stageLabel2.text = "すてーじ2"
        stageLabel2.fontSize = 20
        //stageLabel.position = CGPoint(x:CGRectGetMidX(self.frame)*0.7, y:CGRectGetMidY(self.frame)*2-50)
        stageLabel2.position = CGPoint(x:300, y:750)
        stageLabel2.name = "Stage2"
        self.addChild(stageLabel2)
        
        //ステージのはじめに表示
        startStageLabel2.text = "すてーじ2"
        startStageLabel2.fontSize = 20
        startStageLabel2.fontColor = UIColor.blueColor()
        startStageLabel2.position = CGPoint(x:self.size.width*0.5,y:self.size.height*0.8)
        startStageLabel2.name = "CurrentStage"
        self.addChild(startStageLabel2)
        
        var labelfadeAction = SKAction.fadeAlphaTo(0, duration: 2.0)
        startStageLabel2.runAction(labelfadeAction)
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
        //frictionCircle.position.x += deltaX
        //frictionCircle.position.y -= deltaY
        
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
                    
                    
                    startStageLabel2.removeFromParent()
                    ball.removeFromParent()
                    back.removeFromParent()
                    // frictionCircle.removeFromParent()
                    
                    
                    
                    // lastが未定義ならば、今の時間を入れる。
                    
                    myAudioPlayer.play()
                    
                    usleep(500)
                    
                    let tr = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1)
                    let newScene = GameOverScene(size: self.scene!.size)
                    newScene.scaleMode = SKSceneScaleMode.AspectFill
                    
                    self.view?.presentScene(newScene, transition: tr)
                }
                /*
                if (nodeA.name == "back" ||
                nodeB.name == "back" ) &&
                (nodeA.name == "frictionCircle" ||
                nodeB.name == "frictionCircle")
                {
                //ぶつかりそうになったときの処理を書く
                //パーティクルの作成
                let bombParticle = SKEmitterNode(fileNamed: "BombParticle.sks")
                self.addChild(bombParticle)
                
                //１秒後にパーティクルを削除する ぶつかるたびにパーティクルが増えて重くなる
                var removeAction = SKAction.removeFromParent()
                var durationAction = SKAction.waitForDuration(1)
                var sequenceAction = SKAction.sequence([durationAction,removeAction])
                bombParticle.runAction(sequenceAction)
                
                //ボールの位置にパーティクル移動
                bombParticle.position = CGPoint(x:ball.position.x, y:ball.position.y-50)
                bombParticle.alpha = 1
                //画面線した場合にまたラベルを表示させる
                startStageLabel.alpha = 1.0;
                
                var fadeAction = SKAction.fadeAlphaTo(0, duration: 1.0)
                bombParticle.runAction(fadeAction)
                
                }
                */
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {//毎時行うメソッド。画面遷移する際に1秒他の動作をしないようにする
        
        // lastが未定義ならば、今の時間を入れる。
        if !(last != nil) {
            last = currentTime
        }
        
        if last + 1 <= currentTime {
            if back.position.x >= self.size.width + 500{//ゲームをクリアした場合
                startStageLabel2.alpha = 1.0;
                startStageLabel2.removeFromParent()
                ball.removeFromParent()
                back.removeFromParent()
                
                
                let tr = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1)
                let newScene = GameClearScene(size: self.scene!.size)
                newScene.scaleMode = SKSceneScaleMode.AspectFill
                last = currentTime//lastを初期化
                self.view?.presentScene(newScene, transition: tr)
            }
        }
        back.position.x += 1;
    }
}


