//
//  ContactUsMessageListViewModel.swift
//  foz
//
//  Created by Ahmed Medhat on 14/10/2021.
//

import Foundation

class ContactUsMessageListViewModel {
    
    var messageData: [ContactusMessageArray] = [ContactusMessageArray]()
    var isSend: [String] = [String]()
    private var contactUsMessageCellViewModel: [ContactUsMessageCellViewModel] = [ContactUsMessageCellViewModel]() {
        didSet {
            self.reloadCollectionViewClousure?()
        }
    }
    
    var contactUsMessageNumberOfCell: Int {
        return contactUsMessageCellViewModel.count
    }
    
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
    var reloadCollectionViewClousure: (()->())?
    
//    var selectedSoldAuction: SoldAuctionData?
    func initFetchMessageData() {
        state = .loading
        ClientService.shared.getAllMessage { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                self.state = .error
                self.alertMesssage = error.localizedDescription
            } else {
                self.state = .populated
                self.proccessFetchedSoldAuctionData(data: (result))
            }
        }
    }
    
    func initSendMessage(message: String) {
//        state = .loading
        ClientService.shared.sendMessage(message: message) { [weak self] status, error in
            guard let self = self else { return }
            if let error = error {
//                self.state = .error
                self.alertMesssage = error.localizedDescription
//                completion(false, error)
            } else {
//                self.state = .populated
//                completion(true, nil)
            }
        }
    }
    
    func getCellViewModel(at indesxPath: IndexPath) -> ContactUsMessageCellViewModel {
        return contactUsMessageCellViewModel[indesxPath.row]
    }
    
    func createCellViewModel(data: ContactusMessageArray) -> ContactUsMessageCellViewModel {
        var message: String?
        if data.status == "send" {
            message = "\(data.message) :you"
        }
        else {
            message = "\(data.message) :foz"
        }
        isSend.append(data.status)
        return ContactUsMessageCellViewModel(mesaage: message!, status: data.status)
    }
    
    private func proccessFetchedSoldAuctionData(data: [ContactusMessageArray]) {
        self.messageData = data
        var vms = [ContactUsMessageCellViewModel]()
        for auction in data {
            vms.append(createCellViewModel(data: auction))
        }
        self.contactUsMessageCellViewModel = vms
    }
}
