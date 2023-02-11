//
//  Player2CardCell.swift
//  Pigobana
//
//  Created by Saba Khitaridze on 09.08.21.
//

import UIKit

final class Player2CardCell: UICollectionViewCell {
    //MARK: - IBOutlets
    
    @IBOutlet private weak var player2_cardImageView: UIImageView!
    
    //MARK: - Setup
    
    func setup(with model: [String], indexPath: IndexPath) {
        guard model.count > 0 else { return }
        self.transform = CGAffineTransform(scaleX: 1,y: -1)
        //let currentCard = model[indexPath.row]
        self.isUserInteractionEnabled = false
        player2_cardImageView.image = UIImage(named: ImageKey.blueBackground)
        player2CardUI()
        
        // old version of writing transforming method
        //DispatchQueue.main.async { [weak self] in
            //self.transform = CGAffineTransform(scaleX: 1,y: -1)
        //}
    }
    
    func setup() {
        player2_cardImageView.image = UIImage(named: ImageKey.blueBackground)
        player2CardUI()
    }
    
    //MARK: - Private methods
    
    private func player2CardUI() {
        player2_cardImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double .pi))
        player2_cardImageView.layer.cornerRadius = 9
        player2_cardImageView.layer.borderWidth = (player2_cardImageView.frame.width)/28
        player2_cardImageView.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
    }
}
