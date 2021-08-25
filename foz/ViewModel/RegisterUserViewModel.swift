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
    
}
