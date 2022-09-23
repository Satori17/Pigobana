//
//  MultiplayerMode.swift
//  Pigobana
//
//  Created by Saba Khitaridze on 13.01.22.
//

import Foundation
import MultipeerConnectivity


extension PlayVC: MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    //MARK: - Functions
    
    //view indicates that player is waiting
    func waitingForPeer(on: Bool) {
        if on == true {
            //background
            loadingView.frame = self.view.bounds
            loadingView.backgroundColor = .lightGray
            loadingView.alpha = 0.9
            //loading loop
            loadingIndicator.center = loadingView.center
            loadingIndicator.startAnimating()
            self.view.addSubview(loadingView)
            loadingView.addSubview(loadingIndicator)
        } else if on == false {
            loadingView.isHidden = true
            loadingIndicator.stopAnimating()
            loadingIndicator.isHidden = true
            mcAdvertiserAssistant?.stop()
        }
    }
    
    //text and countdown when player presses host button
    func loadingCountdown() {
        //loading label
        loadingTextLabel.text = "Waiting for player"
        loadingTextLabel.textColor = .darkGray
        loadingTextLabel.textAlignment = .center
        loadingTextLabel.font = UIFont.systemFont(ofSize: 17)
        loadingTextLabel.sizeToFit()
        loadingTextLabel.center = CGPoint(x: loadingIndicator.center.x, y: loadingIndicator.center.y + 30)
        loadingView.addSubview(loadingTextLabel)
        //loading cancel button
        var timer = 15
        loadingCancelBtn.setTitle("Cancel", for: .normal)
        loadingCancelBtn.setTitleColor(.systemBlue, for: .normal)
        loadingCancelBtn.sizeToFit()
        loadingCancelBtn.center = CGPoint(x: loadingIndicator.center.x, y: loadingTextLabel.center.y + 100)
        loadingCancelBtn.addTarget(self, action: #selector(cancelLoading), for: .touchUpInside)
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if timer > 0 {
                timer -= 1
            } else {
                self.loadingView.addSubview(self.loadingCancelBtn)
            }
        }
    }
    
    @objc func cancelLoading() {
        mcAdvertiserAssistant?.stop()
        self.dismiss(animated: true, completion: nil)
    }
    
    //Create general session
    func createSession() {
        //Host Session
        let connectWithOthers = UIAlertController(title: "Connect to players", message: nil, preferredStyle: .actionSheet)
        connectWithOthers.addAction(UIAlertAction(title: "Host Session", style: .default, handler: { (action) in
            guard let mcSession = self.mcSession else { return }
            self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType:  "pigobana", discoveryInfo: nil, session: mcSession)
            self.mcAdvertiserAssistant?.start()
            self.loadingCountdown()
        }))
        //Join Session
        connectWithOthers.addAction(UIAlertAction(title: "Join Game", style: .default, handler: { (UIAlertAction) in
            guard let mcSession = self.mcSession else { return }
            let mcBrowser = MCBrowserViewController(serviceType: "pigobana", session: mcSession)
            mcBrowser.delegate = self
            self.present(mcBrowser, animated: true, completion: nil)
        }))
        //Cancel
        connectWithOthers.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
        present(connectWithOthers, animated: true, completion: nil)
    }
    
    
    //sending string data of card image name
    func sendData(of Card: String) {
        guard let mcSession = mcSession else { return }
        if mcSession.connectedPeers.count > 0 {
            if let imageData = Card.data(using: String.Encoding.utf8) {
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    print("\(error.localizedDescription)")
                }
            }
        }
    }
    
    //receiving card image name data
    func receiveData(of Card: String) {
        //last dealt card
        let previousCard = cardHolder.last
        //flipping from closed cards to open cards
        flipCard(name: Card)
        //saving opened cards in card holder
        cardHolder.append(Card)
        //cards hiders
        cardHiderAnimation(appear: false, with: hidePlayer1CardsView, for: player1Cards)
        cardHiderAnimation(appear: true, with: hidePlayer2CardsView, for: player2Cards)
        //deck hider
        deckHiderAnimation(appear: false)
        
        // 1 Player
        if Card.suffix(1) == previousCard?.suffix(1) {
            closedCards.isUserInteractionEnabled = false
            for card in cardHolder {
                player2Cards.append(card)
                cardHolder.removeFirst()
            }
            player2CardAmount.text = "\(player2Cards.count)"
            cardHiderAnimation(appear: false, with: hidePlayer1CardsView, for: player1Cards)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
                self.cardHiderAnimation(appear: true, with: self.hidePlayer2CardsView, for: self.player2Cards)
                self.openedCardsUI(exist: false)
                self.player2CardCollectionView.reloadData()
                self.player2CardCollectionView.isHidden = false
                
                //If both player has cards, main deck of cards is unavailable
                if self.player1Cards.isEmpty {
                    self.closedCards.isUserInteractionEnabled = true
                }
            }
        }
        
        // 2 Player
        playerController = 0
        if Card.suffix(1) == previousCard?.suffix(1) {
            closedCards.isUserInteractionEnabled = false
            for card in cardHolder {
                player1Cards.append(card)
                cardHolder.removeFirst()
            }
            //card receiving
            cardReceivingAnimation(to: player2Cards)
            player1CardAmount.text = "\(player1Cards.count)"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
                self.openedCardsUI(exist: false)
                self.player1CardCollectionView.reloadData()
                self.player1CardCollectionView.isHidden = false
                //If both player has cards, main deck of cards is unavailable
                if self.player2Cards.isEmpty {
                    self.closedCards.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    //MARK: - MC methods
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            DispatchQueue.main.async { [weak self] in
                self?.waitingForPeer(on: false)
            }
            print(ConditionMessage.connected, peerID.displayName)
            
        case MCSessionState.connecting:
            print(ConditionMessage.connecting, peerID.displayName)
            
        case MCSessionState.notConnected:
            print(ConditionMessage.notConnected, peerID.displayName)
        @unknown default:
            print(ConditionMessage.fatalError)
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {        
        if let imageData = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async { [weak self] in
                self?.receiveData(of: imageData)
                self?.newCardsArray.removeAll(where: {$0.name == imageData})
                self?.gameOverSegue()
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
    //MARK: - Browser methods
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
}
