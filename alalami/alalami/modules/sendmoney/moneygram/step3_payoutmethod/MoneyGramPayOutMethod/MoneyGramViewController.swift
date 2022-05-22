//
//  MoneyGramViewController.swift
//  alalami
//
//  Created by Osama Abu Hdba on 10/11/2021.
//  Copyright © 2021 technzone. All rights reserved.
//

import UIKit

class MoneyGramViewController: BaseVC {
    
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = makeLayout()
        let cellNip = UINib(nibName: "MoneyGramCollectionViewCell", bundle: nil)
        collectionView.register(cellNip, forCellWithReuseIdentifier: "MoneyGramCollectionViewCell")
    }
}

extension MoneyGramViewController:  UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(cellClass: MoneyGramCollectionViewCell.self, for: indexPath)
        cell.imageView.backgroundColor = .blue
        cell.backgroundColor = .red
        cell.titleLabel.text = "OSama"
        
        return cell
    }
}
extension MoneyGramViewController {
    func makeLayout() -> UICollectionViewLayout {

        // Full
        let fullPhotoItem = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(2/3)))
        fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        // Main with pair
        let mainItem = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(2/3),
            heightDimension: .fractionalHeight(1.0)))
        mainItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        let pairItem = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5)))
        pairItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let trailingGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1.0)),
          subitem: pairItem,
          count: 2)

        let mainWithPairGroup = NSCollectionLayoutGroup.horizontal(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(4/9)),
          subitems: [mainItem, trailingGroup])

        // Triplet
        let tripletItem = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1.0)))
        tripletItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        let tripletGroup = NSCollectionLayoutGroup.horizontal(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(2/9)),
          subitems: [tripletItem, tripletItem, tripletItem])

        // Reversed main with pair
        let mainWithPairReversedGroup = NSCollectionLayoutGroup.horizontal(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(4/9)),
          subitems: [trailingGroup, mainItem])

        let nestedGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(16/9)),
          subitems: [fullPhotoItem, mainWithPairGroup, tripletGroup, mainWithPairReversedGroup])

        let section = NSCollectionLayoutSection(group: nestedGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
