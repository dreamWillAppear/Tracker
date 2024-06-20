import UIKit
import SnapKit

final class ScheduleViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let factory = TrackersFactory.shared
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .trackerBackground
        table.register(
            ScheduleTableViewCell.self,
            forCellReuseIdentifier: ScheduleTableViewCell.reuseIdentifier)
        
        return table
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.tintColor = .trackerWhite
        button.backgroundColor = .trackerBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        return button
    }()
    
    private var switchStates = Array(repeating: false, count: WeekDay.allCases.count)
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setUI()
        setConstraints()
    }
    
    // MARK: - Private Methods
    
    private func setUI(){
        view.backgroundColor = .trackerWhite
        
        [tableView,
         doneButton].forEach {
            view.addSubview($0)
        }
        
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .trackerGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(81)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(doneButton.snp.top).offset(-47)
        }
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(50)
        }
    }
    
    //MARK: - ACTIONS
    
    @objc private func didTapDoneButton() {
        NotificationCenter.default.post(name: TrackersFactory.scheduleUpdatedNotification, object: nil)
        dismiss(animated: true)
    }
}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            WeekDay.allCases.count
        }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath) -> CGFloat {
            tableView.bounds.height / CGFloat(WeekDay.allCases.count)
        }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.reuseIdentifier, for: indexPath) as? ScheduleTableViewCell else {
                return UITableViewCell()
            }
            
            let weekDay = WeekDay.allCases[indexPath.row]
            let isOn = factory.schedule[indexPath.row]
            
            cell.delegate = self
            cell.configure(weekDay: weekDay, isOn: isOn)
            
            return cell
        }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath) {
            if indexPath.row == WeekDay.allCases.count - 1 {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            }
        }
}

extension ScheduleViewController: SwitchCellDelegate {
    func switchValueChanded(
        _ sender: UISwitch,
        cell: ScheduleTableViewCell) {
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            factory.schedule[indexPath.item] = sender.isOn
        }
}

