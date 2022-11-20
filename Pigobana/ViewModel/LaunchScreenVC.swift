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
        launchingUI(for: [singlePlayerBtn, multiPlayerBtn, howToPlayBtn])
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
    
    //MARK: - Methods
    private func launchingUI(for buttons: [UIButton]) {
        //for progressView
        progressView.setProgress(1, animated: true)
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
        buttons.forEach {
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = UIColor.black.cgColor
            $0.layer.cornerRadius = 15
            $0.layer.shadowRadius = 10
            $0.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            $0.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
            $0.layer.shadowOpacity = 0.8
        }
    }
}
