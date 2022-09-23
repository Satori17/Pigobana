//
//  Animations.swift
//  Pigobana
//
//  Created by Saba Khitaridze on 05.02.22.
//

import UIKit

//MARK: - PlayVC

extension PlayVC {
    
    // Motion detection for shuffling cards
    func canBecomeFirstResponder() -> Bool {
        return true
    }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
        if motion == .motionShake {
            newCardsArray.shuffle()
            
            //animation for card shaking
            let animation = CAKeyframeAnimation()
            animation.keyPath = AnimationKey.positionX
            animation.values = [0, 10, -10, 10, 0]
            animation.keyTimes = [0, 0.16, 0.5, 0.83, 1]
            animation.duration = 0.2
            animation.isAdditive = true
            closedCards.layer.add(animation, forKey: AnimationKey.shake)
            //vibration for successful shuffle
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
    
    // Card flipping animation
    func flipCard(name: String) {
        //using current card for moving animation
        let cardImage = UIImage(named: name)
        closedCards.setImage(cardImage, for: .normal)
        //animation for card moving
        let animation = CABasicAnimation(keyPath: AnimationKey.position)
        animation.fromValue = closedCards.center
        animation.toValue = openedCards.center
        animation.duration = 0.5
        animation.fillMode = .forwards
        closedCards.layer.add(animation, forKey: nil)
        
        //transition closure of flipping card
        let transition = { (_ ended: Bool) -> Void in
            if ended == true {
                self.newCardsArray.isEmpty ? self.closedCards.setImage(nil, for: .normal) : self.closedCards.setImage(ImageKey.blueBackground, for: .normal)
                self.openedCards.image = UIImage(named: name)
                self.openedCardsUI(exist: true)
            }
        }
        //animation for card flipping
        UIView.transition(with: closedCards, duration: 0.48, options: .transitionFlipFromRight, animations: nil, completion: transition)
    }
    
    // Animation when player deals card
    func cardReceivingAnimation(to direction: [String]) {
        let animation = CABasicAnimation(keyPath: AnimationKey.positionY)
        animation.fromValue = openedCards.frame.midY
        animation.toValue = direction == player1Cards ? player1CardCollectionView.frame.midY : -player1CardCollectionView.frame.midY
        animation.duration = 0.5
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = true
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.6) {
            self.openedCards.layer.add(animation, forKey: nil)
        }
    }
    
    func cardHiderAnimation(appear: Bool, with hider: UIView, for playerCards: [String]) {
        if appear == true && !playerCards.isEmpty {
            UIView.animate(withDuration: 0.8, animations: {
                hider.alpha = 0.7
            })
        } else if appear == false {
            UIView.animate(withDuration: 0.5, animations: {
                hider.alpha = 0               
            })
        }
    }
    
    // NEED TO FIX________
    func deckHiderAnimation(appear: Bool) {
        deckHider.frame = closedCards.bounds
        deckHider.backgroundColor = .black
        deckHider.alpha = 0
        closedCards.addSubview(deckHider)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            if appear == true {
                self.deckHider.alpha = 0.4
            } else if appear == false {
                self.deckHider.alpha = 0
            }
        }
    }
}
