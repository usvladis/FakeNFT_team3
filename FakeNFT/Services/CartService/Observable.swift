//
//  Observerd.swift
//  FakeNFT
//
//  Created by Владислав Усачев on 01.11.2024.
//

import Foundation

final class Observable<T> {
    private var valueChanged: ((T) -> Void)?

    var value: T {
        didSet {
            valueChanged?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(_ listener: @escaping (T) -> Void) {
        listener(value)
        self.valueChanged = listener
    }
}
