import UIKit
import SnapKit

class AddHabbitViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var addTrackerNameField: UIView = {
        makeTextFiled(withPlaceholder: "Введите название трекера")
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        view.backgroundColor = .trackerLightGray
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.contentHorizontalAlignment = .leading
        button.setTitle("Категория", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.setImage(UIImage(named: "Chevron")?.withRenderingMode(.alwaysOriginal).withTintColor(.trackerGray), for: .normal)
        button.tintColor = .trackerBlack
        button.imageView?.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        })
        return button
    }()
    
    private lazy var scheduleButton: UIButton = {
        let button = UIButton(type: .system)
        button.contentHorizontalAlignment = .leading
        button.setTitle("Раписание", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.setImage(UIImage(named: "Chevron")?.withRenderingMode(.alwaysOriginal).withTintColor(.trackerGray), for: .normal)
        button.tintColor = .trackerBlack
        button.imageView?.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        })
        return button
    }()
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
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
    
   private func makeTextFiled(withPlaceholder: String) -> UIView {
        let view = UIView()
        
        view.backgroundColor = .trackerLightGray
        view.layer.cornerRadius = 16
        let textField = UITextField(frame: CGRect(x: 16, y: 27, width: super.view.bounds.width - 64, height: 22))
        textField.placeholder = "Введите название трекера"
        textField.clearButtonMode = .whileEditing
        view.addSubview(textField)
    
        return view
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

