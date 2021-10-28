//
//  LoginViewModel.swift
//  foz
//
//  Created by Ahmed Medhat on 23/08/2021.
//

import Foundation
import UIKit
class LoginViewModel {
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var isAllowSegue: Bool = false
    var isNewUser: String?
    
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    func initLogin(phoneNum: String) {
        state = .loading
        AuthService.instance.login(phoneNum: phoneNum) { [weak self] status, error in
            guard let self = self else {
                return
                
            }
            if phoneNum == "" {
                self.alertMessage = "يرجى إدخال رقم جوال صحيح"
            }
            
            if let error = error {
                self.state = .error
//                self.isAllowSegue = false
                self.alertMessage = error.localizedDescription
            }
            else {
//                self.isAllowSegue = true
                self.isNewUser = status
                self.state = .populated
                self.updateLoadingStatus?()
            }
        }
    }
}
