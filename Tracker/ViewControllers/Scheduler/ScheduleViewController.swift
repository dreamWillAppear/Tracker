import UIKit
import SnapKit

class ScheduleViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let factory = TrackersFactory.shared
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .trackerBackground
        table.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.reuseIdentifier)
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
    
    private var switchStates = Array(repeating: false, count: Weekday.allCases.count)
    
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
        
        view.addSubview(tableView)
        view.addSubview(doneButton)
        
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
        dismiss(animated: true)
    }
    
}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Weekday.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / CGFloat(Weekday.allCases.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.reuseIdentifier, for: indexPath) as? ScheduleTableViewCell else {
            return UITableViewCell()
        }
        
        let weekday = Weekday.allCases[indexPath.row]
        let isOn = switchStates[indexPath.row]
        
        cell.delegate = self
        cell.configure(weekday: weekday, isOn: isOn)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == Weekday.allCases.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
    }
}

extension ScheduleViewController: SwitchCellDelegate {
    func switchValueChanded(_ sender: UISwitch, cell: ScheduleTableViewCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        if sender.isOn {
           factory.schedule[indexPath.item] = true
        } else {
          factory.schedule[indexPath.item] = false
        }
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


