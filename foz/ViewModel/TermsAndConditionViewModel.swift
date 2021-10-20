//
//  TermsAndConditionViewModel.swift
//  foz
//
//  Created by Ahmed Medhat on 17/10/2021.
//

import Foundation

class TermsAndConditionViewModel {
    
    var messageData = ""
    
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMesssage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    func initFetchData(completion: @escaping (String) -> ()) {
        state = .loading
        ClientService.shared.getTermsAndConditions { [weak self] describtion, error in
            guard let self = self else { return }
            if let error = error {
                self.state = .error
                self.alertMesssage = error.localizedDescription
                completion("")
            }
            else {
                self.state = .populated
                completion(describtion)
            }
        }
    }
}
