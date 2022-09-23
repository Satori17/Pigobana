//
//  LaunchScreenVC.swift
//  Pigobana
//
//  Created by Saba Khitaridze on 11.01.22.
//

import UIKit

class LaunchScreenVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var singlePlayerBtn: UIButton!
    @IBOutlet weak var multiPlayerBtn: UIButton!
    @IBOutlet weak var howToPlayBtn: UIButton!
    
    //MARK: - Managers
    private var animationManager = AnimationManager()
    
    //MARK: - Properties
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        launchingUI(for: singlePlayerBtn)
        launchingUI(for: multiPlayerBtn)
        launchingUI(for: howToPlayBtn)
    }
    
    
    //MARK: - IBActions
    
    //1 player
    @IBAction func singlePlayerBtnPressed(_ sender: UIButton) {
        animationManager.pressingAnimation(sender)
    }
    
    //2 player
    @IBAction func multiPlayerBtnPressed(_ sender: UIButton) {
        animationManager.pressingAnimation(sender)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            //transition to PlayVC
            let storyboard = UIStoryboard(name: VCIds.main, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: VCIds.playVC)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    //How to play
    @IBAction func howToPlayBtnPressed(_ sender: UIButton) {
        animationManager.pressingAnimation(sender)
    }
    
}
