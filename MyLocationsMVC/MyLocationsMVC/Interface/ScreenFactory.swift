//
//  ScreenFactory.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 04/12/2021.
//

import UIKit

final class ScreenFactory {
    static func makeGetLocationController() -> UIViewController {
        let controller = GetLocationViewController()
        controller.tabBarItem = UITabBarItem(
            title: "Tag",
            image: UIImage(named: "Tag"),
            tag: 0
        )
        return controller
    }
    
    static func makeLocationsViewController() -> UIViewController {
        let controller = LocationsViewController()
        controller.tabBarItem = UITabBarItem(
            title: "Locations",
            image: UIImage(named: "Locations"),
            tag: 0
        )
        return controller
    }
}
