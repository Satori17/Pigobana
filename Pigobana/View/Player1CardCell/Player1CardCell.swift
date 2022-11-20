//
//  Player1CardCell.swift
//  Pigobana
//
//  Created by Saba Khitaridze on 27.07.21.
//

import UIKit

class Player1CardCell: UICollectionViewCell {
    
    //MARK: - IBOutets
    
    @IBOutlet weak var player1_cardImageView: UIImageView!
    
    //MARK: - Methods
    
    func player1CardUI() {
        player1_cardImageView.layer.cornerRadius = 9
        player1_cardImageView.layer.borderWidth = (player1_cardImageView.frame.width)/28
        player1_cardImageView.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
    }
}
