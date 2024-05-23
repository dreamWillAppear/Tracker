import UIKit
import SnapKit

class TrackerCell: UICollectionViewCell {
    
    static let reuseIdentifier = "trackerCell"
    
    let colorFilledView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        return view
    }()
    
    let trackerTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .trackerWhite
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    let emojiView: UILabel = {
        let view = UILabel()
        view.backgroundColor = UIColor(white: 1, alpha: 0.3)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.font = .systemFont(ofSize: 16)
        view.textAlignment = .center
        return view
    }()
    
    let dayCounter: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .trackerBlack
        return label
    }()
    
    let increaseButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "plus")?.withTintColor(.trackerWhite, renderingMode: .alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 17
        return button
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [colorFilledView, trackerTitle, emojiView, dayCounter, increaseButton].forEach { contentView.addSubview($0) }
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCounterLabel(with num: Int) -> String{
        
        var counterLabel = ""
        let day = String(num)
        
        guard let lastChar = day.last else { return "" }
        
        switch lastChar {
            case  "0":
                counterLabel = day + " дней"
            case "1":
                counterLabel = day + " день"
            case "2"..."4":
                counterLabel = day + " дня"
            case "5"..."9":
                counterLabel = day + " дней"
            default:
                counterLabel = ""
        }
        
        return counterLabel
    }
    
    func configureCell(for tracker: Tracker) {
        colorFilledView.backgroundColor = tracker.color
        trackerTitle.text = tracker.title
        emojiView.text = tracker.emoji
        dayCounter.text = configureCounterLabel(with: 0)
        increaseButton.backgroundColor = tracker.color
    }
    
    private func setConstraints() {
        contentView.snp.makeConstraints { make in
            make.width.equalTo(167)
            make.height.equalTo(148)
        }
        
        colorFilledView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(90)
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        trackerTitle.snp.makeConstraints { make in
            make.width.equalTo(143)
            make.height.equalTo(34)
            make.top.equalToSuperview().inset(44)
            make.leading.equalToSuperview().inset(12)
        }
        
        emojiView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(12)
        }
        
        dayCounter.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(24)
        }
        
        increaseButton.snp.makeConstraints { make in
            make.width.height.equalTo(34)
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(16)
        }
    
    }
    
}
