//
//  PlayVC.swift
//  Pigobana
//
//  Created by Saba Khitaridze on 12.07.21.
//

import UIKit
import MultipeerConnectivity

final class PlayVC: UIViewController {
    
    //MARK: - IBOutlets
    
    //opened and closed cards
    @IBOutlet weak var openedCards: UIImageView!
    @IBOutlet weak var closedCards: UIButton!
    @IBOutlet weak var deckOfCards: UIImageView!
    @IBOutlet weak var mainCardsStackView: UIStackView!
    //Collection views
    @IBOutlet weak var player1CardCollectionView: UICollectionView!
    @IBOutlet weak var player2CardCollectionView: UICollectionView!
    //card hider views
    @IBOutlet weak var hidePlayer1CardsView: UIView!
    @IBOutlet weak var hidePlayer2CardsView: UIView!
    //player card quantities
    @IBOutlet weak var player1CardAmount: UILabel!
    @IBOutlet weak var player2CardAmount: UILabel!
    
    //MARK: - Manager
    
    private var animationManager = AnimationManager()
    
    //MARK: - Gradient Layer
    
    let gradientMaskLayer = CAGradientLayer()
    let gradientMaskLayer2 = CAGradientLayer()
    
    //MARK: - View Components
    
    let loadingView = UIView()
    let loadingIndicator = UIActivityIndicatorView(style: .medium)
    let loadingTextLabel = UILabel()
    let loadingCancelBtn = UIButton()
    //deck hider
    let deckHider = UIView()
    
    //MARK: - MC Objects
    
    private let peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcAdvertiserAssistant: MCAdvertiserAssistant?
    
    //MARK: - Cards Data
    
    //var playerController = 0
    var isFirstPlayer = true
    // Received cards array
    var player1Cards = [String]()
    var player2Cards = [String]()
    // Received cards holder
    var cardHolder: [String] = []
    //Cards Data
    
    //for testing purposes
    
//    private let cardsArray = [
//        CardModel(name: "2C"),
//        CardModel(name: "3C"),
//        CardModel(name: "4C"),
//        CardModel(name: "5C"),
//        CardModel(name: "6C"),
//        CardModel(name: "7C"),
//        CardModel(name: "8C"),
//        CardModel(name: "9C"),
//        CardModel(name: "10C"),
//        CardModel(name: "JC")
//    ]
    
    
    
        private let cardsArray = [
            CardModel(name: "2C"),
            CardModel(name: "2D"),
            CardModel(name: "2H"),
            CardModel(name: "2S"),
            CardModel(name: "3C"),
            CardModel(name: "3D"),
            CardModel(name: "3H"),
            CardModel(name: "3S"),
            CardModel(name: "4C"),
            CardModel(name: "4D"),
            CardModel(name: "4H"),
            CardModel(name: "4S"),
            CardModel(name: "5C"),
            CardModel(name: "5D"),
            CardModel(name: "5H"),
            CardModel(name: "5S"),
            CardModel(name: "6C"),
            CardModel(name: "6D"),
            CardModel(name: "6H"),
            CardModel(name: "6S"),
            CardModel(name: "7C"),
            CardModel(name: "7D"),
            CardModel(name: "7H"),
            CardModel(name: "7S"),
            CardModel(name: "8C"),
            CardModel(name: "8D"),
            CardModel(name: "8H"),
            CardModel(name: "8S"),
            CardModel(name: "9C"),
            CardModel(name: "9D"),
            CardModel(name: "9H"),
            CardModel(name: "9S"),
            CardModel(name: "10C"),
            CardModel(name: "10D"),
            CardModel(name: "10H"),
            CardModel(name: "10S"),
            CardModel(name: "JC"),
            CardModel(name: "JD"),
            CardModel(name: "JH"),
            CardModel(name: "JS"),
            CardModel(name: "QC"),
            CardModel(name: "QD"),
            CardModel(name: "QH"),
            CardModel(name: "QS"),
            CardModel(name: "KC"),
            CardModel(name: "KD"),
            CardModel(name: "KH"),
            CardModel(name: "KS"),
            CardModel(name: "AC"),
            CardModel(name: "AD"),
            CardModel(name: "AH"),
            CardModel(name: "AS")
        ]
    //new cards array for manipulating
    var newCardsArray = [CardModel]()
    
