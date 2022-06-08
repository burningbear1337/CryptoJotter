//
//  DetailsView.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 07.06.2022.
//

import UIKit

protocol IDetailsView: AnyObject {
    func setData(data: CoinModel?)
}

final class CustomDetailsView: UIView {
    
    private lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private var data: CoinModel?
    
    private lazy var coinNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.theme.greenColor
        label.font = AppFont.semibold17.font
        label.textAlignment = .center
        return label
    }()
    
    private lazy var coinImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var low24HLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.theme.accentColor
        label.font = UIFont.systemFont(ofSize: 35)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupElementsData()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomDetailsView: IDetailsView {
    func setData(data: CoinModel?) {
        self.data = data
        self.imageLoader(url: data?.image)
        setupElementsData()
    }
}

private extension CustomDetailsView {
    
    func setupElementsData() {
        self.coinNameLabel.text = self.data?.name
        imageLoader(url: self.data?.image)
    }
    
    func setupLayout() {
        self.setupScrollView()
        self.setupCoinNameLabel()
        self.setupCoinImage()
        
    }
    
    func setupScrollView() {
        self.addSubview(self.scrollView)
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
        
    func setupCoinNameLabel() {
        self.scrollView.addSubview(self.coinNameLabel)
        NSLayoutConstraint.activate([
            self.coinNameLabel.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 20),
            self.coinNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.coinNameLabel.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor)
        ])
    }
    
    func setupCoinImage() {
        self.scrollView.addSubview(self.coinImage)
        NSLayoutConstraint.activate([
            self.coinImage.centerYAnchor.constraint(equalTo: self.coinNameLabel.centerYAnchor),
            self.coinImage.trailingAnchor.constraint(equalTo: self.coinNameLabel.leadingAnchor, constant: -10),
            self.coinImage.heightAnchor.constraint(equalToConstant: 24),
            self.coinImage.widthAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    func setupLow24H() {
        
    }
    
    func imageLoader(url: String?) {
        guard let url = url else { return }
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        URLSession.shared.downloadTask(with: request) { url, response, error in
            if let error = error {
                print(error)
            }
            guard let url = url else { return }
            
            let data = try? Data(contentsOf: url)
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                let imageView = UIImageView(image: UIImage(data: data))
                self.coinImage.image = imageView.image
            }
        }.resume()
    }
}

