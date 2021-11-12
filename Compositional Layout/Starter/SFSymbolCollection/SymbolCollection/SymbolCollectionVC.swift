//
//  CollectionVC.swift
//  SFSymbolCollection
//
//  Created by Michael Lin on 2/22/21.
//

import UIKit

class SymbolCollectionVC: UIViewController {
    
    typealias Section = SymbolCategories
    
    var dataSource: UICollectionViewDiffableDataSource
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }

}

extension SymbolCollectionVC {
    func configureViews() {
        let layout = createLayout()
        collectionView = UICollectionView(frame: view.bounds.inset(by: UIEdgeInsets(top: 88, left: 0, bottom: 0, right: 0)), collectionViewLayout:  layout)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return
        UICollectionViewCompositionalLayout (sectionProvider: { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let category = Section(index: sectionIndex) else {
                fatalError("Unknown section kind")
            }
            
            let itemsPerRow = 4
            let rowHeight: CGFloat = 70
            let rowSpacing: CGFloat = 35
            let headEstimatedHeight: CGFloat = 44
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(CGFloat(1/itemsPerRow)), heightDimension: .absolute(rowHeight)))
            
            let row = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(rowHeight)), subitems: [item])
            
            let numRows = category.numberOfRows()
            let rowGroupEstimatedHeight = CGFloat(CGFloat(numRows) * rowHeight) + CGFloat((CGFloat(numRows) - 1) * rowSpacing)
            
            let rowGroup = NSCollectionLayoutGroup.vertical(layoutSize:NSCollectionLayoutSize(widthDimension: .fractionalHeight(1.0), heightDimension: .estimated(rowGroupEstimatedHeight)), subitem: row, count: numRows)
            rowGroup.interItemSpacing = .fixed(rowSpacing)
            
            let containerGroup =
            NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .estimated(rowGroupEstimatedHeight)), subitems: [rowGroup])
            
        })
    }
}

extension SymbolCollectionVC {
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SymbolCollectionCell, SFSymbol> {cell, indexPath, identifier in cell.symbol = identifier
            
        }
    
    dataSource = UICollectionViewDiffableDataSource<Section, SFSymbol> (collectionView: collectionView) {collectionView, indexPath, identifier in return
        collectionView
            .dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        
    }
}
}

extension SymbolCollectionVC {
    func generateSnapShot() ->
    NSDiffableDataSourceSnapshot<Section, SFSymbol> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SFSymbol>()
        
        SymbolCategories.allCases.forEach {
            category 
        }
    }
}
