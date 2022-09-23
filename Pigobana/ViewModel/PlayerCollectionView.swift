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
        if collectionView.tag == 1  {
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as Player1CardCell
            //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Player1CardCell", for: indexPath) as! Player1CardCell
            guard player1Cards.count > 0 else { return cell }
            let currentCard = player1Cards[indexPath.row]
            cell.player1_cardImageView.image = UIImage(named: "\(currentCard)")
            cell.player1CardUI()
            cardOverlays(collection: player1CardCollectionView, receivedCards: player1Cards)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as Player2CardCell
            //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Player2CardCell", for: indexPath) as! Player2CardCell
            DispatchQueue.main.async {
                cell.transform = CGAffineTransform(scaleX: 1,y: -1)
            }
            guard player2Cards.count > 0 else { return cell }
            //let currentCard = player2Cards[indexPath.row]
            cell.isUserInteractionEnabled = false
            cell.player2CardUI()
            cell.player2_cardImageView.image = ImageKey.blueBackground
            cardOverlays(collection: player2CardCollectionView, receivedCards: player2Cards)
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            playerController = 1
            //delegate?.cardDealingAnimation(on: self)
            //openedCardsUI(exist: true)
            
            let currentCard = player1Cards[indexPath.row]
            let RemainedCard = cardHolder.last
            

            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.openedCards.image = UIImage(named: currentCard)
                self.openedCardsUI(exist: true)
                self.cardHolder.append(currentCard)
            }

            
            
            
            //NEED TO FIX_________________________________________
            sendData(of: currentCard)
            
            if currentCard.suffix(1) == RemainedCard?.suffix(1) {
                for card in cardHolder {
                    player1Cards.append(card)
                    cardHolder.removeFirst()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
                    self.openedCardsUI(exist: false)
                }
            }
            player1Cards.remove(at: indexPath.row)
            player1CardCollectionView.reloadData()
            player1CardAmount.text = "\(player1Cards.count)"            
            cardHiderAnimation(appear: true, with: hidePlayer1CardsView, for: player1Cards)
            cardHiderAnimation(appear: false, with: hidePlayer2CardsView, for: player2Cards)
        }
        
        if player1Cards.isEmpty || player2Cards.isEmpty {
            closedCards.isUserInteractionEnabled = true
        }
        
        if playerController == 2 {
            playerController = 0
        }
    }
    
   
}
