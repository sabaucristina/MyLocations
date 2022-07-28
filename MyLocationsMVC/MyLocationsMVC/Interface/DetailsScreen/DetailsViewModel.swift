//
//  DetailsViewModel.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 11/03/2022.
//

import UIKit

final class DetailsViewModel {
    private let didUpdateSuccessfully: () -> Void
    private lazy var locationDescription = makeTextViewModel()
    private var selectedCategory: String? {
        didSet {
            onAction?(.validateDoneButtonState)
        }
    }
    private let apiService: APIServiceProtocol
    private let location: Location
    private var cellModels = [CellModels]()
    private let dataMode: Mode
    
    enum Mode {
        case update
        case create
    }
    
    enum Constants {
        static let bottomSheetCornerRadius: CGFloat = 20
    }
    
    enum CellModels {
        case simple(SimpleCellView.Model)
        case textView(TextViewCell.Model)
        case action(ActionCellView.Model)
        
        var identifier: String {
            switch self {
            case .simple:
                return SimpleCellView.identifierName
            case .textView:
                return TextViewCell.identifierName
            case .action:
                return ActionCellView.identifierName
            }
        }
        
        var onTap: (() -> Void)? {
            switch self {
            case .simple:
                return nil
            case let .action(model):
                return model.action
            case .textView:
                return nil
            }
        }
    }
    
    enum Action {
        case presentBottomSheet(BottomSheetViewController)
        case reload
        case dismiss(completion: (() -> Void)? = nil)
        case handleError(Error)
        case showPhotoMenu
        case validateDoneButtonState
    }
    
    lazy var locationPhotoModel = makePhotoActionCellModel()
    lazy var locationImage: UIImage? = makeInitialLocationImage()
    
    lazy var doneButtonModel = makeHoverButtonModel()
    var onAction: ((Action) -> Void)?
    
    init(
        location: Location,
        dataMode: Mode,
        didUpdateSuccessfully: @escaping () -> Void,
        apiService: APIServiceProtocol
    ) {
        self.didUpdateSuccessfully = didUpdateSuccessfully
        self.location = location
        self.selectedCategory = location.category
        self.apiService = apiService
        self.dataMode = dataMode
    }
    
    convenience init(
        location: Location,
        dataMode: Mode,
        didUpdateSuccessfully: @escaping () -> Void
    ) {
        self.init(
            location: location,
            dataMode: dataMode,
            didUpdateSuccessfully: didUpdateSuccessfully,
            apiService: APIService()
        )
    }
    
    func numberOfRowsInSection() -> Int {
        cellModels.count
    }
    
    func getCellModel(atIndex indexPath: IndexPath) -> CellModels {
        cellModels[indexPath.row]
    }
    
    func celModelOnTap(atIndex indexPath: IndexPath) {
        cellModels[indexPath.row].onTap?()
    }
    
    func reloadDataSource() {
        cellModels = [
            .textView(locationDescription),
            .action(makeCategoryActionCellModel()),
            .action(locationPhotoModel),
            .simple(SimpleCellFactory.latitude(location.latitude)),
            .simple(SimpleCellFactory.longitude(location.longitude)),
            .simple(.init(title: "Address", accesory: SimpleCellView.Model.AccesoryType.text( location.address.formattedAddress()))),
            .simple(.init(title: "Date", accesory: SimpleCellView.Model.AccesoryType.text( DateFormatter.formatter.string(from: location.date))))
        ]
    }
    
    func isButtonEnabled() -> Bool {
        guard let category = selectedCategory,
              let descriptionText = locationDescription.text else { return false }
        
        return !category.isEmpty && descriptionText.count >= 3
    }
}

