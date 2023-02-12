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
    @IBOutlet private weak var player1CardAmount: UILabel!
    @IBOutlet private weak var player2CardAmount: UILabel!
    
    //MARK: - Manager
    
    var animationManager = AnimationManager()
    
    //MARK: - Gradient layer
    
    let gradientMaskLayer = CAGradientLayer()
    let gradientMaskLayer2 = CAGradientLayer()
    
    //MARK: - View components
    
    private let loadingView = UIView()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let loadingTextLabel = UILabel()
    private let loadingCancelBtn = UIButton()
    //deck hider
    let deckHider = UIView()
    
    //MARK: - MC objects
    
    private let peerID = MCPeerID(displayName: UIDevice.current.name)
    private var mcSession: MCSession?
    private var mcAdvertiserAssistant: MCAdvertiserAssistant?
    
    //MARK: - Cards data
    
    var player1DataSource: CardModel.DataSource!
    var player2DataSource: CardModel.DataSource!
    
    // MARK: - Manipulatable data
    
    private var isPlayer1 = true
    private var cardsWorker: CardsWorkerProtocol?
    // Received cards array
    var player1Cards = [CardModel]()
    var player2Cards = [CardModel]()
    // Received cards holder
    private var cardHolder: [CardModel] = []
    //Cards Data
    var cards = [CardModel]()
    
    //MARK: - View lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
        //TODO: - FIX  uncomment this
        sendData(of: currentCard.name)
        checkGamePosition()
    }
    
    //MARK: - Setup methods
    
    private func setup() {
        self.becomeFirstResponder()
        setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
        commonInit()
        afterLaunchUI()
        setupDataSource()
        //TODO: - FIX  uncomment this
        setupMCSession()
    }
    
    private func commonInit() {
        let viewController = self
        let worker = CardsWorker()
        viewController.cardsWorker = worker
        cards = cardsWorker?.getCards() ?? []
    }
    
    private func setupMCSession() {
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
        waitingForPeer(on: true)
    }
    
    //MARK: - Private methods
    
    private func getLastCard() -> CardModel {
        cards.removeLast()
    }
    
    private func checkGamePosition() {
        if cards.isEmpty {
            gameOverSegue()
        }
    }
    
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
    
    private func update(isPlayer1: Bool) {
        cardHolder.forEach {
            isPlayer1 ? player1Cards.append($0) : player2Cards.append($0)
            cardHolder.removeFirst()
        }
    }
    
    private func deliverCards(forPlayer1: Bool, special: Bool = false) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) { [weak self] in
            guard let self else { return }
            //TODO: - FIX  uncomment this
            if !special {
                self.hide(cards: true, forPlayer1: forPlayer1)
            }
            self.setOpenedCards(appeared: false)
            self.updateDataSource(animated: true)
            let collectionView = forPlayer1 ? self.player1CardCollectionView : self.player2CardCollectionView
            collectionView?.isHidden = false
        }
    }
    
    // MARK: - Control Players and Cards
    //TODO: - FIX  this method should be modified and logic sharpened
    private func controlPlayersAndCards(currentCard: CardModel) {
        //last dealt card
        let previousCard = cardHolder.last
        //flipping from closed cards to open cards
        flip(card: currentCard)
        //saving opened cards in card holder
        cardHolder.append(currentCard)
        //cards hiders
        //TODO: - FIX  uncomment this
        hide(cards: false, forPlayer1: true)
        hide(cards: false, forPlayer1: false)
        //deck hider
        //TODO: - FIX  uncomment this
        toggleDeck(hidden: true)
        
        // 1 Player
        if isPlayer1 {
            if currentCard.suit == previousCard?.suit {
                update(isPlayer1: true)
                //card receiving
                receive(cardTo: player1Cards)
                player1CardAmount.text = "\(player1Cards.count)"
                deliverCards(forPlayer1: true)
            }
            // 2 Player
        } else if !isPlayer1 {
            isPlayer1 = true
            //TODO: - FIX  uncomment this
            hide(cards: false, forPlayer1: false)
            if currentCard.suit == previousCard?.suit {
                update(isPlayer1: false)
                //card receiving
                receive(cardTo: player2Cards)
                player2CardAmount.text = "\(player2Cards.count)"
                deliverCards(forPlayer1: false)
            }
        }
    }
}

//MARK: - NewGame delegate

