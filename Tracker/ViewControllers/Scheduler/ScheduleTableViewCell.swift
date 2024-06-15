import UIKit
import SnapKit

protocol SwitchCellDelegate: AnyObject {
    func switchValueChanded(_ sender: UISwitch, cell: ScheduleTableViewCell)
}

class ScheduleTableViewCell: UITableViewCell {
    
    weak var delegate: SwitchCellDelegate?
    
    static let reuseIdentifier = "ScheduleTableViewCell"
    
    private let weekDayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    private let switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.onTintColor = .trackerBlue
        switcher.tintColor = .trackerGray
        return switcher
    }()
    
    private let weekdays = WeekDay.allCases.map { $0.rawValue }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        switcher.addTarget(self, action: #selector(switchValueChanded), for: .valueChanged)
        backgroundColor = .trackerBackground
        selectionStyle = .none
        
        [weekDayLabel,
         switcher].forEach {
            contentView.addSubview($0)
        }
        
        weekDayLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        
        switcher.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(weekDay: WeekDay, isOn: Bool) {
        weekDayLabel.text = weekDay.rawValue
        switcher.isOn = isOn
    }
    
    @objc func switchValueChanded(_ sender: UISwitch) {
        delegate?.switchValueChanded(sender, cell: self)
    }
}
