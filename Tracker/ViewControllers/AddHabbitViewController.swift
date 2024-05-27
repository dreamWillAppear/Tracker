import UIKit
import SnapKit

class AddHabbitViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Private Properties
    
    private let factory = TrackersFactory.shared
    
    private lazy var addTrackerNameField: UITextField = {
        let textField = UITextField()
        let leftSpace = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 10))
        let rightSpace = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 10))
        textField.leftViewMode = .always
        textField.leftView = leftSpace
        textField.rightView = rightSpace
        textField.backgroundColor = .trackerBackground
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.placeholder = "Введите название трекера"
        textField.clearButtonMode = .whileEditing
        textField.textColor = .trackerBlack
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let image = UIImage(named: "Chevron")?.withRenderingMode(.alwaysOriginal).withTintColor(.trackerGray)
        let imageViewTop = UIImageView()
        imageViewTop.image = image
        let imageViewBottom = UIImageView()
        imageViewBottom.image = image
        
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        view.backgroundColor = .trackerBackground
        view.layer.cornerRadius = 16
        view.addSubview(imageViewTop)
        view.addSubview(imageViewBottom)
        
        imageViewTop.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.width.equalTo(7)
            make.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(32)
        }
        
        imageViewBottom.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.width.equalTo(7)
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(31)
        }
        return view
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.contentHorizontalAlignment = .leading
        button.setTitle("Категория", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        button.tintColor = .trackerBlack
        button.addTarget(self, action: #selector(didTapCategoryButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var scheduleButton: UIButton = {
        let button = UIButton(type: .system)
        button.contentHorizontalAlignment = .leading
        button.setTitle("Раписание", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        button.tintColor = .trackerBlack
        button.addTarget(self, action: #selector(didTapScheduleButton), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTrackerNameField.delegate = self
        
        setUI()
        setConstraints()
    }
    
    // MARK: - Private Methods
    private func setUI() {
        view.backgroundColor = .trackerWhite
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        title = "Новая привычка"
        
        configureButtonsStackView()
        
        view.addSubview(addTrackerNameField)
        view.addSubview(buttonsStackView)
        
    }
    
    private func configureButtonsStackView() {
        
        let separatorLine = UIView()
        separatorLine.backgroundColor = .trackerGray
        
        buttonsStackView.addArrangedSubview(categoryButton)
        buttonsStackView.addArrangedSubview(separatorLine)
        buttonsStackView.addArrangedSubview(scheduleButton)
        
        separatorLine.snp.makeConstraints { make in
            make.center.equalTo(buttonsStackView)
            make.height.equalTo(1)
            make.leading.equalTo(buttonsStackView).offset(16)
            make.trailing.equalTo(buttonsStackView).offset(-16)
        }
    }
    
    private func setConstraints() {
        addTrackerNameField.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(16)
            make.height.equalTo(75)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(81)
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(16)
            make.height.equalTo(150)
            make.top.equalTo(addTrackerNameField.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        categoryButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
    }
    
    @objc private func didTapCategoryButton() {
        factory.addCategory(withName: "Важное")
        categoryButton.addSupplementaryTitle(with: "Важное")
        
    }
    
    @objc private func didTapScheduleButton() {
        
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

