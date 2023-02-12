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
            cards.shuffle()
            
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
    func flip(card: CardModel) {
        //using current card for moving animation
        let cardName = card.name
        let cardImage = UIImage(named: cardName)
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
                self.cards.isEmpty ? self.closedCards.setImage(nil, for: .normal) : self.closedCards.setImage(UIImage(named: ImageKey.blueBackground), for: .normal)
                self.openedCards.image = UIImage(named: cardName)
                self.setOpenedCards(appeared: true)
            }
        }
        //animation for card flipping
        UIView.transition(with: closedCards, duration: 0.48, options: .transitionFlipFromRight, animations: nil, completion: transition)
    }
    
    // Animation when player deals card
    func receive(cardTo direction: [CardModel]) {
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
    
    func give(card: CardModel) {
        let fromView = UIImageView(frame: openedCards.frame)
        fromView.image = UIImage(named: card.name)
        fromView.transform = CGAffineTransform(scaleX: 1, y: -1)
        fromView.setCurvedFrame()
        player2CardCollectionView.addSubview(fromView)
        
        UIView.animate(withDuration: 0.48) {
            fromView.frame.origin.x = self.mainCardsStackView.frame.midX+12
            fromView.frame.origin.y = self.mainCardsStackView.frame.origin.y+70
        } completion: { _ in
            fromView.removeFromSuperview()
            self.openedCards.image = UIImage(named: card.name)
            self.setOpenedCards(appeared: true)
        }
    }
    
    func hide(cards appear: Bool, forPlayer1: Bool) {
        let playerCards = forPlayer1 ? player1Cards : player2Cards
        let hider = forPlayer1 ? hidePlayer1CardsView : hidePlayer2CardsView
        if appear == true && !playerCards.isEmpty {
            UIView.animate(withDuration: 0.8, animations: {
                hider?.alpha = 0.7
            })
        } else if appear == false {
            UIView.animate(withDuration: 0.5, animations: {
                hider?.alpha = 0
            })
        }
    }
    
    //TODO: - FIX
    func toggleDeck(hidden: Bool) {
        guard !cards.isEmpty else { return }
        deckHider.frame = closedCards.bounds
        deckHider.backgroundColor = .black
        deckHider.alpha = 0
        closedCards.addSubview(deckHider)
        UIView.animate(withDuration: 0.5, delay: 0.5) { [weak self] in
            self?.deckHider.alpha = hidden == true ? 0.4 : 0
        }
    }
}
