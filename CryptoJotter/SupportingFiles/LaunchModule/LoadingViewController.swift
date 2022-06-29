//
//  TabbarAssembly.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 06.06.2022.
//

import UIKit

final class LoadingViewController: UIViewController {
    
    private var customView = LaunchView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.customView
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTransition()
    }
}

private extension LoadingViewController {
    func setupTransition() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            let nextVC = TabbarAssembly.build()
            nextVC.modalPresentationStyle = .fullScreen
            nextVC.modalTransitionStyle = .crossDissolve
            self.present(nextVC, animated: true)
        }
    }
}
