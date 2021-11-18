//
//  AdsInsideCategoryVC.swift
//  foz
//
//  Created by Ahmed Medhat on 17/11/2021.
//

import UIKit

class AdsInsideCategoryVC: UIViewController {

    @IBOutlet weak var pageTitleLbl: UILabel!
    @IBOutlet weak var headerAdSpinner: UIActivityIndicatorView!
    @IBOutlet weak var headerAdsImage: UIImageView!
    @IBOutlet weak var adsTblView: UITableView!
    
    lazy var viewModel: AdsInsideCategoryViewModel = {
        return AdsInsideCategoryViewModel()
    }()
    static var categoryName = ""
    static var categoryId = ""
    static var pageTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        adsTblView.delegate = self
        adsTblView.dataSource = self
        pageTitleLbl.text = AdsInsideCategoryVC.pageTitle
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
                            self!.headerAdSpinner.stopAnimating()
                        UIView.animate(withDuration: 0.5) {
                                self!.adsTblView.alpha = 0
                                self!.headerAdsImage.alpha = 0
                            }
                            
                        case .populated:
                            self!.headerAdSpinner.stopAnimating()
                            if let adPhoto = self!.viewModel.adsPhotoData {
                                self!.headerAdsImage.sd_setImage(with: URL(string: adPhoto.image_url))
                            }
                            UIView.animate(withDuration: 0.5) {
                                self!.adsTblView.alpha = 1
                                self!.headerAdsImage.alpha = 1
                            }
                            
                        case .loading:
                            self!.headerAdSpinner.startAnimating()
                        UIView.animate(withDuration: 0.5) {
                                self!.adsTblView.alpha = 0
                                self!.headerAdsImage.alpha = 0
                            
                            }
                        }
                }
            }
            
            viewModel.reloadCollectionViewClousure = { [weak self] () in
                DispatchQueue.main.async {
                    self?.adsTblView.reloadData()
                }
            }
            
        viewModel.initFetchAdsInsideCategoryData(categoryName: AdsInsideCategoryVC.categoryName, categoryId: AdsInsideCategoryVC.categoryId)
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
extension AdsInsideCategoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.adsNumberOfCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AdsInsideCategoryCell
        cell.layer.cornerRadius = 15
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.adsInsideCategoryCellViewModel = cellVM
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select")
        tableView.deselectRow(at: indexPath, animated: true)
        AdDetailsVC.adId = "\(viewModel.selectedProvider!.id)"
        AdDetailsVC.adVideoUrl = viewModel.selectedProvider!.video_url
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

//extension AdsInsideCategoryVC {
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let adDetailsVC = segue.destination as? AdDetailsVC, let adData = viewModel.selectedProvider {
//            adDetailsVC.adId = "\(adData.id)"
//            adDetailsVC.adVideoUrl = adData.video_url
////            adDetailsVC.pageTitleLbl = self.pageTitleLbl
//            print("video url \(adData.video_url)")
//        }
//
//    }
//}
