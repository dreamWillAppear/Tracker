import UIKit

final class CategorySelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var categoryNameSelected: ((String) -> Void)?
    
    private let addHabbitViewController = AddHabbitViewController()
    private let viewModel = CategorySelectViewModel()
    private let categoryCell = CategoryCell()
    private let rowHeight: CGFloat = 75
    
    private lazy var currentTableHeight: CGFloat = {
        calculateTableViewHeight()
    }()
    
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
    
    private lazy var noCategoriesPlaceholder: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 8
        return view
    }()
    
    private var noCategoriesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .noTrackers
        return imageView
    }()
    
    private var noCategoriesLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно\n объединить по смыслу"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        currentTableHeight = tableView.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        let category = viewModel.categories.reversed()[indexPath.row]
        cell.configureCell(categoryName: category.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = viewModel.categories.reversed()[indexPath.row]
        categoryNameSelected?(selectedCategory.title)
        self.dismiss(animated: true)
    }
    
    private func bindViewModel() {
        viewModel.categoriesUpdated = { [weak self] in
            self?.tableView.reloadData()
            self?.updateTableViewHeight()
            self?.updateNoCategoriesPlaceholderVisibility()
        }
        
        viewModel.fetchCategories()
    }
    
    private func setUI(){
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        title = "Категория"
        view.backgroundColor = .trackerWhite
        
        updateNoCategoriesPlaceholderVisibility()
        
        [tableView, addCategoryButton, noCategoriesPlaceholder].forEach {
            view.addSubview($0)
        }
        
        
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        [noCategoriesImageView, noCategoriesLabel].forEach {
            noCategoriesPlaceholder.addArrangedSubview($0)
        }
        
        setConstraints()
        updateTableViewHeight()
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(81)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(currentTableHeight)
        }
        
        addCategoryButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(50)
        }
        
        noCategoriesPlaceholder.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func calculateTableViewHeight() -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        let referenceScreenHeight: Double = 896 // высота экрана iPhone 11
        let referenceMaxTableHeight: Double = 600 // максимальная высота таблицы для iPhone 11
        
        let proportion = screenHeight / referenceScreenHeight - 0.08
        
        // Вычисляем высоту таблицы на основе пропорции
        let maxTableHeight = referenceMaxTableHeight * proportion
        
        // Вычисляем высоту таблицы на основе количества строк
        let rowHeight: CGFloat = 75 // высота одной строки
        let tableHeight: CGFloat = rowHeight * CGFloat(viewModel.categories.count)
        
        // Округляем tableHeight до ближайшего кратного высоте ячейки
        let roundedTableHeight = (tableHeight / rowHeight).rounded() * rowHeight
        
        // Ограничиваем высоту таблицы максимальным значением
        guard roundedTableHeight < maxTableHeight else { return maxTableHeight }
        
        return roundedTableHeight
    }
    
    private func updateTableViewHeight() {
        
        let tableViewHeight: CGFloat = calculateTableViewHeight()
        
        tableView.snp.updateConstraints { make in
            make.height.equalTo(tableViewHeight)
        }
    }
    
    private func updateNoCategoriesPlaceholderVisibility() {
        noCategoriesPlaceholder.isHidden = !viewModel.categories.isEmpty
    }
    
    //MARK: - Actions
    
    @objc func didTapAddTrackerButton() {
        let viewController = AddCategoryViewController()
        viewController.newCategoryAdded = { [weak self] in
            self?.viewModel.fetchCategories()
            self?.tableView.reloadData()
            self?.updateTableViewHeight()
            self?.updateNoCategoriesPlaceholderVisibility()
        }
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
}

