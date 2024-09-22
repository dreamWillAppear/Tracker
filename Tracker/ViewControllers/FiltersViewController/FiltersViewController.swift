import UIKit
import SnapKit

final class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let viewModel = FilterViewModel()

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
    
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        
        setUI()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filtersName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: FiltersCell.reuseIdentifier, for: indexPath) as? FiltersCell else {
            return UITableViewCell()
        }
        
        let filterName = viewModel.filtersName[indexPath.row]
        
        cell.configureCell(filterName: filterName, isSelected: true)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    private func setUI() {
        view.backgroundColor = .trackerWhite
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
            make.height.equalTo(75 * viewModel.filtersName.count)
        }
    }
    
}
