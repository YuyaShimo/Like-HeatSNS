//
//  TimeLineModel.swift
//  Like&HeatSNS
//
//  Created by 下新原佑哉 on 2020/04/08.
//  Copyright © 2020 Yuya shimoshimbara. All rights reserved.
//

import Foundation
import  Firebase

class TimeLineModel {
    
    var text:String = ""
    var imageString:String = ""
    var profileImageString:String = ""
    var userName:String = ""
    var likeCounts = 0
    var heartCounts = 0
    let ref:DatabaseReference!
    
    
    init(text:String,imageString:String,profileImageString:String,userName:String) {
        
        self.text = text
        self.imageString = imageString
        self.profileImageString = profileImageString
        self.userName = userName
        ref = Database.database().reference().child("timeLine").childByAutoId()
    }
    
    init(snapshop:DataSnapshot) {
        
        ref = snapshop.ref
        if let value = snapshop.value as? [String:Any] {
            
            //値を取得
            text = value["text"] as! String
            imageString = value["imageString"] as! String
            userName = value["userName"] as! String
            profileImageString = value["profileImageString"] as! String
            likeCounts = value["likeCounts"] as! Int
            heartCounts = value["heartCounts"] as! Int
        }
    }
    
    func toContents()->[String:Any] {
        
        return["text":text,
               "imageString":imageString,
               "profileImageString":profileImageString,
               "userName":userName,
               "likeCounts":likeCounts,
               "heartCounts":heartCounts]
    }
    
    func save() {
        
        //firebaseに保存
        ref.setValue(toContents())
    }
    
}
extension TimeLineModel {
    
    func plusLike() {   //like数プラス
        
        likeCounts += 1
        ref.child("likeCounts").setValue(likeCounts)
    }
    
    func plusHeart() {  //ハート数プラス
    
    heartCounts += 1
    ref.child("heartCounts").setValue(heartCounts)
    }
    
    func minusLike() {   //like数マイナス
        
        likeCounts -= 1
        ref.child("likeCounts").setValue(likeCounts)
    }
    
    func minusHeart() {  //ハート数マイナス
    
    heartCounts -= 1
    ref.child("heartCounts").setValue(heartCounts)
    }
    
}


