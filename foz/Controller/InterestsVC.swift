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
    
    var selectedIndex = 0
    var selectedRowIndex = -1
    var thereIsCellHasSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        interestCollectionView.delegate = self
        interestCollectionView.dataSource = self
        initView()
        intitVm()
    }
    
    func initView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: interestCollectionView.frame.width/3 - 40, height: 120)
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
//        flowLayout.scrollDirection = .
        self.interestCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
    
    @objc func changeRadioBtnStatus(_ sender: UIButton) {
        if sender.backgroundImage(for: .normal) == UIImage(named: "empty-radio-button") {
            sender.setBackgroundImage(UIImage(named: "checked-radio-button"), for: .normal)
//            print(viewModel.photos[sender.tag].name)
        } else {
            sender.setBackgroundImage(UIImage(named: "empty-radio-button"), for: .normal)
        }
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
        
        viewModel.reloadCollectionViewClousure = { [weak self] () in
            DispatchQueue.main.async {
                self?.interestCollectionView.reloadData()
            }
        }
        viewModel.initFetch()
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        let homevc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "otp_view_controller")
        present(homevc, animated: true, completion: nil)
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
        cell.radioBtn.tag = indexPath.row
        cell.radioBtn.setBackgroundImage(UIImage(named: "empty-radio-button"), for: .normal)
        cell.radioBtn.addTarget(self, action: #selector(changeRadioBtnStatus(_:)), for: .touchUpInside)
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.interestListCellViewModel = cellVM
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        selectedIndex = indexPath.row
//        if self.selectedRowIndex != -1 {
//            self.interestCollectionView.cellForItem(at: NSIndexPath(row: self.selectedRowIndex, section: 0) as IndexPath)?.backgroundColor = UIColor.white
//        }
//
//        if selectedRowIndex != indexPath.row {
//            self.thereIsCellHasSelected = true
//            self.selectedRowIndex = indexPath.row
//        } else {
//            self.thereIsCellHasSelected = false
//            self.selectedRowIndex = -1
//        }
//
//
//    }
}
