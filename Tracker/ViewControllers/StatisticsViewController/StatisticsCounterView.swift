import UIKit
import SnapKit

final class StatisticsCounter: UIView {
    
    //MARK: - Public Properties
    
    var counter: Int {
        didSet {
            counterLabel.text = String(counter)
        }
    }
    
    var counterName: String {
        didSet {
            counterLabel.text = counterName
        }
    }
    
    //MARK: - Private Properties
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .trackerBlack
        label.text = String(counter)
        let textSize = (label.text?.count ?? 0) < 13 ? 34 : 34/2 as CGFloat //на случай, если значение будет слишком большим
        label.font = .systemFont(ofSize: textSize, weight: .bold)
        label.textAlignment  = .left
        return label
    }()
    
    private lazy var counterNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .trackerBlack
        label.text = counterName
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        stack.isLayoutMarginsRelativeArrangement = true 
        return stack
    }()
    
    //MARK: - Public Methods
    
    init(counter: Int, counterName: String) {
        self.counter = counter
        self.counterName = counterName
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addGradientBorder(width: 1)
    }
    
    //MARK: - Private Methods
    
    private func setupView() {
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        [counterLabel, counterNameLabel].forEach {
            labelsStackView.addArrangedSubview($0)
        }
        
        addSubview(labelsStackView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        labelsStackView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
}



