//
//  UIViewController+Alert.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 04/12/2021.
//

import UIKit

extension UIViewController {
    func handle(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { _ in
            self.dismiss(animated: true)
        }
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}
