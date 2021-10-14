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
    
   

}
