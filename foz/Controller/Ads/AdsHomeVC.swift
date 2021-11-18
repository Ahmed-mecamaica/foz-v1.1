//
//  AdsHomeVC.swift
//  foz
//
//  Created by Ahmed Medhat on 17/11/2021.
//

import UIKit
import SDWebImage

class AdsHomeVC: UIViewController {

    @IBOutlet weak var headerAdSpinner: UIActivityIndicatorView!
    @IBOutlet weak var headerAdImage: UIImageView!
    
    @IBOutlet weak var adsSectionsTblView: UITableView!
    
    @IBOutlet weak var adsCategoryHolderView: CurveShadowView!
    @IBOutlet weak var categorySpinner: UIActivityIndicatorView!
    @IBOutlet weak var adsCategoryCollectionView: UICollectionView!
    
    lazy var viewModel: CategoryListViewModel = {
        return CategoryListViewModel()
    }()
    
    var adSectionName = ["الشراء من المعلنين", "الإعلانات اليومية"]
    var adSectionImageName = ["buy-from-provider", "daily-ads"]
    var categorytype = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        adsSectionsTblView.delegate = self
        adsSectionsTblView.dataSource = self
        adsCategoryCollectionView.delegate = self
        adsCategoryCollectionView.dataSource = self
        initViewForCollectionView()
        getHeaderAdPhoto()
    }
    
    //this func make customization for category collection view
    func initViewForCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: adsCategoryCollectionView.frame.width/2 - 20, height: adsCategoryCollectionView.frame.width/2 - 20)
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
//        flowLayout.scrollDirection = .
        self.adsCategoryCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
    
    //this func fetch header ad photo
    func getHeaderAdPhoto() {
        viewModel.showAlertClosure = { [weak self] in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMesssage {
                    self?.showAlert(message)
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                switch self!.viewModel.state {
                    case .empty, .error:
                        self!.headerAdSpinner.stopAnimating()
                        UIView.animate(withDuration: 0.5) {
                            self!.headerAdImage.alpha = 0
                        }
                        
                    case .populated:
                        self!.headerAdSpinner.stopAnimating()
                        self?.headerAdImage.sd_setImage(with: URL(string: self!.viewModel.adsPhotoData!.image_url))
                        UIView.animate(withDuration: 0.5) {
                            self!.headerAdImage.alpha = 1
                        }
                        
                    case .loading:
                        self!.headerAdSpinner.startAnimating()
                        UIView.animate(withDuration: 0.5) {
                            self!.headerAdImage.alpha = 0
                        }
                    }
            }
        }
        
//        viewModel.reloadCollectionViewClousure = { [weak self] () in
//            DispatchQueue.main.async {
//                self?.providerListCollectionView.reloadData()
//            }
//        }
        
        viewModel.initAdsPhoto()
    }
    
    func fetchCategoryData(categoryname: String) {
        
            viewModel.showAlertClosure = { [weak self] in
                DispatchQueue.main.async {
                    if let message = self?.viewModel.alertMesssage {
                        self?.showAlert(message)
                    }
                }
            }
            
            viewModel.updateLoadingStatus = { [weak self] in
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async { [weak self] in
                    switch self!.viewModel.state {
                        case .empty, .error:
                            self!.categorySpinner.stopAnimating()
                        UIView.animate(withDuration: 0.5) {
                                self!.adsCategoryHolderView.alpha = 1
                                self!.adsCategoryCollectionView.alpha = 0
                            }
                            
                        case .populated:
                            self!.categorySpinner.stopAnimating()
                        UIView.animate(withDuration: 0.5) {
                                self!.adsCategoryHolderView.alpha = 1
                                self!.adsCategoryCollectionView.alpha = 1
                            }
                            
                        case .loading:
                            self!.categorySpinner.startAnimating()
                        UIView.animate(withDuration: 0.5) {
                                self!.adsCategoryHolderView.alpha = 1
                                self!.adsCategoryCollectionView.alpha = 0
                            }
                        }
                }
            }
            
            viewModel.reloadCollectionViewClousure = { [weak self] () in
                DispatchQueue.main.async {
                    self?.adsCategoryCollectionView.reloadData()
                }
            }
            
            viewModel.initFetchCategoryData(categoryName: categoryname)
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func exitBtnInsideCategoryView(_ sender: Any) {
        AdsInsideCategoryVC.categoryId = ""
        AdsInsideCategoryVC.categoryName = ""
        categorytype = ""
        adsCategoryHolderView.alpha = 0
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: ads section table view
extension AdsHomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adSectionName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AdsHomeCell
        cell.sectionBackgroundImage.image = UIImage(named: adSectionImageName[indexPath.row])
        cell.sectionNameLbl.text = adSectionName[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((adsSectionsTblView.frame.height/2) - 25)
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            //TODO:
//            fetchCategoryData(categoryname: "share")
//            AdsInsideCategoryVC.categoryName = "share"
            showAlert("THIS SECTION WILL BE READY SOON...")
            categorytype = "share"
        }
        else {
            
            fetchCategoryData(categoryname: "paid")
            AdsInsideCategoryVC.categoryName = "paid"
            categorytype = "paid"
        }
    }
}

//MARK: category collection view
extension AdsHomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number of cell is \(viewModel.categoryNumberOfCell)")
        return viewModel.categoryNumberOfCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? AdsCategoryCell else {
            fatalError("Cell not exists in storyboard")
        }
//        cell.layer.cornerRadius = 10
//        cell.layer.borderColor = #colorLiteral(red: 0.0002558765991, green: 0.6109670997, blue: 0.5671326518, alpha: 0.1674372187)
//        cell.layer.borderWidth = 2
        
        let cellvm = viewModel.getCellViewModel(at: indexPath)
        cell.categoryListCellViewModel = cellvm
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

//        let providerCouponsVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "provider_coupons_vc") as! ProviderCouponsVC
        self.viewModel.userPressed(at: indexPath)
        
        if viewModel.isAllowSegue, categorytype == "paid" {
            AdsInsideCategoryVC.pageTitle = viewModel.selectedcategory!.name
            AdsInsideCategoryVC.categoryId = "\(viewModel.selectedcategory!.id)"
            let adsImsideCategoryVC = storyboard?.instantiateViewController(withIdentifier: "ads-inside-category") as! AdsInsideCategoryVC
            present(adsImsideCategoryVC, animated: true, completion: nil)
        }
        //TODO:
//        else if viewModel.isAllowSegue, categorytype == "paid" {
//
//        }
        
//        let selectedCategory = viewModel.selectedProvider
//        ProviderCouponsVC.providerID = "\(selectedCategory!.id)"
//        ProviderCouponsVC.providerImageUrl = selectedCategory!.image_url
//        present(providerCouponsVC, animated: true, completion: nil)
//        print("data passed successfully and provider id is \()")

    }
    
    
    
}
