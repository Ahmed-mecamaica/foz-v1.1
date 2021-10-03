//
//  OffersVC.swift
//  foz
//
//  Created by Ahmed Medhat on 03/10/2021.
//

import UIKit

class OffersVC: UIViewController {

    @IBOutlet weak var offersCollectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        offersCollectionView.delegate = self
        offersCollectionView.dataSource = self
        initView()
    }
    
    func initView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: offersCollectionView.frame.width/2 - 20, height: offersCollectionView.frame.width/2 - 20)
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        offersCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
    
}

extension OffersVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OffersCell
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        <#code#>
//    }
}
