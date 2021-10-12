//
//  OtpViewModel.swift
//  foz
//
//  Created by Ahmed Medhat on 24/08/2021.
//

import Foundation

class OtpViewModel {
    
    
    var alertMessage: String? {
        didSet{
            showAlertMessage?()
        }
    }
    
    var state: State = .empty {
        didSet{
            self.updateLoadingStatus?()
        }
    }
    
    var isNewUser: String?
    
    var showAlertMessage: (()->())?
    var updateLoadingStatus: (()->())?
    
    func initSendOtp(otp: String) {
        state = .loading
        AuthService.instance.sendOtp(otp: otp) { isNewUser, error in
            
            if otp == "" {
                self.state = .empty
                self.alertMessage = "يرجى إدخال رمز صحيح"
            }
            else if error == nil {
                self.isNewUser = isNewUser
                self.state = .populated
            } else {
                self.state =  .error
                self.alertMessage = error?.localizedDescription
            }
        }
    }
    
    func setFcmToken(fcm_token: String) {
        AuthService.instance.postFcm(fcmtoken: fcm_token) { (success, error) in
            if success {
            } else {
            }
        }
    }
}
