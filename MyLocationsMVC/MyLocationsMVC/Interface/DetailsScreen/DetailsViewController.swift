//
//  DetailsViewController.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 27/01/2022.
//

import Foundation
import UIKit
import CoreLocation
import Toast_Swift

final class DetailsViewController: UIViewController {
    private lazy var tableView = UITableView()
    private var doneButton: HoverButtonView!
    
    var viewModel: DetailsViewModel
    
    init(
        viewModel: DetailsViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavBarItem()
        setupHierarchy()
        setupTableView()
        viewModel.reloadDataSource()
        doneButton.isEnabled = viewModel.isButtonEnabled()
        
        viewModel.onAction = { [weak self] action in
            switch action {
            case let .handleError(error):
                self?.view.makeToast(error.localizedDescription)
                
            case let .dismiss(completion):
                self?.dismiss(animated: true, completion: completion)
                
            case let .presentBottomSheet(bottomController):
                self?.present(bottomController, animated: true)
                
            case .reload:
                self?.tableView.reloadData()
                
            case .showPhotoMenu:
                self?.showPhotoMenu()
                
            case .validateDoneButtonState:
                self?.doneButton.isEnabled = self?.viewModel.isButtonEnabled() ?? false
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func setupNavBarItem() {
        title = ""
        navigationItem.rightBarButtonItem = nil
    }
    
    func setupHierarchy() {
        view.addSubview(tableView)
        doneButton = addHoverButton(
            model: viewModel.doneButtonModel,
            to: view,
            over: tableView
        )
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            SimpleCellView.self,
            forCellReuseIdentifier: SimpleCellView.identifierName
        )
        
        tableView.register(
            TextViewCell.self,
            forCellReuseIdentifier: TextViewCell.identifierName
        )
        
        tableView.register(
            ActionCellView.self,
            forCellReuseIdentifier: ActionCellView.identifierName
        )
        
        tableView.register(
            CustomHeaderView.self,
            forHeaderFooterViewReuseIdentifier: CustomHeaderView.identifierName
        )
        
        tableView.pinToSuperviewEdges()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

//MARK: TableView - Delegate and Data source
extension DetailsViewController: UITableViewDataSource, UITableViewDelegate{
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
        case let .textView(model):
            (cell as? TextViewCell)?.update(model: model)
        case let .action(model):
            (cell as? ActionCellView)?.update(model: model)
        }
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        viewModel.celModelOnTap(atIndex: indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomHeaderView.identifierName) as? CustomHeaderView
        
        let model = CustomHeaderView.Model(title: "DESCRIPTION")
        headerView?.update(model: model)
        
        return headerView
    }
}

//MARK: ImagePicker Helper Methods and Delegate
extension DetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        if let image = image {
            viewModel.locationPhotoModel.accesory = ActionCellView.Model.AccesoryType.image(image)
            viewModel.locationImage = image
            viewModel.reloadDataSource()
            tableView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: HelperMethods
extension DetailsViewController {
    func showPhotoMenu() {
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let cancel = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        alert.addAction(cancel)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let photoAction = UIAlertAction(
                title: "Take Photo",
                style: .default
            ) { [ weak self ] _ in
                guard let self = self else { return }
                self.takePhotoWithCamera()
            }
            alert.addAction(photoAction)
        }
        
        let libraryAction = UIAlertAction(
            title: "Choose from library",
            style: .default
        ) { [ weak self ] _ in
            guard let self = self else { return }
            self.choosePhotoFromLibrary()
        }
        alert.addAction(libraryAction)
        
        present(alert, animated: true, completion: nil)
    }
}
