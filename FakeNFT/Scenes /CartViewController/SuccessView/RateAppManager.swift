//
//  RateAppManager.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 12.11.2024.
//

import UIKit

final class RateAppManager {

    static let shared = RateAppManager()

    private init() {}

    private let hasRatedAppKey = "hasRatedApp"
    private let declineCounterKey = "declineCounter"

    func shouldShowRateAlert() -> Bool {
        let hasRatedApp = UserDefaults.standard.bool(forKey: hasRatedAppKey)
        if hasRatedApp {
            return false
        }

        let declineCounter = UserDefaults.standard.integer(forKey: declineCounterKey)

        if declineCounter == 0 {
            return true
        } else if declineCounter < 2 {
            incrementDeclineCounter()
            return false
        } else if declineCounter == 2 {
            return true
        } else {
            return false
        }
    }

    func showRateAppAlert(on viewController: UIViewController, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: localizedString(key: "rateAlertTitle"),
            message: localizedString(key: "rateAlertMessage"),
            preferredStyle: .alert
        )

        let laterAction = UIAlertAction(title: localizedString(key: "rateAlertLater"), style: .default) { _ in
            self.incrementDeclineCounter()
            completion?()
        }

        let rateAction = UIAlertAction(title: localizedString(key: "rateAlertOk"), style: .cancel) { _ in
            if let url = URL(string: Constants.rateAlertUrl) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            self.setUserRatedApp()
            completion?()
        }

        alert.addAction(laterAction)
        alert.addAction(rateAction)

        viewController.present(alert, animated: true, completion: nil)
    }

    private func setUserRatedApp() {
        UserDefaults.standard.set(true, forKey: hasRatedAppKey)
    }

    private func incrementDeclineCounter() {
        var declineCounter = UserDefaults.standard.integer(forKey: declineCounterKey)
        declineCounter += 1
        UserDefaults.standard.set(declineCounter, forKey: declineCounterKey)
    }
}
