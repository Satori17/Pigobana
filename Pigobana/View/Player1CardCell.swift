//
//  Player1CardCell.swift
//  Pigobana
//
//  Created by Saba Khitaridze on 27.07.21.
//

import UIKit

class Player1CardCell: UICollectionViewCell {
    
    @IBOutlet weak var player1_cardImageView: UIImageView!
    
    func player1CardUI() {
        player1_cardImageView.layer.cornerRadius = 9
        player1_cardImageView.layer.borderWidth = (player1_cardImageView.frame.width)/28
        player1_cardImageView.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
        player1_cardImageView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        player1_cardImageView.layer.shadowOffset = CGSize(width: 7.0, height: 0.0)
        player1_cardImageView.layer.shadowOpacity = 1.0
    }
}
