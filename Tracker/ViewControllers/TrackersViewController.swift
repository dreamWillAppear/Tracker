import UIKit
import SnapKit

class TrackersViewController: UIViewController {
    
    // MARK: - Private Properties
    private let factory = TrackersFactory.shared
    
    private var completedTrackers: [TrackerRecord] = []
    
    private lazy var addTrackerButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "plus")?.withTintColor(.trackerBlack, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(didTapAddTrackerButton)
        )
        return button
    }()
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont.boldSystemFont(ofSize: 34)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        let currentDate = Date()
        let calendar = Calendar.current
        let minDate = calendar.date(byAdding: .year, value: -10, to: currentDate)
        let maxDate = calendar.date(byAdding: .year, value: 10, to: currentDate)
        datePicker.tintColor = .blue
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.calendar = Calendar(identifier: .iso8601)
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        datePicker.addTarget(self, action: #selector(datePickerValueDateChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var searchField: UISearchBar = {
        let searchField = UISearchBar()
        searchField.placeholder = "Поиск"
        searchField.searchBarStyle = .minimal
        searchField.contentMode = .scaleToFill
        return searchField
    }()
    
    private lazy var collectionViewPlaceholderStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 8
        return view
    }()
    
    private var noTrackersImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .noTrackers
        return imageView
    }()
    
    private var noTrackersLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 9
        let view = UICollectionView(frame: .zero , collectionViewLayout: layout)
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        setUI()
        setupObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: TrackersFactory.trackersUpdatedNotification, object: nil)
    }
    
    // MARK: - Private Methods
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(trackersUpdated), name: TrackersFactory.trackersUpdatedNotification, object: nil)
    }
    
    @objc private func trackersUpdated() {
        collectionView.reloadData()
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryHeaderView.identifier)
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.reuseIdentifier)
    }
    
    private func setUI() {
        view.backgroundColor = .trackerWhite
        view.addSubview(searchField)
        view.addSubview(mainLabel)
        view.addSubview(collectionView)
        view.addSubview(collectionViewPlaceholderStackView)
        
        collectionViewPlaceholderStackView.addArrangedSubview(noTrackersImageView)
        collectionViewPlaceholderStackView.addArrangedSubview(noTrackersLabel)
        
        configureNavBar()
        setConstraints()
    }
    
    private func configureNavBar() {
        navigationItem.leftBarButtonItem = addTrackerButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func updateCollectionViewPlaceholder() {
        collectionViewPlaceholderStackView.isHidden = !factory.categories.isEmpty
    }
    
    private func setConstraints() {
        mainLabel.snp.makeConstraints { make in
            make.width.equalTo(254)
            make.height.equalTo(41)
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(88)
        }
        
        datePicker.snp.makeConstraints { make in
            make.width.equalTo(120)
        }
        
        searchField.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.leading.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(8)
            make.top.equalToSuperview().offset(136)
        }
        
        collectionViewPlaceholderStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(collectionView)
        }
        
        collectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(searchField.snp.top).inset(70)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        collectionViewPlaceholderStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

    }
    
    @objc private func datePickerValueDateChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formateDate = dateFormatter.string(from: selectedDate)
        print("Date from DatePicker = \(formateDate)")
    }
    
    //MARK: - Actions
    
    @objc private func didTapAddTrackerButton() {
        let viewController = AddTrackerViewController()
        navigationController?.present(viewController, animated: true)
    }
    
}

//MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        factory.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        updateCollectionViewPlaceholder()
        return factory.categories[section].trackers.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tracker = factory.categories[indexPath.section].trackers[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.reuseIdentifier, for: indexPath) as! TrackerCell
        
        cell.configureCell(for: tracker)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset.left +
        (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset.right +
        (collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing
        let availableWidth = collectionView.frame.width - paddingSpace
        return CGSize(width: availableWidth / 2, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CategoryHeaderView.identifier, for: indexPath) as! CategoryHeaderView
        
        header.categoryTitle.text = factory.categories[indexPath.section].title
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 149, height: 18)
    }
    
}


// MARK: - Types

// MARK: - Constants

// MARK: - Public Properties

// MARK: - IBOutlet

// MARK: - Private Properties

// MARK: - Initializers

// MARK: - UIViewController(*)

// MARK: - Public Methods

// MARK: - IBAction

// MARK: - Private Methods

