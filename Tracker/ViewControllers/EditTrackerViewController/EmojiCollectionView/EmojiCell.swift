import UIKit
import SnapKit

final class EmojiCell: UICollectionViewCell {
    
    //MARK: - Public Properties
    
    static let reuseIdentifier = "emojiCell"
    
    static let emojiArray = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                             "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                             "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    
    //MARK: - Public Properties
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32)
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 16
        return label
    }()
    
    //MARK: - Public Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with emoji: String, isSelected: Bool) {
        label.text = emoji
        label.backgroundColor = isSelected ? .trackerLightGray : .clear
    }
    
    //MARK: - Private Methods
    
    private func configureConstraints(){
        contentView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
}
