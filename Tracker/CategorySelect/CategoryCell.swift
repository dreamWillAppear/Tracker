import UIKit
import SnapKit

 class CategoryCell: UITableViewCell {
    
    static let reuseIdentifier = "CategoryCell"
    
     lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .trackerBlack
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setUI() {
        backgroundColor  = .trackerBackground
        contentView.addSubview(categoryLabel)
        contentView.layer.cornerRadius = 16
        
        categoryLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureCell(categoryName: String) {
        categoryLabel.text = categoryName
    }
    
}
