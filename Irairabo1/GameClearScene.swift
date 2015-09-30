//
//  GameClearScene.swift
//  Irairabo1
//
//  Created by 川崎　樹 on 2015/05/14.
//  Copyright (c) 2015年 川崎　樹. All rights reserved.
//

import SpriteKit
import AVFoundation

private var myAudioPlayer : AVAudioPlayer!

class GameClearScene: SKScene,AVAudioPlayerDelegate{
    
    override func didMoveToView(view: SKView) {
        //再生する音源のURLを生成.
        let soundFilePath : NSString = NSBundle.mainBundle().pathForResource("se_clear", ofType: "mp3")!
        let fileURL : NSURL = NSURL(fileURLWithPath: soundFilePath as String)
        
        //AVAudioPlayerのインスタンス化.
        myAudioPlayer = try? AVAudioPlayer(contentsOfURL: fileURL)
        
        //AVAudioPlayerのデリゲートをセット.
        myAudioPlayer.delegate = self
        myAudioPlayer.play()
        self.backgroundColor = UIColor(red:0,green:0,blue:0,alpha:0)//背景色の設定
        let clearLabel = SKLabelNode(fontNamed: "Chalkduster")//スタートラベル
        clearLabel.text = "くりあー"
        clearLabel.fontSize = 50
        clearLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        clearLabel.name = "Clear"
        self.addChild(clearLabel)
        
        
        // 戻るための「Back」ラベルを作成。
        let backLabel = SKLabelNode(fontNamed: "Chalkduster")
        backLabel.text = "タイトルにもどる"
        backLabel.fontSize = 36
        backLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: 200)
        backLabel.name = "Back"
        self.addChild(backLabel)
        
        // 次のステージに進むための「next」ラベルを作成。
        let nextLabel = SKLabelNode(fontNamed: "Chalkduster")
        nextLabel.text = "つぎのステージにすすむ"
        nextLabel.fontSize = 36
        nextLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: 300)
        nextLabel.name = "next"
        self.addChild(nextLabel)
    }
    
      override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let location = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(location)
        
        if touchedNode.name == "Back" {
            myAudioPlayer.stop()
            let tr = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1)
            let newScene = TitleScene(size: self.scene!.size)
            newScene.scaleMode = SKSceneScaleMode.AspectFill
            self.view?.presentScene(newScene, transition: tr)
        }
        
        if touchedNode.name == "next" {
            myAudioPlayer.stop()
            let tr = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1)
            let newScene = GameScene2(size: self.scene!.size)
            newScene.scaleMode = SKSceneScaleMode.AspectFill
            self.view?.presentScene(newScene, transition: tr)
        }

    }
}
    
    
    