extension PlayVC: NewGameDelegate {
    func startNewGame() {
        self.dismiss(animated: true, completion: nil)
        player1CardCollectionView.isHidden = true
        player2CardCollectionView.isHidden = true
        hidePlayer1CardsView.isHidden = true
        hidePlayer2CardsView.isHidden = true
        player1Cards.removeAll()
        player2Cards.removeAll()
        cardHolder.removeAll()
        updateDataSource(animated: false)
        cards = cardsWorker?.getCards() ?? []
        setOpenedCards(appeared: false)
        setClosedCards(appeared: true)
        toggleDeck(hidden: false)
    }
}

//MARK: - CollectionView delegate

extension PlayVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            let currentCard = player1Cards[indexPath.row]
            let remainedCard = cardHolder.last

            guard let cell = collectionView.cellForItem(at: indexPath) as? Player1CardCell else { return }
            animationManager.movingAnimation(from: cell, to: mainCardsStackView) {
                self.openedCards.image = UIImage(named: currentCard.name)
                self.setOpenedCards(appeared: true)
                self.cardHolder.append(currentCard)

                //TODO: - FIX  uncomment this
                self.sendData(of: currentCard.name)

                if currentCard.suit == remainedCard?.suit {
                    self.update(isPlayer1: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self]  in
                        guard let self else { return }
                        //TODO: - FIX  uncomment this
                        self.setOpenedCards(appeared: false)
                    }
                }
                
                self.removeDataSourceItem(at: indexPath)
                self.player1CardAmount.text = "\(self.player1Cards.count)"
                //TODO: - FIX  uncomment this
                self.hide(cards: true, forPlayer1: true)
                self.hide(cards: false, forPlayer1: false)
                if !self.isPlayer1 {
                    self.isPlayer1 = true
                }
                //self.isPlayer1 = !self.isPlayer1
            }
        }
    }
}

// MARK: - MC service

extension PlayVC: MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    //MARK: - Private methods
    
    //view indicates that player is waiting
    private func waitingForPeer(on: Bool) {
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
    private func loadingCountdown() {
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
            timer > 0 ? timer -= 1 : self.loadingView.addSubview(self.loadingCancelBtn)
        }
    }
    
    @objc private func cancelLoading() {
        mcAdvertiserAssistant?.stop()
        self.dismiss(animated: true, completion: nil)
    }
    
    //Create general session
    private func createSession() {
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
    
    // MARK: - Send & Receive
    
    //sending string data of card image name
    private func sendData(of card: String) {
        guard let mcSession = mcSession else { return }
        if mcSession.connectedPeers.count > 0 {
            if let imageData = card.data(using: String.Encoding.utf8) {
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    print("\(error.localizedDescription)")
                }
            }
        }
    }
    
    //receiving card image name data
    private func receiveData(of card: CardModel) {
        //last dealt card
        let previousCard = cardHolder.last
        //animations
        player2Cards.isEmpty ? flip(card: card) : give(card: card)
        //saving opened cards in card holder
        cardHolder.append(card)
        player2Cards.removeAll(where: {$0.name == card.name})
        player2CardAmount.text = "\(player2Cards.count)"
        //cards hiders
        //TODO: - FIX  uncomment this
        hide(cards: false, forPlayer1: true)
        hide(cards: true, forPlayer1: false)
        //deck hider
        toggleDeck(hidden: player1Cards.isEmpty ? false : true)
        
        // 1 Player
        if card.suit == previousCard?.suit {
            update(isPlayer1: false)
            player2CardAmount.text = "\(player2Cards.count)"
            //TODO: - FIX  uncomment this
            hide(cards: false, forPlayer1: true)
            deliverCards(forPlayer1: false)
        }
        // 2 Player
        if card.suit == previousCard?.suit {
            update(isPlayer1: false)
            //card receiving
            receive(cardTo: player2Cards)
            player1CardAmount.text = "\(player1Cards.count)"
            deliverCards(forPlayer1: true, special: true)
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
                guard let self else { return }
                //TODO: - FIX  uncomment this
                let currentCard = self.cardsWorker?.getCards().first(where: {$0.name == imageData})
                if let currentCard {
                    self.receiveData(of: currentCard)
                }
                self.cards.removeAll(where: {$0.name == imageData})
                self.checkGamePosition()
                self.updateDataSource(animated: true)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) { }
    
    //MARK: - Browser methods
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
}


/*
 TODO list:
 
 1. hiding and reappearing player cards ✅
 2. motions when taking/returning cards✅
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
 21. resolve issue when opponents cards are not changing accordingly✅
 22. fix deck of cards ability to be pressable in right logic.✅
 23. refactor and sharpen the CODE!
 24. card hiders does not work when press "play again" (new game).
 */
