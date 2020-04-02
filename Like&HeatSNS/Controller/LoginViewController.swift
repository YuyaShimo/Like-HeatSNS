//
//  LoginViewController.swift
//  Like&HeatSNS
//
//  Created by 下新原佑哉 on 2020/03/31.
//  Copyright © 2020 Yuya shimoshimbara. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    

    @IBOutlet weak var userNameView: UIView!
    
    @IBOutlet weak var textfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameView.isHidden = true   //表示状態
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func done(_ sender: Any) {
        
        if textfield.text?.isEmpty != true { //textfieldの値をアプリ内へ保存
            
            userNameView.isHidden = true
            UserDefaults.standard.set(textfield.text, forKey: "userName")
            
        }else{
            
            let generator =
                UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            print("振動")
            
        }
        
        
    }
    
    @IBAction func login(_ sender: Any) {
        
        //ログイン
        
        Auth.auth().signInAnonymously { (result, error)
            in
        if error == nil {
            
            self.performSegue(withIdentifier: "edit", sender: nil)
        
        }else{
            print(error?.localizedDescription as Any)
            
        }
        }
        
        
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
