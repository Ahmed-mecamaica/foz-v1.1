//
//  CategoryListViewModel.swift
//  foz
//
//  Created by Ahmed Medhat on 17/11/2021.
//

import Foundation

class CategoryListViewModel {
    
    var adsPhotoData: DefaultAdsData?
    
    var adsCategoryData: [AdsCategoryData] = [AdsCategoryData]()
    
    private var categoryListCellViewModel: [CategoryListCellViewModel] = [CategoryListCellViewModel]() {
        didSet {
            self.reloadCollectionViewClousure?()
        }
    }
    
    var categoryNumberOfCell: Int {
        return categoryListCellViewModel.count
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
    
    var isAllowSegue: Bool = false
    var selectedcategory: AdsCategoryData?

    
    func initFetchCategoryData(categoryName: String) {
        state = .loading
        ClientService.shared.fetchAdsCategory(categoryName: categoryName) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                self.state = .error
                self.alertMesssage = error.localizedDescription
            } else {
                self.state = .populated
                self.proccessFetchedCategoryData(data: result!.data)
            }
        }
    }
    
    func initAdsPhoto() {
        state = .loading
        ClientService.shared.getAdsPhoto { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                self.state = .error
                self.alertMesssage = error.localizedDescription
            } else {
                self.state = .populated
                self.adsPhotoData = result?.data
            }
        }
    }
    
    func getCellViewModel(at indesxPath: IndexPath) -> CategoryListCellViewModel {
        return categoryListCellViewModel[indesxPath.row]
    }
    
    func createCellViewModel(data: AdsCategoryData) -> CategoryListCellViewModel {
        return CategoryListCellViewModel(categoryId: data.id, ctegoryBackgroundImage: data.image_url, categoryName: data.name, adsInsideCategoryNum: data.ads_count)
    }
    
    private func proccessFetchedCategoryData(data: [AdsCategoryData]) {
        self.adsCategoryData = data
        var vms = [CategoryListCellViewModel]()
        for provider in data {
            vms.append(createCellViewModel(data: provider))
        }
        self.categoryListCellViewModel = vms
    }
}

extension CategoryListViewModel {
    func userPressed(at indexPath: IndexPath) {
        let category = self.adsCategoryData[indexPath.row]
        if category.ads_count != 0 {
            self.selectedcategory = category
            self.isAllowSegue = true
        }
        else {
            self.isAllowSegue = false
            self.selectedcategory = nil
            self.alertMesssage = "no ad here right now"
        }
        
    }
}
