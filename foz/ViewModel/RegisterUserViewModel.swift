//
//  RegisterUserViewModel.swift
//  foz
//
//  Created by Ahmed Medhat on 24/08/2021.
//

import Foundation

class RegisterUserViewModel {
    
    var incomelevels: [DropListData] = [DropListData]()
    var cities: [DropListData] = [DropListData]()
    var state: State = .empty {
        didSet{
            self.updateLoadingState?()
        }
    }
    
    var alertMessage: String? {
        didSet{
            self.showAlertClosure?()
        }
    }
    
    var showAlertClosure: (()->())?
    var updateLoadingState: (()->())?
    
    func initIncomeLevels() {
        state = .loading
        AuthService.instance.IncomeLevels(completion: { incomelevels, error in
            if error == nil {
                self.incomelevels = incomelevels
                self.state = .populated
                self.updateLoadingState?()
            }
            else {
                self.state = .error
                self.alertMessage = error?.localizedDescription
            }
        })
    }
    
    func initCities() {
        state = .loading
        AuthService.instance.cities(completion: { incomelevels, error in
            if error == nil {
                self.cities = incomelevels
                self.state = .populated
                self.updateLoadingState?()
            }
            else {
                self.state = .error
                self.alertMessage = error?.localizedDescription
            }
        })
    }
    
    func initSignupUser(userName: String, birthDate: String, city: String, gender: String, incomeLevel: String) {
        state = .loading
        if userName == "" || birthDate == "" || city == "" || gender == "" || incomeLevel == "" {
            self.state = .empty
            self.alertMessage = "ماتشغلش دماغك وإملا كل الخانات اللي قدامك ديه"
        } else {
            AuthService.instance.registerUser(userName: userName, birthDate: birthDate, gender: gender, city: city, incomeLevel: incomeLevel) { Status, error in
            if error == nil {
                if Status == "Success" {
                    self.state = .populated
                } else {
                    self.state = .error
                    self.alertMessage = "عندي انا الغلط ده غير الاسم كده عشان تقريبا حد واخد الاسم ده"
                }
            }
            else {
                self.state = .error
                self.alertMessage = error?.localizedDescription
            }
        }}
        
    }
    
}
