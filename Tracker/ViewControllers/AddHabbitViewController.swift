import UIKit
import SnapKit

class AddHabbitViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var addTrackerNameField: UIView = {
        makeTextFiled(withPlaceholder: "Введите название трекера")
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
        
        view.addSubview(addTrackerNameField)
        
    }
    
    private func setConstraints() {
        addTrackerNameField.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(16)
            make.height.equalTo(75)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(81)
        }
        
    
    }
    
    func makeTextFiled(withPlaceholder: String) -> UIView {
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

