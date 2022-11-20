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
        openedCardsUI(isAppeared: false)
        closedCardsUI(isAppeared: true)
        let image = ImageKey.blueBackground
        closedCards.setImage(image, for: .highlighted)
        //Changing direction of horizontal scrolling
        player2CardCollectionView.transform = CGAffineTransform(scaleX: -1,y: 1)
        //card hider fades
        hidePlayer1CardsView.setGradient(maskLayer: gradientMaskLayer, forPlayer: 1)
        hidePlayer2CardsView.setGradient(maskLayer: gradientMaskLayer2, forPlayer: 2)
    }
    
    func closedCardsUI (isAppeared: Bool) {
        if isAppeared {
            closedCards.setCurvedFrame()
            closedCards.setBackgroundImage(ImageKey.blueBackground, for: .normal)
            deckOfCards.setCurvedFrame()
            deckOfCards.image = ImageKey.blueBackground
        } else {
            closedCards.removeCurvedFrame()
            closedCards.setBackgroundImage(nil, for: .normal)
            deckOfCards.removeCurvedFrame()
            deckOfCards.image = nil
        }
    }
    
    func openedCardsUI(isAppeared: Bool) {
        if isAppeared {
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
    
    // Changing sizes of card depending on quantity
    func cardOverlays(collection: UICollectionView, receivedCards: [String]) {
        if let layout = collection.collectionViewLayout as? UICollectionViewFlowLayout {
            switch receivedCards.count {
            case 0..<3:
                layout.itemSize.width = 220
            case 3..<4:
                layout.itemSize.width = 150
            case 4..<5:
                layout.itemSize.width = 110
            case 5..<8:
                layout.itemSize.width = 90
            case 8..<10:
                layout.itemSize.width = 60
            case 10..<14:
                layout.itemSize.width = 50
            default:
                layout.itemSize.width = 40
            }
        }
    }
}
