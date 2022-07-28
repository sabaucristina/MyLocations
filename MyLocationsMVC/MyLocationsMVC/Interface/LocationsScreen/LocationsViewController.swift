//
//  LocationsViewController.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 04/12/2021.
//

import UIKit

final class LocationsViewController: UIViewController {
    private lazy var tableView = UITableView()
    var viewModel = LocationsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onReload = { isEmpty in
            self.reload(isEmpty: isEmpty)
        }
        viewModel.onError = { error in
            self.view.makeToast(error.localizedDescription)
        }
        setupTableView()
        setupHierachy()
        setupConstraints()
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getLocations()
    }
    
    override func setEditing(
        _ editing: Bool,
        animated: Bool
    ) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
    }
}
//MARK: Behaviour

private extension LocationsViewController {
    func reload(isEmpty: Bool) {
        tableView.backgroundView = isEmpty ? makeEmptyView(): nil
        tableView.reloadData()
    }
    
    func makeEmptyView() -> UILabel {
        let lab = UILabel()
        lab.text = "No locations yet"
        lab.textAlignment = .center
        return lab
    }
}

//MARK: SetupUI
private extension LocationsViewController {
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(
            LocationCellView.self,
            forCellReuseIdentifier: LocationCellView.identifierName
        )
        
        tableView.register(
            CustomHeaderView.self,
            forHeaderFooterViewReuseIdentifier: CustomHeaderView.identifierName
        )
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupHierachy() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.pinToSuperviewEdges()
    }
    
    func setupNavBar() {
        title = "Locations"
        navigationItem.rightBarButtonItem = editButtonItem
    }
}

//MARK: TableView - Delegate & DataSource
extension LocationsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.numberOfRowsInSection(atSection: section)
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomHeaderView.identifierName)
        
        let headerTitle = viewModel.headerTitle(atSection: section)
        let model = CustomHeaderView.Model(title: headerTitle)
        (headerView as? CustomHeaderView)?.update(model: model)
        
        return headerView
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let location = viewModel.getLocation(atIndex: indexPath)
        
        let locationModel = LocationCellView.Model(
            description: location.description,
            address: location.address,
            photoURL: PhotoSavingService.photoURL(using: location.id)
        )
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: LocationCellView.identifierName,
            for: indexPath
        )
        (cell as? LocationCellView)?.update(model: locationModel)
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        switch editingStyle {
        case .delete:
            viewModel.deleteLocation(atIndex: indexPath)
        default:
            break
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let location = viewModel.getLocation(atIndex: indexPath)
        let detailsViewModel = DetailsViewModel(
            location: location,
            dataMode: .update
        ) { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        
        let detailsController = DetailsViewController(
            viewModel: detailsViewModel
        )
        navigationController?.pushViewController(detailsController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
