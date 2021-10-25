//
//  OffersCategoryVC.swift
//  foz
//
//  Created by Ahmed Medhat on 03/10/2021.
//

import UIKit
import SDWebImage

class OffersCategoryVC: UIViewController {

    @IBOutlet weak var offerCategoryTblView: UITableView!
    @IBOutlet weak var providerListView: CurveShadowView!
    @IBOutlet weak var providerListCollectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var headerAdPhoto: UIImageView!
    @IBOutlet weak var headerAdSpinner: UIActivityIndicatorView!
    
    lazy var viewModel: ProvidersListViewModel = {
        return ProvidersListViewModel()
    }()
    
    var categoryName = ["مطاعم", "كافيهات"]
    var categoryImageName = ["offer_category_one", "offers_category_two"]
    override func viewDidLoad() {
        super.viewDidLoad()

        offerCategoryTblView.delegate = self
        offerCategoryTblView.dataSource = self
        providerListCollectionView.delegate = self
        providerListCollectionView.dataSource = self
        initView()
        getHeaderAdPhoto()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.5) {
            self.offerCategoryTblView.alpha = 1
        }
    }
    
    func initView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: providerListCollectionView.frame.width/2 - 20, height: providerListCollectionView.frame.width/2 - 20)
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
//        flowLayout.scrollDirection = .
        self.providerListCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
    
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
                            self!.headerAdPhoto.alpha = 0
                        }
                        
                    case .populated:
                        self!.headerAdSpinner.stopAnimating()
                        self?.headerAdPhoto.sd_setImage(with: URL(string: self!.viewModel.adsPhotoData!.image_url))
                        UIView.animate(withDuration: 0.5) {
                            self!.headerAdPhoto.alpha = 1
                        }
                        
                    case .loading:
                        self!.headerAdSpinner.startAnimating()
                        UIView.animate(withDuration: 0.5) {
                            self!.headerAdPhoto.alpha = 0
                        }
                    }
            }
        }
        
        viewModel.reloadCollectionViewClousure = { [weak self] () in
            DispatchQueue.main.async {
                self?.providerListCollectionView.reloadData()
            }
        }
        
        viewModel.initAdsPhoto()
    }
    
    func initResturantProvidersData() {
        
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
                            self!.spinner.stopAnimating()
                        UIView.animate(withDuration: 0.5) {
                                self!.providerListView.alpha = 1
                                self!.providerListCollectionView.alpha = 0
                            }
                            
                        case .populated:
                            self!.spinner.stopAnimating()
                        UIView.animate(withDuration: 0.5) {
                                self!.providerListView.alpha = 1
                                self!.providerListCollectionView.alpha = 1
                            }
                            
                        case .loading:
                            self!.spinner.startAnimating()
                        UIView.animate(withDuration: 0.5) {
                                self!.providerListView.alpha = 1
                                self!.providerListCollectionView.alpha = 0
                            }
                        }
                }
            }
            
            viewModel.reloadCollectionViewClousure = { [weak self] () in
                DispatchQueue.main.async {
                    self?.providerListCollectionView.reloadData()
                }
            }
            
            viewModel.initProviderData(query: "مطاعم")
    }
    
    func initCafeProviderData() {
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
                        self!.spinner.stopAnimating()
                    UIView.animate(withDuration: 0.5) {
                            self!.providerListView.alpha = 1
                            self!.providerListCollectionView.alpha = 0
                        }
                        
                    case .populated:
                        self!.spinner.stopAnimating()
                    UIView.animate(withDuration: 0.5) {
                            self!.providerListView.alpha = 1
                            self!.providerListCollectionView.alpha = 1
                        }
                        
                    case .loading:
                        self!.spinner.startAnimating()
                    UIView.animate(withDuration: 0.5) {
                            self!.providerListView.alpha = 1
                            self!.providerListCollectionView.alpha = 0
                        }
                    }
            }
        }
        
        viewModel.reloadCollectionViewClousure = { [weak self] () in
            DispatchQueue.main.async {
                self?.providerListCollectionView.reloadData()
            }
        }
        
        viewModel.initProviderData(query: "كافيهات")
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func hideProviderViewBtnTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.providerListView.alpha = 0
        }
    }
}

extension OffersCategoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! OfferCategoryCell
        cell.categoryImage.image = UIImage(named: categoryImageName[indexPath.row])
        cell.categoryNameLbl.text = categoryName[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((offerCategoryTblView.frame.height/2) - 25)
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            initResturantProvidersData()
        }
        else {
            initCafeProviderData()
        }
    }
}

extension OffersCategoryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.providerNumberOfCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProvidersListCell else {
            fatalError("Cell not exists in storyboard")
        }
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = #colorLiteral(red: 0.0002558765991, green: 0.6109670997, blue: 0.5671326518, alpha: 0.1674372187)
        cell.layer.borderWidth = 2
        
        let cellvm = viewModel.getCellViewModel(at: indexPath)
        cell.providersListCellViewModel = cellvm
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let providerCouponsVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "provider_coupons_vc") as! ProviderCouponsVC
        self.viewModel.userPressed(at: indexPath)
        let selectedProvider = viewModel.selectedProvider
        ProviderCouponsVC.providerID = "\(selectedProvider!.id)"
        ProviderCouponsVC.providerImageUrl = selectedProvider!.image_url
        present(providerCouponsVC, animated: true, completion: nil)
//        print("data passed successfully and provider id is \()")

    }
    
    
    
}

extension OffersCategoryVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ProviderCouponsVC, let selectedProvider = viewModel.selectedProvider {
            print("data passed successfully and provider id is \(selectedProvider.id)")
            
        }
    }
}
