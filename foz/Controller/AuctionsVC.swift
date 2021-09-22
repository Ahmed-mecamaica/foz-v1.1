//
//  AuctionsVC.swift
//  foz
//
//  Created by Ahmed Medhat on 06/09/2021.
//

import UIKit

class AuctionsVC: UIViewController {

    @IBOutlet weak var inactiveAuctionCollectionView: UICollectionView!
    @IBOutlet weak var soldAuctionCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        inactiveAuctionCollectionView.delegate = self
        inactiveAuctionCollectionView.dataSource = self
        soldAuctionCollectionView.delegate = self
        soldAuctionCollectionView.dataSource = self
        initView()
    }

    
    func initView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: self.soldAuctionCollectionView.frame.width/2 - 50, height: self.soldAuctionCollectionView.frame.height)
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        flowLayout.scrollDirection = .horizontal
        soldAuctionCollectionView.layer.cornerRadius = 10
        inactiveAuctionCollectionView.layer.cornerRadius = 10
        soldAuctionCollectionView.setCollectionViewLayout(flowLayout, animated: true)
        inactiveAuctionCollectionView.setCollectionViewLayout(flowLayout, animated: true)

    }
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension AuctionsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UICollectionViewCell
        return cell
    }

}
