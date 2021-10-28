//
//  SideMenuVC.swift
//  foz
//
//  Created by Ahmed Medhat on 26/08/2021.
//

import UIKit

class SideMenuVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 80
    }
    
    @IBAction func cotactUsBtnTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let contactUsVC = storyboard.instantiateViewController(withIdentifier: "ChatVC")
        present(contactUsVC, animated: true, completion: nil)
    }
    
    @IBAction func termsAndConditionBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let contactUsVC = storyboard.instantiateViewController(withIdentifier: "terms_and_condition_vc") as! TermsAndConditionVC
        present(contactUsVC, animated: true, completion: nil)
    }
    
    @IBAction func logoutBtnTapped(_ sender: Any) {
        LoginResponse.current = nil
        let loginvc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "login_view_controller") as! LoginVC
        present(loginvc, animated: true, completion: nil)
    }
    
}
