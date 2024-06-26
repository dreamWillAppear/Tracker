import UIKit
import SnapKit

final class ColorSelectCell: UICollectionViewCell {
    
    static let reuseIdentifier = "colorSelectCell"
    
    static let colors: [UIColor] = (1...18).compactMap { index in
        guard let color = UIColor(named: "Color selection \(index)") else {
            return nil
        }
        return color
    }
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        colorView.layer.cornerRadius = 8
        contentView.addSubview(colorView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(color: UIColor, isSelected: Bool) {
        contentView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
        contentView.layer.borderWidth = isSelected ? 3 : 0
        contentView.backgroundColor = color
    }
    
    private func configureConstraints(){
        
        contentView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        colorView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
}
