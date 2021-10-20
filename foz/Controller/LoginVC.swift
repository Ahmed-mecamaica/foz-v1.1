//
//  LoginVC.swift
//  foz
//
//  Created by Ahmed Medhat on 16/08/2021.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginBtn: RoundedButton!
    @IBOutlet weak var phoneNumTxtField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var viewModel: LoginViewModel = {
        return LoginViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumTxtField.delegate = self
        phoneNumTxtField.attributedPlaceholder = NSAttributedString(string: "رقم الجوال", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(cgColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))])
        
        UIView.animate(withDuration: 2.0) {
            self.loginBtn.alpha = 1
        }
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        phoneNumTxtField.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    @IBAction func loginBtnPresssed(_ sender: Any) {
        viewModel.showAlertClosure = { [weak self] in
            
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                self?.showAlert(message)
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                switch self!.viewModel.state {
                case .loading:
                    self?.activityIndicator.startAnimating()
                case .populated:
                    self?.activityIndicator.stopAnimating()
                    let storyboard = UIStoryboard(name: "Main", bundle: .main)
                    let otpVC = storyboard.instantiateViewController(identifier: "otp_view_controller")
                    self?.present(otpVC, animated: true, completion: nil)
                    
                case .error, .empty:
                    self?.activityIndicator.stopAnimating()
                }
            }
            
        }
        
        viewModel.initLogin(phoneNum: phoneNumTxtField.text ?? "") 
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

}
