import UIKit
import SnapKit

final class FiltersViewController: UIViewController,  UITableViewDataSource {
    
    //MARK: - Public Properties
    
    var filterSelected: ((String) -> Void)?
    
    //MARK: - Private Properties
    
    private let viewModel = FilterViewModel()
    
    private let factory = TrackersFactory.shared
    
    private lazy var tableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .trackerBackground
        tableView.layer.cornerRadius = 16
        tableView.dataSource = self
        tableView.register(
            FiltersCell.self,
            forCellReuseIdentifier: FiltersCell.reuseIdentifier
        )
        
        return tableView
    }()
    
    //MARK: - Public Methods
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        
        setUI()
    }
    
    //MARK: - Private Methods
    
    private func setUI() {
        view.backgroundColor = .trackerMainBackground
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        title = "Фильтры"
        
        view.addSubview(tableView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(81)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(75 * viewModel.filtersNames.count)
        }
    }
    
}

//MARK: - UITableViewDelegate

extension FiltersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filtersNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: FiltersCell.reuseIdentifier, for: indexPath) as? FiltersCell else {
            return UITableViewCell()
        }
        
        let filterName = viewModel.filtersNames[indexPath.row]
        let isSelected = factory.currentFilterName == filterName
        cell.configureCell(filterName: filterName, isSelected: isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell =  tableView.cellForRow(at: indexPath) as? FiltersCell
        cell?.isSelected(selected: true)
        filterSelected?(cell?.getGetSelectedFilterName() ?? "")
        self.dismiss(animated: true)
    }
    
}
