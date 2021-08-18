//
//  LoginVC.swift
//  foz
//
//  Created by Ahmed Medhat on 16/08/2021.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var loginBtn: RoundedButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UIView.animate(withDuration: 2.0) {
            self.loginBtn.alpha = 1
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
