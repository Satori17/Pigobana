//
//  FunctionExtensions.swift
//  Pigobana
//
//  Created by Saba Khitaridze on 27.07.21.
//

import UIKit

extension PlayVC {
    
    // motion detection for shuffling cards
    func canBecomeFirstResponder() -> Bool {
        return true
    }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
        if motion == .motionShake {
            cardsArray.shuffle()
            
            //animation for card shaking
            let animation = CAKeyframeAnimation()
            animation.keyPath = "position.x"
            animation.values = [0, 10, -10, 10, 0]
            animation.keyTimes = [0, 0.16, 0.5, 0.83, 1]
            animation.duration = 0.2
            animation.isAdditive = true
            closedCards.layer.add(animation, forKey: "shake")
            
            //vibration for successful shuffle
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
    
    // what should happen when view loads
    func afterLaunchUI() {
        openedCardsUI(exist: false)
        closedCardsUI(exist: true)
        let image = UIImage(named: "blue_background")
        closedCards.setImage(image, for: .highlighted)
        //Changing direction of horizontal scrolling
        player2CardCollectionView.transform = CGAffineTransform(scaleX: -1,y: 1)
        //card hider fades
        gradientForHiderView(gradientMask: gradientMaskLayer, cardHider: hideCardsView, player: 1)
        gradientForHiderView(gradientMask: gradientMaskLayer2, cardHider: hideCards2View, player: 2)
        //rotating player 2 card quantity label
        player2CardAmount.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    }
    
    //creating gradients for card hiding
    func gradientForHiderView(gradientMask: CAGradientLayer, cardHider: UIView, player: Int) {
        cardHider.layer.cornerRadius = 30
        cardHider.layer.maskedCorners =  player == 1 ? [.layerMaxXMinYCorner, .layerMinXMinYCorner] : [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        gradientMask.frame = cardHider.bounds
        gradientMask.colors = player == 1 ? [UIColor.clear.cgColor, UIColor.black.cgColor] : [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientMask.locations = player == 1 ? [0, 0.2] : [0.8, 1]
        cardHider.layer.mask = gradientMask
    }
    
    //Notification for shaking function
    func notification() {
        let alert = UIAlertController(title: "Remember", message: "Shake To Shuffle Cards!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: false, completion: nil)
        
    }
    
    
    func flipCard(name: String) {
        //using current card for moving animation
        let cardImage = UIImage(named: name)
        closedCards.setImage(cardImage, for: .normal)
        //animation for card moving
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = closedCards.center
        animation.toValue = openedCards.center
        animation.duration = 0.5
        animation.fillMode = .forwards
        closedCards.layer.add(animation, forKey: nil)
        
        //transition closure of flipping card
        let transition = { (_ ended: Bool) -> Void in
            if ended == true {
                self.closedCards.setImage(UIImage(named: "blue_background"), for: .normal)
                self.openedCards.image = UIImage(named: name)
                self.openedCardsUI(exist: true)
            }
        }
        //animation for card flipping
        UIView.transition(with: closedCards, duration: 0.48, options: .transitionFlipFromRight, animations: nil, completion: transition)
    }
    
        //changing sizes of card depending on quantity
    func cardOverlays(collection: UICollectionView, receivedCards: [CardModel]) {
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
    
    //Main logic of controlling players and cards
    func controlPlayersAndCards() {
        let currentImage = cardsArray[cardCounter]
        let previousImage = cardHolder.last
        //flipping from closed cards to open cards
        flipCard(name: currentImage.name)
        //saving opened cards in card holder
        cardHolder.append(currentImage)
        cardCounter += 1
        
        // 1 Player
        playerController += 1
        if playerController == 1 {
            
            //
            hideCards2View.isHidden = true
            UIView.animate(withDuration: 0.7, animations: {
                self.hideCards2View.alpha = 0
            })
            //
            
            if currentImage.cardSuit == previousImage?.cardSuit {
                closedCards.isUserInteractionEnabled = false
                for i in cardHolder {
                    player1Cards.append(i)
                    cardHolder.removeFirst()
                }
                
                player1CardCollectionView.isHidden = false
                player1CardCollectionView.reloadData()
                
                //
                hideCardsView.isHidden = false
                player1CardAmount.text = "\(player1Cards.count)"
                UIView.animate(withDuration: 0.7, animations: {
                    self.hideCardsView.alpha = 1
                })
                //
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.openedCardsUI(exist: false)
                    //If both player has cards, main deck of cards is unavailable
                    if self.player2Cards.isEmpty {
                        self.closedCards.isUserInteractionEnabled = true
                    }
                }
            }
            
            //Player 2
        } else if playerController == 2 {
            playerController = 0
            
            //
            hideCardsView.isHidden = true
            UIView.animate(withDuration: 0.7, animations: {
                self.hideCardsView.alpha = 0
            })
            //
            
            if currentImage.cardSuit == previousImage?.cardSuit {
                closedCards.isUserInteractionEnabled = false
                for i in cardHolder {
                    player2Cards.append(i)
                    cardHolder.removeFirst()
                }
                
                player2CardCollectionView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                    self.player2CardCollectionView.isHidden = false
                    self.player2CardCollectionView.reloadData()
                }
                
                //
                hideCards2View.isHidden = false
                player2CardAmount.text = "\(player2Cards.count)"
                UIView.animate(withDuration: 0.7, animations: {
                    self.hideCards2View.alpha = 1
                })
                //
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.openedCardsUI(exist: false)
                    //If both player has cards, main deck of cards is unavailable
                    if self.player1Cards.isEmpty {
                        self.closedCards.isUserInteractionEnabled = true
                    }
                }
            }
        }
    }
}