//MARK: Cell Models Makers
private extension DetailsViewModel {
    func makeHoverButtonModel() -> HoverButtonView.Model {
        .init(
            title: "Done",
            titleFont: .systemFont(ofSize: 20),
            action: { [weak self] in
                guard let weakSelf = self else { return }
                
                switch weakSelf.dataMode {
                case .create:
                    let locationDto = LocationCreateDto(
                        latitude: weakSelf.location.latitude,
                        longitude: weakSelf.location.longitude,
                        description: weakSelf.locationDescription.text ,
                        category: weakSelf.selectedCategory ?? "No Category",
                        address: .init(address: weakSelf.location.address)
                    )
                    weakSelf.apiService.addLocation(with: locationDto) { [weak self] result in
                        guard let self = self else { return }
                        
                        switch result {
                        case let .success(location):
                            self.didUpdateSuccessfully()
                            self.saveLocationImage(withName: location.id)
                        case let .failure(error):
                            self.onAction?(.handleError(error))
                        }
                        
                    }
                case .update:
                    let location = LocationUpdateDto(
                        description: weakSelf.locationDescription.text,
                        category: weakSelf.selectedCategory ?? "No Category"
                    )
                    weakSelf.apiService.updateLocation(
                        id: weakSelf.location.id,
                        with: location
                    ) { [weak self] result in
                        guard let self = self else { return }
                        
                        switch result {
                        case .success:
                            self.didUpdateSuccessfully()
                            self.saveLocationImage(withName: self.location.id)
                        case let .failure(error):
                            self.onAction?(.handleError(error))
                        }
                    }
                }
            }
        )
    }
    
    func makeCategoryActionCellModel() -> ActionCellView.Model {
        return ActionCellView.Model(
            title: "Category",
            accesory: .text(selectedCategory ?? "(No Category)"),
            actionIcon: Icon.chevron,
            action: { [weak self] in
                guard let weakSelf = self else { return }
                
                let bottomController = weakSelf.makeCategorySelectionBottomSheet()
                weakSelf.onAction?(.presentBottomSheet(bottomController))
            }
        )
    }
    func makePhotoActionCellModel() -> ActionCellView.Model {
        let accessoryType: ActionCellView.Model.AccesoryType
        
        if let image = locationImage {
            accessoryType = .image(image)
        } else {
            accessoryType = .none
        }
        return ActionCellView.Model(
            title: "Add Photo",
            accesory: accessoryType,
            actionIcon: Icon.chevron,
            action: { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.onAction?(.showPhotoMenu)
            }
        )
    }
    
    func makeTextViewModel() -> TextViewCell.Model {
        return TextViewCell.Model(
            placeholder: "(Description goes here)",
            text: location.description,
            textDidChange: { [weak self] _ in
                guard let self = self else { return }
                self.onAction?(.validateDoneButtonState)
            }
        )
    }
}

//MARK: Helper Methods
private extension DetailsViewModel {
    func saveLocationImage(withName photoName: String) {
        guard let image = locationImage else { return }
        PhotoSavingService.saveLocationImage(
            locationImage: image,
            photoName: photoName
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                break
            case let .failure(error):
                self.onAction?(.handleError(error))
            }
        }
    }
    
    func makeInitialLocationImage() -> UIImage? {
        let photoUrl = PhotoSavingService.photoURL(using: location.id)
        return UIImage(contentsOfFile: photoUrl.path)
    }
    
    func makeCategorySelectionBottomSheet() -> BottomSheetViewController {
        let bottomSheetController = BottomSheetViewController(
            selectedCategory: selectedCategory,
            onCategorySelected:  { [weak self] selectedCategory in
                
                guard let self = self else { return }
                self.onAction?(
                    .dismiss(
                        completion: {
                            self.selectedCategory = selectedCategory
                            self.reloadDataSource()
                            self.onAction?(.reload)
                        }
                    )
                )
            }
        )
        bottomSheetController.modalPresentationStyle = .pageSheet
        if let sheet = bottomSheetController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.selectedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.preferredCornerRadius = Constants.bottomSheetCornerRadius
            sheet.prefersGrabberVisible = true
        }
        return bottomSheetController
    }
}
