import UIKit
import SnapKit


class AddEventViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Private Properties
    lazy var  trackersViewController = TrackersViewController()
    
    private var categoryName = ""
    private let factory = TrackersFactory.shared
    private var categorySelected = false
    private var trackerNameEntered = false
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.textColor = .trackerRed
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
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
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton(type: .system)
        let imageView = UIImageView()
        let image = UIImage(named: "Chevron")?.withRenderingMode(.alwaysOriginal).withTintColor(.trackerGray)
        imageView.image = image
        button.addSubview(imageView)
        
        button.backgroundColor = .trackerBackground
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.contentHorizontalAlignment = .leading
        button.setTitle("Категория", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        button.tintColor = .trackerBlack
        button.addTarget(self, action: #selector(didTapCategoryButton), for: .touchUpInside)
        
        imageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        
        return button
    }()
    
    private lazy var cancelAndCreateButtonsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        view.distribution = .fillEqually
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.tintColor = .trackerRed
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor.trackerRed.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.tintColor = .trackerWhite
        button.backgroundColor = .trackerGray
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setConstraints()
        configureDismissingKeyboard()
    }
    
    
    // MARK: - Private Methods
    
    
    
    private func setUI() {
        view.backgroundColor = .trackerWhite
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        title = "Новое нерегулярное событие"
        
        view.addSubview(addTrackerNameField)
        view.addSubview(categoryButton)
        view.addSubview(cancelAndCreateButtonsStackView)
        view.addSubview(warningLabel)
        cancelAndCreateButtonsStackView.addArrangedSubview(cancelButton)
        cancelAndCreateButtonsStackView.addArrangedSubview(createButton)
    }
    
    
    private func configureDismissingKeyboard() {
        let tapAssideKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapAssideKeyboard.cancelsTouchesInView = false
        view.addGestureRecognizer(tapAssideKeyboard)
        
        addTrackerNameField.delegate = self
        
    }
    
    private func tryEnableCreationButton() {
        if categorySelected && trackerNameEntered {
            creationButton(mustBeEnabled: true)
        } else {
            creationButton(mustBeEnabled: false)
        }
    }
    
    private func creationButton(mustBeEnabled: Bool) {
        self.createButton.isEnabled = mustBeEnabled
        self.createButton.backgroundColor = mustBeEnabled ? .trackerBlack : .trackerGray
    }
    
    private func setConstraints() {
        addTrackerNameField.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(16)
            make.height.equalTo(75)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(81)
        }
        
        categoryButton.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(16)
            make.height.equalTo(75)
            make.top.equalTo(addTrackerNameField.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        categoryButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        cancelAndCreateButtonsStackView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(34)
        }
        
        warningLabel.snp.makeConstraints { make in
            make.leading.equalTo(addTrackerNameField)
            make.trailing.equalTo(addTrackerNameField)
            make.top.equalTo(addTrackerNameField.snp.bottom).offset(8)
        }
        
    }
    
    
    //MARK: - ACTIONS
    
    @objc private func didTapCategoryButton() {
        categorySelected = true
        tryEnableCreationButton()
        categoryName = factory.generateCatName()
        categoryButton.addSupplementaryTitle(with: categoryName)
    }
    
    @objc private func didTapCreateButton() {
        let tracker = Tracker(
            id: UUID(),
            title: addTrackerNameField.text ?? "",
            color: factory.randomColor(),
            emoji: factory.randomEmoji(),
            schedule: factory.schedule
        )
        factory.addToStorage(tracker: tracker, for: categoryName)
        factory.updateTrackersForShowing()
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapCancelButton() {
        self.dismiss(animated: true)
    }
    
    @objc private  func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - textField Delegate
extension AddEventViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = addTrackerNameField.text else { return true }
        let newTextLenght = currentText.count + string.count - range.length
        trackerNameEntered = newTextLenght != 0 ? true : false
        tryEnableCreationButton()
        if newTextLenght > 38 {
            warningLabel.isHidden = false
            return false
        } else {
            warningLabel.isHidden = true
            return true
        }
    }
}
