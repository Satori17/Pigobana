//
//  PlayerCollectionView.swift
//  Pigobana
//
//  Created by Saba Khitaridze on 27.07.21.
//

import UIKit


extension PlayVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionView.tag == 1 ? player1Cards.count : player2Cards.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Player1
        if collectionView.tag == 1  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Player1CardCell", for: indexPath) as! Player1CardCell
            guard player1Cards.count > 0 else { return cell }
            let currentCard = player1Cards[indexPath.row].name
            cell.player1_cardImageView.image = UIImage(named: "\(currentCard)")
            
            cell.player1CardUI()
            cardOverlays(collection: player1CardCollectionView, receivedCards: player1Cards)
            
            return cell
            //Player2
        } else {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "Player2CardCell", for: indexPath) as! Player2CardCell
            guard player2Cards.count > 0 else { return cell2 }
            //Flipping imageView
            cell2.player2_cardImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double .pi))
            //Direction of horizontal scrolling
            player2CardCollectionView.transform = CGAffineTransform(scaleX: -1,y: 1)
            cell2.transform = CGAffineTransform(scaleX: 1,y: -1)
            let currentCard = player2Cards[indexPath.row].name
            cell2.player2_cardImageView.image = UIImage(named: "\(currentCard)")
            cell2.player2CardUI()
            cardOverlays(collection: player2CardCollectionView, receivedCards: player2Cards)
            
            return cell2
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Player1
        if collectionView.tag == 1 {
            playerController = 1

            
            //
            hideCardsView.isHidden = false
            hideCards2View.isHidden = true
            UIView.animate(withDuration: 0.7, animations: {
                self.hideCardsView.alpha = 1
                self.hideCards2View.alpha = 0
            })
            //
            
            openedCardsUI(exist: true)
            let currentCard = player1Cards[indexPath.row]
            let RemainedCard = cardHolder.last
            openedCards.image = UIImage(named: currentCard.name)
            cardHolder.append(currentCard)
            
            if currentCard.cardSuit == RemainedCard?.cardSuit {
                for card in cardHolder {
                    player1Cards.append(card)
                    cardHolder.removeFirst()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.openedCardsUI(exist: false)
                }
            }
            player1Cards.remove(at: indexPath.row)
            player1CardCollectionView.reloadData()
            player1CardAmount.text = "\(player1Cards.count)"
        } else {
            //Player 2
            playerController = 2
            player2CardCollectionView.reloadData()
            //
            hideCardsView.isHidden = true
            hideCards2View.isHidden = false
            UIView.animate(withDuration: 0.7, animations: {
                self.hideCards2View.alpha = 1
                self.hideCardsView.alpha = 0
            })
            //
            
            openedCardsUI(exist: true)
            let currentCard = player2Cards[indexPath.row]
            let remainedCard = cardHolder.last
            openedCards.image = UIImage(named: currentCard.name)
            cardHolder.append(currentCard)
            
            if currentCard.cardSuit == remainedCard?.cardSuit {
                for card in cardHolder {
                    player2Cards.append(card)
                    cardHolder.removeFirst()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.openedCardsUI(exist: false)
                }
            }
            player2Cards.remove(at: indexPath.row)
            player2CardCollectionView.reloadData()
            player2CardAmount.text = "\(player2Cards.count)"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                self.player2CardCollectionView.reloadData()
            }
        }
        
        if player1Cards.isEmpty {
            hideCardsView.isHidden = true
        }
        if player2Cards.isEmpty {
            hideCards2View.isHidden = true
        }
        
        if player1Cards.isEmpty || player2Cards.isEmpty {
            closedCards.isUserInteractionEnabled = true
        }
        
        if playerController == 2 {
            playerController = 0
        }
    }
}
