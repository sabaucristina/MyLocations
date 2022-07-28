//
//  GetLocationViewController.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 04/12/2021.
//

import UIKit
import CoreLocation
import Contacts
import Toast_Swift

final class GetLocationViewController: UIViewController {
    private lazy var locationButtonModel = makeLocationButtonModel()
    private lazy var tableView = UITableView()
    private var getLocationButton: HoverButtonView!
    private var observer: AnyObject?
    private let viewModel = GetLocationViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupHierarchy()
        setupConstraints()
        setupNavBar()
        
        viewModel.onReload = { [weak self] in
            self?.reloadData()
        }
        viewModel.onFailure = { [weak self] error in
            self?.handle(error)
        }
        viewModel.locationUpdated = { [weak self] in
            self?.getLocationButton.isHidden = false
            self?.showRightBarButton()
        }
        
        if viewModel.hasLocationPermission() {
            return viewModel.updateLocationOnce()
        }
        
        getLocationButton.isHidden = true
        hideRightBarButton()
        reloadData()
        subscribe()
    }
    
    deinit {
        unsubscribe()
    }
    
    func subscribe() {
        unsubscribe()
        observer = NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: OperationQueue.current
        ) { [weak self]_ in
            guard let weakSelf = self else { return }
            
            if weakSelf.viewModel.hasLocationPermission() {
                weakSelf.viewModel.updateLocationOnce()
                weakSelf.getLocationButton.isHidden = false
                weakSelf.showRightBarButton()
            } else {
                weakSelf.hideRightBarButton()
                weakSelf.reloadData()
            }
        }
    }
    
    func unsubscribe() {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
            self.observer = nil
        }
    }
}
//MARK: Actions
extension GetLocationViewController {
    
    @objc
    func updateContinuousTapped() {
        if viewModel.isUpdatingLocationLive() {
            viewModel.stopUpdating()
            navigationItem.rightBarButtonItem?.title = "Start"
            setLocationButton(visible: true)
        } else {
            viewModel.updateLatestLocation()
            navigationItem.rightBarButtonItem?.title = "Stop"
            setLocationButton(visible: false)
        }
    }
}

extension GetLocationViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.numberOfRowsInSection()
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cellModel = viewModel.getCellModel(atIndex: indexPath)
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellModel.identifier,
            for: indexPath
        )
        
        switch cellModel {
        case let .simple(model):
            (cell as? SimpleCellView)?.update(model: model)
        case let .address(model):
            (cell as? AddressDescriptionCellView)?.update(model: model)
        case let .widget(model):
            (cell as? WidgetCellView)?.update(model: model)
        }
        return cell
    }
}

private extension GetLocationViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        setupTableView()
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            SimpleCellView.self,
            forCellReuseIdentifier: SimpleCellView.identifierName
        )
        tableView.register(
            AddressDescriptionCellView.self,
            forCellReuseIdentifier: AddressDescriptionCellView.identifierName
        )
        tableView.register(
            WidgetCellView.self,
            forCellReuseIdentifier: WidgetCellView.identifierName
        )
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupHierarchy() {
        view.addSubview(tableView)
        getLocationButton = addHoverButton(
            model: locationButtonModel,
            to: view,
            over: tableView
        )
    }
    
    func setupConstraints() {
        tableView.pinToSuperviewEdges()
    }
    
    func setupNavBar() {
        title = "My location"
        navigationItem.rightBarButtonItem = .init(
            title: "Start",
            style: .plain,
            target: self,
            action: #selector(updateContinuousTapped)
        )
        
        navigationItem.backButtonDisplayMode = .generic
    }
    
    func hideRightBarButton() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.title = ""
    }
    
    func showRightBarButton() {
        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationItem.rightBarButtonItem?.title = "Start"
    }
    
    func makeLocationButtonModel() -> HoverButtonView.Model {
        .init(
            title: "Pin location",
            titleFont: .systemFont(ofSize: 22),
            action: { [weak self] in
                guard let self = self else { return }
                guard let location = self.viewModel.latestLocation else { return }
                let detailsViewModel = DetailsViewModel(
                    location: location,
                    dataMode: .create,
                    didUpdateSuccessfully: { [weak self] in
                        guard let self = self else { return }
                        
                        self.navigationController?.popViewController(animated: true)
                        self.view.makeToast(
                            "Yay! Great Success!",
                            duration: 3,
                            position: .top
                        )
                    }
                )

                self.navigationController?.pushViewController(
                    DetailsViewController(
                        viewModel: detailsViewModel
                    ),
                    animated: true
                )
            }
        )
    }
}

//MARK: - Behaviour

private extension GetLocationViewController {
    func reloadData() {
        if let location = viewModel.latestLocation {
            viewModel.updateCellModelsWithLocation(location: location)
            tableView.separatorStyle = .singleLine
        } else {
            viewModel.updateCellModelsWithoutLocation()
            tableView.separatorStyle = .none
        }

        tableView.reloadSections(.init(integer: 0), with: .automatic)
    }
    
    func setLocationButton(visible: Bool) {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                if visible {
                    self.getLocationButton.isHidden = false
                    self.getLocationButton.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.getLocationButton.alpha = 1
                } else {
                    self.getLocationButton.transform = CGAffineTransform(translationX: 0, y: 100)
                    self.getLocationButton.alpha = 0
                }
            },
            completion: { _ in
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.getLocationButton.isHidden = !visible
            }
        )
    }
}

