//
//  ViewConfigurableProtocol.swift
//  FakeNFT
//
//  Created by Дмитрий Жуков on 10/9/24.
//

import UIKit

protocol ViewConfigurable {
    func addSubviews()
    func addConstraints()
    func configureView()
}


extension ViewConfigurable where Self: UIViewController {
    func configureView() {
        addSubviews()
        addConstraints()
    }
}
