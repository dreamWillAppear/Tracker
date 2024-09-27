import UIKit
import SnapKit

final class ColorSelectCell: UICollectionViewCell {
    
    //MARK: - Public Properties
    
    static let reuseIdentifier = "colorSelectCell"
    
    static let colors: [UIColor] = (1...18).compactMap { index in
        guard let color = UIColor(named: "Color selection \(index)") else {
            return nil
        }
        return color
    }
    
    //MARK: - Private Properties
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()
    
    //MARK: - Public Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(colorView)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(color: UIColor, isSelected: Bool) {
        contentView.layer.cornerRadius = colorView.layer.cornerRadius
        contentView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
        contentView.layer.borderWidth = isSelected ? 3 : 0
        colorView.backgroundColor = color
    }
    
    //MARK: - Private Methods
    
    private func configureConstraints(){
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        colorView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(6)
        }
    }
    
}
