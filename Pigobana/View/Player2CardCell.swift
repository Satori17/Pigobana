//
//  Player2CardCell.swift
//  Pigobana
//
//  Created by Saba Khitaridze on 09.08.21.
//

import UIKit

class Player2CardCell: UICollectionViewCell {
    
    @IBOutlet weak var player2_cardImageView: UIImageView!
    
    func player2CardUI() {
        player2_cardImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double .pi))
        player2_cardImageView.layer.cornerRadius = 9
        player2_cardImageView.layer.borderWidth = (player2_cardImageView.frame.width)/28
        player2_cardImageView.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
        player2_cardImageView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        player2_cardImageView.layer.shadowOffset = CGSize(width: 7.0, height: 0.0)
        player2_cardImageView.layer.shadowOpacity = 1.0
        
    }
}
