//
//  LaunchPresenter.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 16.06.2022.
//

import Foundation

protocol ILaunchPresenter: AnyObject {
    func present()
    func dismiss(completion: @escaping ()->())
}

final class LaunchPresenter: ILaunchPresenter {
    func present() {
        
    }
    
    func dismiss(completion: @escaping () -> ()) {
        
    }
}
