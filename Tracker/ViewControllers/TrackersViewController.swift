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
    
    private var datePicker = UIDatePicker()
    private var mainLabel = UILabel()
    private var searchField = UITextField()
    private var noTrackersImageView = UIImageView()
    private var noTrackersLabel = UILabel()
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    // MARK: - Private Methods
    private func setUI() {
        view.backgroundColor = .trackerWhite
        configureNavBar()
        configureMainLabel()
        configureSearchField()
        configureNoTrackersImageAndText()
    }
    
    private func configureNavBar() {
        configureDatePicker()
        navigationItem.leftBarButtonItem = addTrackerButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    @objc private func didTapAddTrackerButton() {
        let viewController = AddTrackerViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
       
        present(navigationController, animated: true)
    }
        
    private func configureDatePicker() {
        let currentDate = Date()
        let calendar = Calendar.current
        let minDate = calendar.date(byAdding: .year, value: -10, to: currentDate)
        let maxDate = calendar.date(byAdding: .year, value: 10, to: currentDate)
        
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        datePicker.addTarget(self, action: #selector(datePickerValueDateChanged(_:)), for: .valueChanged)
    }
    
    @objc private func datePickerValueDateChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formateDate = dateFormatter.string(from: selectedDate)
        print("Date from DatePicker = \(formateDate)")
    }
    
    private func configureMainLabel() {
        mainLabel.text = "Трекеры"
        mainLabel.font = UIFont.boldSystemFont(ofSize: 34)
        mainLabel.textAlignment = .left
        view.addSubview(mainLabel)
        
        mainLabel.snp.makeConstraints { make in
            make.width.equalTo(254)
            make.height.equalTo(41)
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(88)
        }
    }

    private func configureSearchField() {
        let placeholderView = UIView(frame: CGRect(x: 8, y: 10, width: 53 + 6.37 + 15.63, height: 36))
        let  searchFieldIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        let placeholderText = UILabel(frame: CGRect(x: 30, y: 7, width: 53, height: 22))
        searchFieldIcon.frame = CGRect(x: 8, y: 10, width: 15.63, height: 15.78)
        placeholderText.text = "Поиск"
        placeholderText.font = UIFont.systemFont(ofSize: 17)
        searchFieldIcon.tintColor = .trackerGray
        placeholderText.textColor = .trackerGray
        placeholderView.addSubview(searchFieldIcon)
        placeholderView.addSubview(placeholderText)
        
        searchField.backgroundColor = .trackerBackground
        searchField.layer.masksToBounds = true
        searchField.layer.cornerRadius = 8
        searchField.leftView = placeholderView
        searchField.leftViewMode = .unlessEditing
        view.addSubview(searchField)
        
        searchField.snp.makeConstraints { make in
            make.width.equalTo(343)
            make.height.equalTo(36)
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(136)
        }
    }
    
    private func configureNoTrackersImageAndText() {
        noTrackersImageView.image = .noTrackers
        view.addSubview(noTrackersImageView)
        
        noTrackersImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.centerX.centerY.equalToSuperview()
        }
        
        noTrackersLabel.text = "Что будем отслеживать?"
        noTrackersLabel.font = .systemFont(ofSize: 12)
        noTrackersLabel.textAlignment = .center
        view.addSubview(noTrackersLabel)
        
        noTrackersLabel.snp.makeConstraints { make in
            make.width.equalTo(343)
            make.height.equalTo(18)
            make.top.equalTo(noTrackersImageView.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
        }
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

