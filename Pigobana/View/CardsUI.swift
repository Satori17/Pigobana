//
//  CardsUI.swift
//  Pigobana
//
//  Created by Saba Khitaridze on 20.07.21.
//

import UIKit


//MARK: - LaunchScreenVC

extension LaunchScreenVC {
    
    func launchingUI(for button: UIButton) {
        //for progressView
        progressView.setProgress(0.5, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
            UIView.animate(withDuration: 0.3, animations: {
                self.progressView.alpha = 0
                self.howToPlayBtn.alpha = 1
            })
            UIView.animate(withDuration: 0.5, animations: {
                self.multiPlayerBtn.alpha = 1
            })
            UIView.animate(withDuration: 0.7, animations: {
                self.singlePlayerBtn.alpha = 1
            })
        })
        //for buttons
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 15
        button.layer.shadowRadius = 10
        button.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        button.layer.shadowOpacity = 0.8
    }
}


//MARK: - PlayVC

extension PlayVC {
    
    func afterLaunchUI() {
        openedCardsUI(exist: false)
        closedCardsUI(exist: true)
        let image = UIImage(named: "blue_background")
        closedCards.setImage(image, for: .highlighted)
        //Changing direction of horizontal scrolling
        player2CardCollectionView.transform = CGAffineTransform(scaleX: -1,y: 1)
        //card hider fades
        gradientForHiderView(gradientMask: gradientMaskLayer, cardHider: hidePlayer1CardsView, player: 1)
        gradientForHiderView(gradientMask: gradientMaskLayer2, cardHider: hidePlayer2CardsView, player: 2)             
    }
    
    func closedCardsUI (exist: Bool) {
        if exist == true {
            closedCards.layer.cornerRadius = 9
            closedCards.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
            closedCards.layer.borderWidth = (closedCards.frame.width)/30
            closedCards.setBackgroundImage(UIImage(named: "blue_background"), for: .normal)
            
            deckOfCards.layer.cornerRadius = 9
            deckOfCards.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
            deckOfCards.layer.borderWidth = (deckOfCards.frame.width)/30
            deckOfCards.image = UIImage(named: "blue_background")
        } else {
            closedCards.layer.cornerRadius = 0
            closedCards.layer.borderColor = UIColor(white: 0, alpha: 0).cgColor
            closedCards.layer.borderWidth = 0
            closedCards.setBackgroundImage(nil, for: .normal)
            
            deckOfCards.layer.cornerRadius = 0
            deckOfCards.layer.borderColor = UIColor(white: 0, alpha: 0).cgColor
            deckOfCards.layer.borderWidth = 0
            deckOfCards.image = nil
        }
    }
    
    func openedCardsUI (exist: Bool) {
        if exist == true {
            openedCards.isHidden = false
            openedCards.layer.cornerRadius = 9
            openedCards.layer.borderWidth = (openedCards.frame.width)/30
            openedCards.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
        }
        else {
            openedCards.image = nil
            openedCards.backgroundColor = nil
            openedCards.layer.cornerRadius = 0
            openedCards.layer.borderWidth = 0
            openedCards.layer.borderColor = UIColor(white: 0, alpha: 0).cgColor
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
    
    // Creating gradients for card hiding
    func gradientForHiderView(gradientMask: CAGradientLayer, cardHider: UIView, player: Int) {
        cardHider.layer.cornerRadius = 30
        cardHider.layer.maskedCorners =  player == 1 ? [.layerMaxXMinYCorner, .layerMinXMinYCorner] : [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        gradientMask.frame = cardHider.bounds
        gradientMask.colors = player == 1 ? [UIColor.clear.cgColor, UIColor.black.cgColor] : [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientMask.locations = player == 1 ? [0, 0.3] : [0.7, 1]
        cardHider.layer.mask = gradientMask
    }
}
