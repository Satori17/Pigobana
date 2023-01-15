//
//  CardsUI.swift
//  Pigobana
//
//  Created by Saba Khitaridze on 20.07.21.
//

import UIKit

//MARK: - PlayVC
extension PlayVC {
    
    func afterLaunchUI() {
        setOpenedCards(appeared: false)
        setClosedCards(appeared: true)
        let image = UIImage(named: ImageKey.blueBackground)
        closedCards.setImage(image, for: .highlighted)
        //Changing direction of horizontal scrolling
        player2CardCollectionView.transform = CGAffineTransform(scaleX: -1,y: 1)
        //card hider fades
        hidePlayer1CardsView.setGradient(maskLayer: gradientMaskLayer, forPlayer: 1)
        hidePlayer2CardsView.setGradient(maskLayer: gradientMaskLayer2, forPlayer: 2)
    }
    
    func setClosedCards(appeared: Bool) {
        if appeared {
            closedCards.setCurvedFrame()
            closedCards.setBackgroundImage(UIImage(named: ImageKey.blueBackground), for: .normal)
            deckOfCards.setCurvedFrame()
            deckOfCards.image = UIImage(named: ImageKey.blueBackground)
        } else {
            closedCards.removeCurvedFrame()
            closedCards.setBackgroundImage(nil, for: .normal)
            deckOfCards.removeCurvedFrame()
            deckOfCards.image = nil
        }
    }
    
    func setOpenedCards(appeared: Bool) {
        if appeared {
            openedCards.isHidden = false
            openedCards.setCurvedFrame()
        }
        else {
            openedCards.image = nil
            openedCards.removeCurvedFrame()
        }
    }
    
    // Notification for shaking function
    func notification() {
        let alert = UIAlertController(title: "Remember", message: "Shake To Shuffle Cards!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: false, completion: nil)
        
    }
}
