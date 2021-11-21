//
//  SharedAdsVC.swift
//  foz
//
//  Created by Ahmed Medhat on 21/11/2021.
//

import UIKit

class SharedAdsVC: UIViewController {

    @IBOutlet weak var pageTitleLbl: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var headerAdImage: UIImageView!
    @IBOutlet weak var adsTblView: UITableView!
    
    lazy var viewModel: SharedAdsListViewModel = {
        return SharedAdsListViewModel()
    }()
    
    static var categoryName = ""
    static var categoryId = ""
    static var pageTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageTitleLbl.text = SharedAdsVC.pageTitle
        adsTblView.delegate = self
        adsTblView.dataSource = self
        fetchAdsData()
    }
    
    func fetchAdsData() {
        
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
                                self!.adsTblView.alpha = 0
                                self!.headerAdImage.alpha = 0
                            }
                            
                        case .populated:
                            self!.spinner.stopAnimating()
                            if let adPhoto = self!.viewModel.adsPhotoData {
                                self!.headerAdImage.sd_setImage(with: URL(string: adPhoto.image_url))
                            }
                            UIView.animate(withDuration: 0.5) {
                                self!.adsTblView.alpha = 1
                                self!.headerAdImage.alpha = 1
                            }
                            
                        case .loading:
                            self!.spinner.startAnimating()
                        UIView.animate(withDuration: 0.5) {
                                self!.adsTblView.alpha = 0
                                self!.headerAdImage.alpha = 0
                            
                            }
                        }
                }
            }
            
            viewModel.reloadCollectionViewClousure = { [weak self] () in
                DispatchQueue.main.async {
                    self?.adsTblView.reloadData()
                }
            }
            
        viewModel.initFetchAdsInsideCategoryData(categoryName: SharedAdsVC.categoryName,
            categoryId: SharedAdsVC.categoryId)
        viewModel.initAdsPhoto()
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        AdsInsideCategoryVC.pageTitle = ""
        dismiss(animated: true, completion: nil)
    }
   

}


//MARK: ads section table view
extension SharedAdsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.adsNumberOfCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SharedAdsCell
        cell.layer.cornerRadius = 15
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.sharedAdsListCellViewModel = cellVM
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select")
        tableView.deselectRow(at: indexPath, animated: true)
        AdDetailsVC.adId = "\(viewModel.selectedAd!.id)"
        AdDetailsVC.adVideoUrl = viewModel.selectedAd!.video_url
        let adDetailsVC = UIStoryboard.init(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "ad-details-vc") as! AdDetailsVC
        present(adDetailsVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print("will select")
        viewModel.userPressed(at: indexPath)
        
        if viewModel.isAllowSegue {
            print("allow select")
//            self.performSegue(withIdentifier: "to-ad-details", sender: nil)
            return indexPath
        } else {
            print("not allow select")
            return nil
        }
    }
}
