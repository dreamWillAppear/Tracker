import UIKit
import SnapKit

class TrackersViewController: UIViewController {
    
    // MARK: - Private Properties
    private var categories: [TrackerCategory] = []
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
        return searchField
    }()
    
    private lazy var noTrackersStackView: UIStackView = {
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
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    // MARK: - Private Methods
    private func setUI() {
        view.backgroundColor = .trackerWhite
        view.addSubview(mainLabel)
        view.addSubview(searchField)
        view.addSubview(noTrackersStackView)
        
        noTrackersStackView.addArrangedSubview(noTrackersImageView)
        noTrackersStackView.addArrangedSubview(noTrackersLabel)
        
        configureNavBar()
        setConstraints()
    }
    
    private func configureNavBar() {
        navigationItem.leftBarButtonItem = addTrackerButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
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
            make.width.equalToSuperview().inset(16)
            make.height.equalTo(36)
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(136)
        }
        
        noTrackersStackView.snp.makeConstraints { make in
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
        let navigationController = UINavigationController(rootViewController: viewController)
       
        present(navigationController, animated: true)
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