    //MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
        setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
        afterLaunchUI()
        //TODO: - FIX  uncomment this
        setupMCSession()
        //duplicating cards data to manipulate
        newCardsArray = cardsArray.shuffled()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mcSession?.connectedPeers.count == 0 ? createSession() : waitingForPeer(on: false)
    }
    
    //TODO: - FIX  uncomment this
    //this prevents app going into background mode with easy swipe gesture (game system)
    //    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
    //        return [.bottom]
    //    }
    
    //MARK: - IBAction
    
    @IBAction private func closedCardButtonPressed(_ sender: UIButton) {
        let currentCard = getLastCard()
        controlPlayersAndCards(currentCard: currentCard)
        sendData(of: currentCard)
        checkGamePosition()
    }
    
    //MARK: - Setup Methods
    
    private func setupMCSession() {
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
        waitingForPeer(on: true)
    }
    
    private func getLastCard() -> String {
        newCardsArray.removeLast().name
    }
    
    func checkGamePosition() {
        if newCardsArray.isEmpty {
            gameOverSegue()
        }
    }
    
    //MARK: - Private methods
    
    private func gameOverSegue() {
        let myStoryboard = UIStoryboard(name: VCIds.main, bundle: nil)
        guard let gameOverVC = myStoryboard.instantiateViewController(withIdentifier: VCIds.gameOverVC) as? GameOverVC else { return }
        gameOverVC.delegate = self
        gameOverVC.modalPresentationStyle = .fullScreen
        setClosedCards(appeared: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.present(gameOverVC, animated: true, completion: nil)
        }
    }
    
    //TODO: - FIX  this method should be modified and logic sharpened
    //Main logic of controlling players and cards
    private func controlPlayersAndCards(currentCard: String) {
        //last dealt card
        let previousCard = cardHolder.last
        //flipping from closed cards to open cards
        flipCard(name: currentCard)
        //saving opened cards in card holder
        cardHolder.append(currentCard)
        //cards hiders
        cardHiderAnimation(appear: false, with: hidePlayer1CardsView, for: player1Cards)
        cardHiderAnimation(appear: false, with: hidePlayer2CardsView, for: player2Cards)
        //deck hider
        //TODO: - FIX  uncomment this
        toggleDeck(hidden: true)
        
        // 1 Player
        if isFirstPlayer {
            if currentCard.suffix(1) == previousCard?.suffix(1) {
                closedCards.isUserInteractionEnabled = false
                for card in cardHolder {
                    player1Cards.append(card)
                    cardHolder.removeFirst()
                }
                //card receiving
                cardReceivingAnimation(to: player1Cards)
                player1CardAmount.text = "\(player1Cards.count)"
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
                    //TODO: - FIX  uncomment this
                    self.cardHiderAnimation(appear: true, with: self.hidePlayer1CardsView, for: self.player1Cards)
                    self.setOpenedCards(appeared: false)
                    self.player1CardCollectionView.reloadData()
                    self.player1CardCollectionView.isHidden = false
                    
                    //If both player has cards, main deck of cards is unavailable
                    if self.player2Cards.isEmpty {
                        self.closedCards.isUserInteractionEnabled = true
                    }
                }
            }
            // 2 Player
        } else if !isFirstPlayer {
            isFirstPlayer = true
            cardHiderAnimation(appear: false, with: hidePlayer2CardsView, for: player2Cards)
            if currentCard.suffix(1) == previousCard?.suffix(1) {
                closedCards.isUserInteractionEnabled = false
                for card in cardHolder {
                    player2Cards.append(card)
                    cardHolder.removeFirst()
                }
                //card receiving
                cardReceivingAnimation(to: player2Cards)
                player2CardAmount.text = "\(player2Cards.count)"
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
                    self.cardHiderAnimation(appear: true, with: self.hidePlayer2CardsView, for: self.player2Cards)
                    self.setOpenedCards(appeared: false)
                    self.player2CardCollectionView.reloadData()
                    self.player2CardCollectionView.isHidden = false
                    
                    //If both player has cards, main deck of cards is unavailable
                    if self.player1Cards.isEmpty {
                        self.closedCards.isUserInteractionEnabled = true
                    }
                }
            }
        }
    }
}

