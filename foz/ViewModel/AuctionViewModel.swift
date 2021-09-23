//
//  AuctionViewModel.swift
//  foz
//
//  Created by Ahmed Medhat on 22/09/2021.
//

import Foundation

class AuctionViewModel {
    
    
    var ActiveUctionData: ActiveAuctionsData?
    
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
    
    func initData() {
        state = .loading
        ClientService.shared.getAllAuctionsData { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                self.state = .error
                self.alertMesssage = error.localizedDescription
            } else {
                self.state = .populated
                self.ActiveUctionData = result?.data
            }
        }
    }
}
