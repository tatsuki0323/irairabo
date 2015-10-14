//
//  GameScene.swift
//  Irairabo1
//
//  Created by 川崎　樹 on 2015/03/23.
//  Copyright (c) 2015年 川崎　樹. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene2: SKScene,SKPhysicsContactDelegate,AVAudioPlayerDelegate{
    
    private var myAudioPlayer : AVAudioPlayer!
    private var back = SKSpriteNode(imageNamed:"stage1-1")//背景
    private var ball = SKSpriteNode(imageNamed:"sampleBall2")//ボール画像
    private var obstacle = SKSpriteNode(imageNamed:"obstacle")//障害物画像
    private var sky1 = SKSpriteNode(imageNamed:"sky1")//背景
    private var sky2 = SKSpriteNode(imageNamed:"sky2")//背景
    //private let frictionCircle = SKShapeNode()//当たり判定用の円
    private var last: CFTimeInterval!
    
    
    let stageLabel = SKLabelNode(fontNamed: "Chalkduster")//左上のステージラベル
    let startStageLabel = SKLabelNode(fontNamed: "Chalkduster")//今のステージを表示するラベル
    override func didMoveToView(view: SKView) {
        
        //再生する音源のURLを生成.
        let soundFilePath : NSString = NSBundle.mainBundle().pathForResource("bgm_pop", ofType: "mp3")!
        let fileURL : NSURL = NSURL(fileURLWithPath: soundFilePath as String)
            
        //AVAudioPlayerのインスタンス化.
        myAudioPlayer = try? AVAudioPlayer(contentsOfURL: fileURL)
            
        //AVAudioPlayerのデリゲートをセット.
        myAudioPlayer.delegate = self
        myAudioPlayer.play()
        
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

        //ステージ
        back.name = "back"
        back.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "stage1-1.png"),size:back.size)
        back.physicsBody?.dynamic = false//動かないようにする
        //back.position = CGPointMake(-self.size.width*0.3,self.size.height*0.5)
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
        
        //障害物作成
        obstacle.name = "obstacle"
        obstacle.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "obstacle.png"),size:obstacle.size)
        //obstacle.physicsBody?.contactTestBitMask = 0
        //obstacle.physicsBody?.categoryBitMask = 0
        obstacle.physicsBody?.collisionBitMask = 0
        obstacle.position = CGPointMake(0,self.size.height*0.5)
        self.addChild(obstacle)
        
        
        //ステージ数を左上に表示
        stageLabel.text = "すてーじ2"
        stageLabel.fontSize = 20
        //stageLabel.position = CGPoint(x:CGRectGetMidX(self.frame)*0.7, y:CGRectGetMidY(self.frame)*2-50)
        stageLabel.position = CGPoint(x:300, y:750)
        stageLabel.name = "Stage2"
        self.addChild(stageLabel)
        
        
        //ステージのはじめに表示
        startStageLabel.text = "すてーじ2"
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
                    obstacle.removeFromParent()
                    sky1.removeFromParent()
                    sky2.removeFromParent()

                    //画面線した場合にまたラベルを表示させる
                    startStageLabel.alpha = 1.0

                    
                    
                    // lastが未定義ならば、今の時間を入れる。
                   
                        myAudioPlayer.stop()//BGMストップ
                    
                        let tr = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1)
                        let newScene = GameOverScene2(size: self.scene!.size)
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
            if back.position.x >= self.size.width + 600{//ゲームをクリアした場合
                myAudioPlayer.stop()//BGM終了
                startStageLabel.alpha = 1.0;
                startStageLabel.removeFromParent()
                ball.removeFromParent()
                back.removeFromParent()
                sky1.removeFromParent()
                sky2.removeFromParent()
                obstacle.removeFromParent()
                
                let tr = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1)
                let newScene = GameClearScene2(size: self.scene!.size)
                newScene.scaleMode = SKSceneScaleMode.AspectFill
                last = currentTime//lastを初期化
                self.view?.presentScene(newScene, transition: tr)
            }
        }
        back.position.x += 1
        obstacle.position.x += 1
        obstacle.position.y = self.size.height*0.5 + 300*sin(obstacle.position.x/50)
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

