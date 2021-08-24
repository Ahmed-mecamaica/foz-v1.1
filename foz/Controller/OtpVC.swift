//
//  OtpVC.swift
//  foz
//
//  Created by Ahmed Medhat on 23/08/2021.
//

import UIKit

class OtpVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var verifyBtn: RoundedButton!
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tf3: UITextField!
    @IBOutlet weak var tf4: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: OtpViewModel = {
        return OtpViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tf1.delegate = self
        tf2.delegate = self
        tf3.delegate = self
        tf4.delegate = self
//        tf1.addTarget(self, action: #selector(textDidChange(textField:)), for: UIControl.Event.editingChanged)
//        tf2.addTarget(self, action: #selector(textDidChange(textField:)), for: UIControl.Event.editingChanged)
//        tf3.addTarget(self, action: #selector(textDidChange(textField:)), for: UIControl.Event.editingChanged)
//        tf3.addTarget(self, action: #selector(textDidChange(textField:)), for: UIControl.Event.editingChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tf1.becomeFirstResponder()
    }
    
    @IBAction func verifyBtnPressed(_ sender: Any) {
        let otp: String = self.tf1.text! + self.tf2.text! + self.tf3.text! + self.tf4.text!
        viewModel.showAlertMessage = { [weak self] in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert(message: message)
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                switch self!.viewModel.state {
                case .empty, .error:
                    self?.activityIndicator.stopAnimating()
                case .loading:
                    self?.activityIndicator.startAnimating()
                case .populated:
                    self?.activityIndicator.stopAnimating()
                    if self!.viewModel.isNewUser == "True" {
                        let storyboard = UIStoryboard(name: "Main", bundle: .main)
                        let otpVC = storyboard.instantiateViewController(identifier: "register-new_user")
                        self?.present(otpVC, animated: true, completion: nil)
                    } else {
                        self?.showAlert(message: "done")
                    }
                }
            }
        }
        
        viewModel.initSendOtp(otp: otp)
    }
    
    
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "تنبية", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "موافق", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}

extension OtpVC {
    //make the text field contain only one character
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let maxLength = 1
//        let currentString: NSString = (textField.text ?? "") as NSString
//        let newString: NSString =
//            currentString.replacingCharacters(in: range, with: string) as NSString
//        return newString.length <= maxLength
//    }
    
//    @objc func textDidChange(textField: UITextField) {
//        let text = textField.text
//        if text?.utf16.count == 1 {
//            switch textField {
//            case tf1:
//                tf2.becomeFirstResponder()
//                break
//            case tf2:
//                tf3.becomeFirstResponder()
//                break
//            case tf3:
//                tf4.becomeFirstResponder()
//                break
//            case tf4:
//                tf4.resignFirstResponder()
//                break
//            default:
//                break
//            }
//        }
//    }
    
    
    //set character count = 1 and when txt field take its character change responder to next txt field
    //and when deleting change to previose tx field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string.count == 1) {
            if textField == tf1 {
           tf2?.becomeFirstResponder()
       }
       if textField == tf2 {
           tf3?.becomeFirstResponder()
       }
       if textField == tf3 {
           tf4?.becomeFirstResponder()
       }
       if textField == tf4 {
           tf4?.resignFirstResponder()
           textField.text? = string
            //APICall Verify OTP
           //Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.VerifyOTPAPI), userInfo: nil, repeats: false)
       }
       textField.text? = string
       return false
        } else {
            if textField == tf1 {
           tf1?.becomeFirstResponder()
           }
           if textField == tf2 {
               tf1?.becomeFirstResponder()
           }
           if textField == tf3 {
               tf2?.becomeFirstResponder()
           }
           if textField == tf4 {
               tf3?.becomeFirstResponder()
           }
           textField.text? = string
           return false
        }
    }
}
