//
//  InviteFriendVC.swift
//  foz
//
//  Created by Ahmed Medhat on 28/11/2021.
//

import UIKit

class InviteFriendVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomTxtFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var friendNumLbl: UILabel!
    @IBOutlet weak var pointNumLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var adImage: UIImageView!
    @IBOutlet weak var copyInvitationCodeBtn: UIButton!
    @IBOutlet weak var invitationCodeLbl: UILabel!
    
    @IBOutlet weak var inviteFriendForWinLbl: UILabel!
    @IBOutlet weak var invitationCodeTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        copyInvitationCodeBtn.layer.borderWidth = 0.8
        copyInvitationCodeBtn.layer.borderColor = #colorLiteral(red: 0.9935509562, green: 0.6762151718, blue: 0, alpha: 1)
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func inviteBtnPressed(_ sender: Any) {
        
        let firstActivityItem = "https://apps.apple.com/eg/app/foz-sa/id1489157094"
        // If you want to use an image
//        let image : UIImage = UIImage(named: "1024")!
//        let image2 : UIImage = UIImage(named: "1024")!

        let activityViewController : UIActivityViewController = UIActivityViewController(
            // you must share variables have the same type
            activityItems: [firstActivityItem], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
//        activityViewController.popoverPresentationController?.sourceView = (sender )
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Pre-configuring activity items
        if #available(iOS 13.0, *) {
            activityViewController.activityItemsConfiguration = [
                UIActivity.ActivityType.message
            ] as? UIActivityItemsConfigurationReading
        } else {
            // Fallback on earlier versions
        }
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.postToFacebook
        ]
        
        if #available(iOS 13.0, *) {
            activityViewController.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func copyInvitationCodeBtnPressed(_ sender: Any) {
        UIPasteboard.general.string = invitationCodeLbl.text
        showAlert("invitation code copy to clipboard")
    }
    
    @IBAction func doneBtnInsideTextFieldPressed(_ sender: Any) {
        
    }
    
    @objc func keyboardWillShow(notification: Notification) {

        let keyboardSize = (notification.userInfo?  [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue

         let keyboardHeight = keyboardSize?.height

         if #available(iOS 11.0, *){

            self.bottomTxtFieldConstraint.constant = 319//keyboardHeight! - view.safeAreaInsets.bottom
             let bottomOffset = CGPoint(x: 0, y:  keyboardHeight! - 190)
             scrollView.setContentOffset(bottomOffset, animated: true)
             

          }
          else {
            self.bottomTxtFieldConstraint.constant = 319//keyboardHeight! - view.safeAreaInsets.bottom
           //view.safeAreaInsets.bottom
              let bottomOffset = CGPoint(x: 0, y:  keyboardHeight! - 190)
              scrollView.setContentOffset(bottomOffset, animated: true)
             }

           UIView.animate(withDuration: 0.5) {

              self.view.layoutIfNeeded()

           }
       }

      @objc func keyboardWillHide(notification: Notification){

        self.bottomTxtFieldConstraint.constant = 250
          let bottomOffset = CGPoint(x: 0, y:  0)
          scrollView.setContentOffset(bottomOffset, animated: true)

           UIView.animate(withDuration: 0.5) {

              self.view.layoutIfNeeded()

           }

      }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
