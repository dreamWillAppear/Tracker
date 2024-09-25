import UIKit
import SnapKit

class StatisticsCounter: UIView {
    
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
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = String(counter)
        let textSize = (label.text?.count ?? 0) < 13 ? 34 : 34/2 as CGFloat //на случай, если значение будет слишком большим
        label.font = .systemFont(ofSize: textSize, weight: .bold)
        label.textAlignment  = .left
        return label
    }()
    
    private lazy var counterNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
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
    
    init(counter: Int, counterName: String) {
        self.counter = counter
        self.counterName = counterName
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addGradientBorder(width: 1)
    }
}

extension UIView {
    func addGradientBorder(width: CGFloat = 1) {
        let gradientLayer = CAGradientLayer()
        //по rgb из фигмы
        gradientLayer.colors = [
            UIColor(red: 0.0, green: 0.482, blue: 0.98, alpha: 1.0).cgColor,
            UIColor(red: 0.275, green: 0.902, blue: 0.616, alpha: 1.0).cgColor,
            UIColor(red: 0.992, green: 0.298, blue: 0.286, alpha: 1.0).cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.frame = bounds
        
        let borderLayer = CAShapeLayer()
        let insetBounds = bounds.insetBy(dx: width, dy: width)
        borderLayer.path = UIBezierPath(roundedRect: insetBounds, cornerRadius: layer.cornerRadius).cgPath
        borderLayer.lineWidth = width
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = borderLayer
        
        layer.addSublayer(gradientLayer)
    }
}


