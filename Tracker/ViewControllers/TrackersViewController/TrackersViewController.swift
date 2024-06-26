import UIKit
import SnapKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let dateFormatter = DateFormatter()
    private let currentCalendar = TrackerCalendar.currentCalendar
    private var currentDate: Date = Date()
    private let categoriesUpdatedNotification = TrackersFactory.trackersForShowingUpdatedNotification
    private let factory = TrackersFactory.shared
    private var completedTrackers: [TrackerRecord] = []
    
    private var categoriesForShowing: [TrackerCategory] = [] {
        didSet {
            NotificationCenter.default.post(name: categoriesUpdatedNotification, object: nil)
        }
    }
    
    private lazy var addTrackerButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "plus")?
                .withTintColor(.trackerBlack, renderingMode: .alwaysOriginal),
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
        let calendar = currentCalendar
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
    
    private lazy var filtersButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .trackerBlue
        button.setTitle("Фильтры", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.tintColor = .trackerWhite
        button.layer.cornerRadius = 16
        button.isHidden = true
        return button
    }()
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        setUI()
        setupObservers()
        configureDismissingKeyboard()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: categoriesUpdatedNotification, object: nil)
    }
    
    // MARK: - Private Methods
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(categoriesUpdated), name: categoriesUpdatedNotification, object: nil)
    }
    
    @objc private func categoriesUpdated() {
        collectionView.reloadData()
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            CategoryHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CategoryHeaderView.identifier)
        
        collectionView.register(
            TrackerCell.self,
            forCellWithReuseIdentifier: TrackerCell.reuseIdentifier)
    }
    
    private func configureDismissingKeyboard() {
        let tapAssideKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapAssideKeyboard.cancelsTouchesInView = false
        view.addGestureRecognizer(tapAssideKeyboard)
        searchField.delegate = self
    }
    
    private func setUI() {
        view.backgroundColor = .trackerWhite
        
        [searchField,
         mainLabel,
         collectionView,
         collectionViewPlaceholderStackView,
         collectionViewPlaceholderStackView,
         filtersButton].forEach {
            view.addSubview($0)
        }
        
        [noTrackersImageView,
         noTrackersLabel].forEach {
            collectionViewPlaceholderStackView.addArrangedSubview($0)
        }
        
        configureNavBar()
        setConstraints()
    }
    
    private func configureNavBar() {
        navigationItem.leftBarButtonItem = addTrackerButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func updateCollectionViewPlaceholder(forSearch: Bool) {
        collectionViewPlaceholderStackView.isHidden = !factory.trackersForShowing.isEmpty
        filtersButton.isHidden = factory.trackersForShowing.isEmpty
        
        if forSearch {
            noTrackersImageView.image = .noSearchResult
            noTrackersLabel.text = "Ничего не найдено"
        } else {
            noTrackersImageView.image = .noTrackers
            noTrackersLabel.text = "Что будем отслеживать?"
        }
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
        
        filtersButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
            make.width.equalTo(114)
            make.height.equalTo(50)
        }
        
    }
    
    //MARK: - Actions
    
    @objc private func datePickerValueDateChanged(_ sender: UIDatePicker) {
        DispatchQueue.main.async {
            self.updateCollectionViewPlaceholder(forSearch: false)
        }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        currentDate = sender.date
        let weekday = currentCalendar.component(.weekday, from: currentDate)
        factory.weekdayIndex = ((weekday + 5) % 7)
        factory.updateTrackersForShowing()
    }
    
    @objc private func didTapAddTrackerButton() {
        let viewController = AddTrackerViewController()
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        factory.trackersForShowing.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        updateCollectionViewPlaceholder(forSearch: false)
        return factory.trackersForShowing[section].trackers.count
    }
    
    //MARK: - ConfigureCell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.reuseIdentifier, for: indexPath) as? TrackerCell else {
            return .init()
        }
        
        let tracker = factory.trackersForShowing[indexPath.section].trackers[indexPath.item]
        
        cell.configureCell(for: tracker, date: currentDate)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return .init() }
        let paddingSpace = layout.sectionInset.left + layout.sectionInset.right + layout.minimumInteritemSpacing
        let availableWidth = collectionView.frame.width - paddingSpace
        return .init(width: availableWidth / 2, height: 148)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CategoryHeaderView.identifier,
            for: indexPath
        ) as? CategoryHeaderView else { return .init() }
        
        header.categoryTitle.text = factory.trackersForShowing[indexPath.section].title
        return header
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        .init(width: 149, height: 18)
    }
}

extension TrackersViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        switch searchText{
                
            case "":
                updateCollectionViewPlaceholder(forSearch: false)
                searchBar.setShowsCancelButton(false, animated: true)
                factory.trackersForShowing = factory.filterTrackers(in: factory.trackersStorage, forDayWithIndex: factory.weekdayIndex)
            default:
                //без асинхронного вызова заглушка появляется только после ввода второго символа. Видимо потому что trackersForShowing: [TrackerCategory] уже пуст, но UI еще обновился?
                DispatchQueue.main.async {
                    self.updateCollectionViewPlaceholder(forSearch: true)
                }
                searchBar.setShowsCancelButton(true, animated: true)
                factory.trackersForShowing = factory.filterTrackers(in: factory.trackersStorage, by: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateCollectionViewPlaceholder(forSearch: false)
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        factory.trackersForShowing = factory.filterTrackers(in: factory.trackersStorage, forDayWithIndex: factory.weekdayIndex)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
}

