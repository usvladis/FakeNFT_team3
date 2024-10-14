//
//  ДocalizedString.swift
//  FakeNFT
//
//  Created by Владислав Усачев on 11.10.2024.
//

import Foundation

func localizedString(key: String, comment: String = "") -> String {
    return NSLocalizedString(key, comment: comment)
}