//MARK: - NewGame Delegate

extension PlayVC: NewGameDelegate {
    func startNewGame() {
        self.dismiss(animated: true, completion: nil)
        player1CardCollectionView.isHidden = true
        player2CardCollectionView.isHidden = true
        hidePlayer1CardsView.isHidden = true
        hidePlayer2CardsView.isHidden = true
        player1Cards = []
        player2Cards = []
        cardHolder = []
        newCardsArray = cardsArray.shuffled()
        // for starting a new game, we have to shuffle cards, as usual. also, this code prevents starting a new game if player decides to shuffle cards during playing.
        if (closedCards.backgroundImage(for: .normal) != nil) == false {
            setOpenedCards(appeared: false)
            setClosedCards(appeared: true)
        }
    }
}

//MARK: - CollectionView Delegate & DataSource

extension PlayVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.tag == 1 ? player1Cards.count : player2Cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1  {
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as Player1CardCell
            cell.setup(with: player1Cards, indexPath: indexPath)
            player1CardCollectionView.layoutViews(quantity: player1Cards)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as Player2CardCell
            cell.setup(with: player2Cards, indexPath: indexPath)
            player2CardCollectionView.layoutViews(quantity: player2Cards)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            let currentCard = player1Cards[indexPath.row]
            let remainedCard = cardHolder.last
            
            //guard let cell = collectionView.cellForItem(at: indexPath) as? Player1CardCell else { return }
            
            //bug where card jumps after animation
            // animationManager.movingAnimation(from: cell, to: mainCardsStackView) { [weak self] in
            //   guard let self else { return }
            
            
            self.openedCards.image = UIImage(named: currentCard)
            self.setOpenedCards(appeared: true)
            self.cardHolder.append(currentCard)
            
            
            //NEED TO FIX_________________________________________
            //TODO: - FIX  uncomment this
            self.sendData(of: currentCard)
            
            if currentCard.suffix(1) == remainedCard?.suffix(1) {
                for card in self.cardHolder {
                    self.player1Cards.append(card)
                    self.cardHolder.removeFirst()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
                    self.setOpenedCards(appeared: false)
                }
            }
            
            self.player1Cards.remove(at: indexPath.row)
            self.player1CardCollectionView.reloadData()
            
            self.player1CardAmount.text = "\(self.player1Cards.count)"
            //TODO: - FIX  uncomment this
            self.cardHiderAnimation(appear: true, with: self.hidePlayer1CardsView, for: self.player1Cards)
            self.cardHiderAnimation(appear: false, with: self.hidePlayer2CardsView, for: self.player2Cards)
            
            
            
            //TODO: - FIX  this logic!!!!!!!
            if (self.player1Cards.isEmpty && self.player2Cards.isEmpty) || self.player1Cards.isEmpty {
                self.closedCards.isUserInteractionEnabled = true
            }
            
            
            if !self.isFirstPlayer {
                self.isFirstPlayer = true
            }
            //}
        }
    }
}





/*
 TODO list:
 
 1. hiding and reappearing player cards ✅
 2. motions when taking/returning cards
 3. launchscreen should be displayed more time✅
 4. bluetooth support to play with another iphone✅
 5. ability to play with computer
 6. to show shaking notification only first time and only once.
 7.  add several screens: 1) launch screen✅  2) history of pigobana  3) game instructions  4) notification of shuffling cards.
 8. remove some objc noises in console✅
 9. resolve memory leak issue
 10. create animation of card flipping from closed cards to opened cards✅
 11. count player card quantities and show them ✅
 12. hide card hiders when game is starting from beginning✅
 13. add testing
 14. progress bar when launching✅
 15. add 1) single player 2) 2 player 3) instructions ✅
 16. add new logic for multiplayer✅
 17. add notification 1)when connection lost 2) when bluetooth/wifi is disabled and to turn it
 18. add custom notifications
 19. add change card quantity for opponent ✅
 20. add label "Opponent's turn" ✅
 21. resolve issue when opponents cards are not changing accordingly
 */
