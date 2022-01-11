//
//  LaunchScreenVC.swift
//  Pigobana
//
//  Created by Saba Khitaridze on 11.01.22.
//

import UIKit

class LaunchScreenVC: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        progressView.setProgress(2.5, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.7, execute: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PlayVC")
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        })
    }
}
