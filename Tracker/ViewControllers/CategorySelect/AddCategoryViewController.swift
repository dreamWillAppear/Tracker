import UIKit

final class AddCategoryViewController: UIViewController, UITextFieldDelegate {
    
    var newCategoryAdded: (() -> Void)?
    
    private let viewModel = CategorySelectViewModel()
    
    private lazy var categoryNameTextField: UITextField = {
        let textField = UITextField()
        let leftSpace = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 10))
        let rightSpace = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 10))
        textField.leftViewMode = .always
        textField.leftView = leftSpace
        textField.rightView = rightSpace
        textField.backgroundColor = .trackerBackground
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.placeholder = "Введите название категории"
        textField.textColor = .trackerBlack
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = false
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.trackerWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.backgroundColor = .trackerGray
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryNameTextField.delegate = self
        configureDismissingKeyboard() 
        setUI()
    }
    
    private func setUI() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        title = "Новая категория"
        view.backgroundColor = .trackerMainBackground
        
        [categoryNameTextField, doneButton].forEach {
            view.addSubview($0)
        }
        
        setConstraints()
    }
    
    private func setConstraints() {
        categoryNameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(81)
            make.height.equalTo(75)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        doneButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(50)
            make.height.equalTo(60)
            make.trailing.leading.equalToSuperview().inset(20)
        }
    }
    
    private func setDoneButtonState(isEnabled: Bool) {
        doneButton.isEnabled = isEnabled
        doneButton.backgroundColor = isEnabled ? .trackerBlack : .trackerGray
    }
    
    private func configureDismissingKeyboard() {
        let tapAssideKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapAssideKeyboard.cancelsTouchesInView = false
        let scrollGesture = UIPanGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        [tapAssideKeyboard, scrollGesture].forEach {
            view.addGestureRecognizer($0)
        }
        
        categoryNameTextField.delegate = self
    }
    
    
    //MARK: - Actions
    
    @objc private func didTapDoneButton() {
        guard let name = categoryNameTextField.text, !name.isEmpty else { return }
        viewModel.addCategory(name: name)
        newCategoryAdded?()
        self.dismiss(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

//MARK: - textField Delegate

extension AddCategoryViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard  let text = textField.text else { return }
        setDoneButtonState(isEnabled: !text.isEmpty)
    }
}
