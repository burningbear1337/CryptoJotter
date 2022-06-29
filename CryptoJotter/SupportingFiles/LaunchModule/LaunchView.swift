//
//  LaunchView.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 24.06.2022.
//

import UIKit

protocol ILaunchView: AnyObject {
    func animate() 
}

final class LaunchView: UIView {
    
    private lazy var backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "box")
        return imageView
    }()
    
    private lazy var coinsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "coins")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var forwardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "box-forward")
        return imageView
    }()

    
    private lazy var loadingTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading Coins Data..."
        label.font = AppFont.semibold17.font
        label.textColor = UIColor.theme.secondaryColor
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        self.setupLayout()
        self.animateView()
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LaunchView {
    func setupLayout() {
        self.backgroundColor = UIColor.theme.backgroundColor
        
        self.addSubview(self.backImageView)
        self.backImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.backImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.backImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.backImageView.heightAnchor.constraint(equalToConstant: 100),
            self.backImageView.widthAnchor.constraint(equalToConstant: 100),
        ])
        
        self.addSubview(self.coinsImageView)
        self.coinsImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.coinsImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.coinsImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: -30),
            self.coinsImageView.heightAnchor.constraint(equalToConstant: 100),
            self.coinsImageView.widthAnchor.constraint(equalToConstant: 100),
        ])
        
        self.addSubview(self.forwardImageView)
        self.forwardImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.forwardImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.forwardImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.forwardImageView.heightAnchor.constraint(equalToConstant: 100),
            self.forwardImageView.widthAnchor.constraint(equalToConstant: 100),
        ])

        
        self.addSubview(self.loadingTextLabel)
        self.loadingTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.loadingTextLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -150),
            self.loadingTextLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func animateView() {
        self.loadingTextLabel.alpha = 0
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3) {

            self.loadingTextLabel.transform = CGAffineTransform(translationX: 0, y: -150)
            self.loadingTextLabel.alpha = 1
        }
        self.coinsImageView.alpha = 0
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3) {
            self.coinsImageView.transform = CGAffineTransform(translationX: 0, y: -20)
            self.coinsImageView.alpha = 1
        }
    }
}
