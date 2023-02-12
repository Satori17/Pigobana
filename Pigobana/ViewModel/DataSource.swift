//
//  DataSource.swift
//  Pigobana
//
//  Created by Saba Khitaridze on 13.02.23.
//

import UIKit

// MARK: - CollectionView diffableDataSource

extension PlayVC {
    func makeDataSource(for collectionView: UICollectionView, with cell: UICollectionViewCell.Type) -> CardModel.DataSource {
        CardModel.DataSource(collectionView: collectionView) { collectionView, indexPath, model in
            let cardCell = collectionView.dequeueReusableCell(fromClass: cell.self, for: indexPath)
            if let cardCell = cardCell as? Player1CardCell {
                cardCell.setup(with: model.name)
            } else if let cardCell = cardCell as? Player2CardCell {
                cardCell.setup()
            }
            
            return cardCell
        }
    }
    
    func setupDataSource() {
        //Player 1
        player1DataSource = makeDataSource(for: player1CardCollectionView, with: Player1CardCell.self)
        player1CardCollectionView.dataSource = player1DataSource
        player1CardCollectionView.delegate = self
        //Player 2
        player2DataSource = makeDataSource(for: player2CardCollectionView, with: Player2CardCell.self)
        player2CardCollectionView.dataSource = player2DataSource
        player2CardCollectionView.delegate = self
    }
    
    func updateDataSource(animated: Bool) {
        //1 Player
        var player1Snapshot = CardModel.DataSourceSnapshot()
        player1Snapshot.appendSections([.playerHolder])
        player1Snapshot.appendItems(player1Cards)
        
        animationManager.reorderAnimation(for: player1Cards, on: player1CardCollectionView)
        player1DataSource.apply(player1Snapshot, animatingDifferences: animated)
        //2 Player
        var player2Snapshot = CardModel.DataSourceSnapshot()
        player2Snapshot.appendSections([.playerHolder])
        player2Snapshot.appendItems(player2Cards)
        animationManager.reorderAnimation(for: player2Cards, on: player2CardCollectionView)
        player2DataSource.apply(player2Snapshot, animatingDifferences: animated)
    }
    
    
    //fix fading animation issue when receiving cards
    func removeDataSourceItem(at indexPath: IndexPath) {
        player1Cards.remove(at: indexPath.item)
        updateDataSource(animated: false)
    }
}
