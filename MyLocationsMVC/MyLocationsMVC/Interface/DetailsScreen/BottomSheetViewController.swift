//
//  BottomSheetViewController.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 09/02/2022.
//

import Foundation
import UIKit

final class BottomSheetViewController: UITableViewController {
    var selectedIndex: IndexPath?
    enum Categories: CaseIterable {
        case appleStore
        case bar
        case bookstore
        case club
        case groceryStore
        case historicBuilding
        case house
        case icecreamVendor
        case landmark
        case park
        
        var name: String {
            switch self {
            case .appleStore:
                return "Apple Store"
            case .bar:
                return "Bar"
            case .bookstore:
                return "Bookstore"
            case .club:
                return "Club"
            case .groceryStore:
                return "Grocery Store"
            case .historicBuilding:
                return "Historic Building"
            case .house:
                return "House"
            case .icecreamVendor:
                return "Icecream Vendor"
            case .landmark:
                return "Landmark"
            case .park:
                return "Park"
            }
        }
    }
    
    private let onCategorySelected: (String) -> Void
    
    init(
        selectedCategory: String?,
        onCategorySelected: @escaping (String) -> Void
    ) {
        if let selectedCategory = selectedCategory {
            if let rowIndex = Categories.allCases.firstIndex(where: { $0.name == selectedCategory }) {
                selectedIndex = IndexPath(row: rowIndex, section: 0)
            }
        }
        self.onCategorySelected = onCategorySelected
        super.init(nibName: nil, bundle: nil)
        self.additionalSafeAreaInsets = .init(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            SimpleCellView.self,
            forCellReuseIdentifier: SimpleCellView.identifierName
        )
    }
}
extension BottomSheetViewController {
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        Categories.allCases.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let category = Categories.allCases[indexPath.row].name
        let cell = tableView.dequeueReusableCell(withIdentifier: SimpleCellView.identifierName, for: indexPath) as! SimpleCellView
        var accesory = SimpleCellView.Model.AccesoryType.checkmark(false)
        
        if indexPath == selectedIndex {
            accesory = SimpleCellView.Model.AccesoryType.checkmark(true)
        }
        
        let simpleModel = SimpleCellView.Model.init(title: "\(category)", accesory: accesory)
        cell.update(model: simpleModel)
        
        return cell
    }
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let newSelectedCategoryName = Categories.allCases[indexPath.row].name
        
        if let newCell = tableView.cellForRow(at: indexPath) {
            let accesory = SimpleCellView.Model.AccesoryType.checkmark(true)
            let simpleModel = SimpleCellView.Model.init(title: "\(newSelectedCategoryName)", accesory: accesory)
            (newCell as! SimpleCellView).update(model: simpleModel)
        }
        
        selectedIndex = indexPath
        onCategorySelected(newSelectedCategoryName)
    }
}
