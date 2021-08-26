//
//  InterestsVC.swift
//  foz
//
//  Created by Ahmed Medhat on 26/08/2021.
//

import UIKit

class InterestsVC: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var interestCollectionView: UICollectionView!
    
    let viewModel: InterestListViewModel = {
        return InterestListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        interestCollectionView.delegate = self
        interestCollectionView.dataSource = self
        intitVm()
    }
    
    func intitVm() {
        viewModel.showAlertClosure = {[weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert(message: message)
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            guard  let self = self else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                switch self.viewModel.state{
                case .error, .empty:
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.interestCollectionView.alpha = 0.0
                    })
                case .loading:
                    self.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.interestCollectionView.alpha = 0.0
                    })
                case .populated:
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.interestCollectionView.alpha = 1.0
                    })
                }
            }
        }
    }
    
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "تنبية", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "موافق", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
}

extension InterestsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! InterestCollectionViewCell
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.interestListCellViewModel = cellVM
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        <#code#>
//    }
}
