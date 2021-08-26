//
//  InterestListViewModel.swift
//  foz
//
//  Created by Ahmed Medhat on 26/08/2021.
//

import Foundation
class InterestListViewModel {
    
    
    
    private var photos: [InterestsPhoto] = [InterestsPhoto]()
    
    //cotainer of all cell
    private var cellViewModel: [InterestListCellViewModel] = [InterestListCellViewModel]() {
        didSet {
            self.reloadCollectionViewClousure?()
        }
    }
    
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var numberOfCell: Int {
        return cellViewModel.count
    }
    
    var reloadCollectionViewClousure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var selectedPhoto: InterestsPhoto?
    
    func initFetch() {
        state = .loading
        AuthService.instance.userInterests { [weak self] photos, error in
            guard let self = self else {
                return
            }
            guard error == nil else {
                self.state = .error
                self.alertMessage = error?.localizedDescription
                return
            }
            self.proccessFetchedPhoto(photos: photos)
            self.state = .populated
        }
        
    }
    
    func getCellViewModel(at indesxPath: IndexPath) -> InterestListCellViewModel {
        return cellViewModel[indesxPath.row]
    }
    
    func createCellViewModel(photo: InterestsPhoto) -> InterestListCellViewModel {
        return InterestListCellViewModel(title: photo.name, image_url: photo.image_url)
    }
    
    private func proccessFetchedPhoto(photos: [InterestsPhoto]) {
        self.photos = photos
        var vms = [InterestListCellViewModel]()
        for photo in photos {
            vms.append(createCellViewModel(photo: photo))
        }
        self.cellViewModel = vms
    }
}

extension InterestListViewModel {
//    func userPressed(at indexPath: IndexPath) -> InterestListCellViewModel {
//        let photo = self.photos[indexPath.row]
//        return InterestListCellViewModel(title: <#T##String#>, image_url: <#T##String#>, radioBtnImage: UIImage(named: ""))
//    }
}
