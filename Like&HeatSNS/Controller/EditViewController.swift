//
//  EditViewController.swift
//  Like&HeatSNS
//
//  Created by 下新原佑哉 on 2020/03/31.
//  Copyright © 2020 Yuya shimoshimbara. All rights reserved.
//

import UIKit
import Photos
import Firebase
import PKHUD

class EditViewController:
    UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageURL:URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        PHPhotoLibrary.requestAuthorization { (status) in
            
            switch(status) {
                
            case .authorized:
                print("許可されています")
                
            case .denied:
                print("拒否されました")
            
            case .notDetermined:
                print("notDetermind")
                
            case .restricted:
                print("restricted")
                
            @unknown default:
                fatalError()
            }
        }
    }
    @IBAction func tapImageView(_ sender: Any) {
        
        openActionSheet()
    }
    
    func openActionSheet() {
        
        let alert:UIAlertController = UIAlertController(title: "選択してください。", message: "", preferredStyle: .actionSheet)
        
        let cameraAction:UIAlertAction = UIAlertAction(title: "カメラから", style: .default) { (alert) in
            
            let sourceType = UIImagePickerController.SourceType.camera
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                let cameraPicker = UIImagePickerController()
                cameraPicker.sourceType = sourceType
                cameraPicker.delegate = self
                cameraPicker.allowsEditing = true
                
                self.present(cameraPicker, animated: true)
            }else{
                
                print("エラーです。")
            }
        }
        
        let albumAction = UIAlertAction(title: "アルバムから", style: .default) { (alert) in
            
            let sourceType = UIImagePickerController.SourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let albumPicker = UIImagePickerController()
            albumPicker.sourceType = sourceType
            albumPicker.delegate = self
            albumPicker.allowsEditing = true
            
            self.present(albumPicker, animated: true)
        }else{
            
            print("エラーです。")
        }
    }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
            
            print("キャンセル")
        }
    
        alert.addAction(cameraAction)
        alert.addAction(albumAction)
        self.present(alert, animated: true, completion: nil)
   
    }
    
    @IBAction func done(_ sender: Any) {
        //imageview.imageがnilでない場合、strageserverへimage送信し、strageserverからimageのURLが帰ってくる。
        //アプリ保存してタイムライン画面へ遷移する。
        
        if imageView.image != nil {
            
            //同期処理
            DispatchQueue.main.async {
                self.sendAndGetImageURL()  //当該処理が終わらないと画面遷移しない
            }
            
            performSegue(withIdentifier: "timeLine", sender: nil)
        }
        
        
        
    }
    
    func sendAndGetImageURL() {
        /*
        https://likeandheartsns-15dcb.firebaseio.com/
        gs://likeandheartsns-15dcb.appspot.com
        */
    
        let ref = Database.database().reference(fromURL: "https://likeandheartsns-15dcb.firebaseio.com/")
        
        let storage = Storage.storage().reference(forURL: "gs://likeandheartsns-15dcb.appspot.com")
        
        //画像が入るフォルダを作成し、画像をいれる。
        //画像の名前を決定
        
        let key = ref.childByAutoId().key
        let imageRef = storage.child("ProfileImages")
        .child("\(key).jpeg")
        
        var imageData:Data = Data()
        
        if self.imageView.image != nil {
            
            imageData = (self.imageView.image?.jpegData(compressionQuality: 0.01))!  //1/100に圧縮して保存
            
            
        }
        
        //HUD
        HUD.dimsBackground = false
        HUD.show(.progress)
        
        //upload
        let uploadTask = imageRef.putData(imageData, metadata: nil){ (metaData, error) in
        
        if error != nil {
            print(error as Any)
            return
        }
        
        imageRef.downloadURL{ (url, error) in
            
            if url != nil {
                
                //HUDとめる
                HUD.hide()
                
                self.imageURL = url
                UserDefaults.standard.setValue(self.imageURL?.absoluteString, forKeyPath: "profileImageString")
                
            }
        }
        }
        uploadTask.resume()
}
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.editedImage] as? UIImage {
            self.imageView.image = pickedImage
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
