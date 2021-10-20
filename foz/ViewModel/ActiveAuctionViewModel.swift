//
//  ActiveAuctionViewModel.swift
//  foz
//
//  Created by Ahmed Medhat on 26/09/2021.
//

import Foundation


class ActiveAuctionViewModel {
    
    var activeAuctionData: ActiveAuctionResponse?
    var completeWatchingVideoAdResponse: completeWatchingResponse?
    
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
    
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    
    func initFetch(auctionID: String) {
        state = .loading
        ClientService.shared.getActiveAuctionData(auctionId: auctionID) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                self.state = .error
                print(error)
                self.alertMessage = error.localizedDescription
            } else {
               
                self.activeAuctionData = result
                self.state = .populated
            }
        }
    }
    
    func completeWatchingVideoAd(adID: String) {
        state = .loading
        ClientService.shared.completeWatchingVideoAd(adId: adID) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                self.state = .error
                print(error)
                self.alertMessage = error.localizedDescription
            } else {
                self.completeWatchingVideoAdResponse = result
                self.alertMessage = result!.data
                self.state = .populated
            }
        }
    }
    
    
}
