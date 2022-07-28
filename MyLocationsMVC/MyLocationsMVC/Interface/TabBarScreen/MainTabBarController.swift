//
//  MainTabBarController.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 04/12/2021.
//

import UIKit

final class MainTabBarController: UITabBarController {
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
        setupControllers()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup

private extension MainTabBarController {
    func setupTabBar() {
        tabBar.backgroundColor = .systemBackground
    }
    
    func setupControllers() {
        viewControllers = [
            UINavigationController(rootViewController: ScreenFactory.makeGetLocationController()),
            UINavigationController(rootViewController: ScreenFactory.makeLocationsViewController())
        ]
    }
}
