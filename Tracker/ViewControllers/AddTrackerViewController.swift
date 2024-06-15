import UIKit
import SnapKit

class AddTrackerViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var buttonsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        return view
    }()
    
    private lazy var addHabbitButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .trackerBlack
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.titleLabel?.tintColor = .trackerWhite
        button.setTitle("Привычка", for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(
            self,
            action: #selector(didTapAddHabbitButton),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var addEventButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .trackerBlack
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.titleLabel?.tintColor = .trackerWhite
        button.setTitle("Нерегулярные событие", for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(
            self,
            action: #selector(didTapAddEventButton),
            for: .touchUpInside
        )
        return button
    }()
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Private Methods
    
    private func setUI() {
        view.backgroundColor = .trackerWhite
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        title = "Создание трекера"
        
        [addHabbitButton,
         addEventButton].forEach {
            buttonsStackView.addArrangedSubview($0)
        }
        view.addSubview(buttonsStackView)
    }
    
    private func setConstraints() {
        
        buttonsStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        addHabbitButton.snp.makeConstraints { make in
            make.width.equalTo(335)
            make.height.equalTo(60)
        }
        
        addEventButton.snp.makeConstraints { make in
            make.width.equalTo(335)
            make.height.equalTo(60)
        }
        
    }
    
    //MARK: - Actions
    
    @objc private func didTapAddHabbitButton(){
        let viewController = AddHabbitViewController()
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
    
    @objc private func didTapAddEventButton(){
        let viewController = AddEventViewController()
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
}
