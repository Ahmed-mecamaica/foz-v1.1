//
//  InactiveAuctionsVC.swift
//  foz
//
//  Created by Ahmed Medhat on 28/09/2021.
//

import UIKit

class InactiveAuctionsVC: UIViewController {

    @IBOutlet weak var auctionsCollectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    lazy var viewModel: InactiveAuctionsListViewModel = {
        return InactiveAuctionsListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        auctionsCollectionView.delegate = self
        auctionsCollectionView.dataSource = self
        initView()
        initFetchData()
    }
    
    func initView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: auctionsCollectionView.frame.width/2 - 40, height: 300)
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        auctionsCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
    
    func initFetchData() {
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
                        UIView.animate(withDuration: 2) {
                            self!.auctionsCollectionView.alpha = 0
                            
                        }
                        
                    case .populated:
                        self!.spinner.stopAnimating()
                        UIView.animate(withDuration: 2) {
                            self!.auctionsCollectionView.alpha = 1
                        }
                        
                    case .loading:
                        self!.spinner.startAnimating()
                        UIView.animate(withDuration: 2) {
                            self!.auctionsCollectionView.alpha = 0
                        }
                    }
            }
        }
        
        viewModel.reloadCollectionViewClousure = { [weak self] () in
            DispatchQueue.main.async {
                self?.auctionsCollectionView.reloadData()
            }
        }
        
        viewModel.initData()
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension InactiveAuctionsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.inactiveAuctionNumberOfCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! InactiveAuctionsCell
        cell.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        let cellvm = viewModel.getCellViewModel(at: indexPath)
        cell.inactiveAuctionCellViewModel = cellvm
        return cell
    }
    
   
}
