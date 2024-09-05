import UIKit
import Combine

final class CategorySelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var categoryNameSelected: ((String) -> Void)?
    
    private let addHabbitViewController = AddHabbitViewController()
    private let viewModel = CategorySelectViewModel()
    private let categoryCell = CategoryCell()
    private var selectedCategoryName = ""
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .trackerBackground
        table.layer.cornerRadius = 16
        table.register(
            CategoryCell.self,
           forCellReuseIdentifier: CategoryCell.reuseIdentifier)
        return table
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.tintColor = .trackerWhite
        button.backgroundColor = .trackerBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapAddTrackerButton), for: .touchUpInside)
        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        tableView.dataSource = self
        tableView.delegate = self
        
        setUI()
    }
    
    private func bindViewModel() {
        viewModel.categoriesUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.fetchCategories()
    }
    
    private func setUI(){
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        title = "Категория"
        view.backgroundColor = .trackerWhite
        
        [tableView, addCategoryButton].forEach {
            view.addSubview($0)
        }
        
        
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        setConstraints()
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(81)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(addCategoryButton.snp.top).offset(-47)
        }
        
        addCategoryButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(50)
        }
    }
        
    //MARK: - Actions
    
    @objc func didTapAddTrackerButton() {
        let viewController = AddCategoryViewController()
        viewController.newCategoryAdded = { [weak self] in
            self?.viewModel.fetchCategories()
            self?.tableView.reloadData()
        }
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
}

extension CategorySelectViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard  let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        let category = viewModel.categories[indexPath.row]
        cell.configureCell(categoryName: category.title)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = viewModel.categories[indexPath.row]
        categoryNameSelected?(selectedCategory.title)
        self.dismiss(animated: true)
    }

}

