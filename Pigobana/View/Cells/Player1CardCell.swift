//
//  Player1CardCell.swift
//  Pigobana
//
//  Created by Saba Khitaridze on 27.07.21.
//

import UIKit

final class Player1CardCell: UICollectionViewCell {
    //MARK: - IBOutets
    
    @IBOutlet private weak var player1_cardImageView: UIImageView!
    
    //MARK: - Setup
    
    func setup(with model: [String], indexPath: IndexPath) {
        guard model.count > 0 else { return }
        let currentCard = model[indexPath.row]
        player1_cardImageView.image = UIImage(named: currentCard)
        player1CardUI()
    }
    
    func setup(with model: String) {
        player1_cardImageView.image = UIImage(named: model)
        player1CardUI()
    }
    
    //MARK: - Private methods
    
    private func player1CardUI() {
        player1_cardImageView.layer.cornerRadius = 9
        player1_cardImageView.layer.borderWidth = (player1_cardImageView.frame.width)/28
        player1_cardImageView.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
    }
}
