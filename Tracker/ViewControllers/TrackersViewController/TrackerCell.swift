import UIKit
import SnapKit

final class TrackerCell: UICollectionViewCell {
   
    static let reuseIdentifier = "trackerCell"
    
    var didTapEditTracker: (() -> Void)?
    var didTapDeleteTracker: (() -> Void)?
    var didTapIncrease: (() -> Void)?
    
    private let factory = TrackersFactory.shared
    private var tracker: Tracker?
    private var selectedDate: Date?
    private var trackerColor: UIColor?
    
    private lazy var colorFilledView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var trackerTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .trackerWhite
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var emojiView: UILabel = {
        let view = UILabel()
        view.backgroundColor = UIColor(white: 1, alpha: 0.3)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.font = .systemFont(ofSize: 16)
        view.textAlignment = .center
        return view
    }()
    
    private lazy var dayCounter: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .trackerBlack
        return label
    }()
    
    private lazy var increaseButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 17
        button.addTarget(self, action: #selector(didTapIncreaseButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = colorFilledView.layer.cornerRadius
        
        [colorFilledView,
         trackerTitle,
         emojiView,
         dayCounter,
         increaseButton].forEach {
            contentView.addSubview($0)
        }
        setConstraints()
        setContextMenu()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(for tracker: Tracker, date: Date) {
        self.tracker = tracker
        self.selectedDate = date
        trackerColor = tracker.color
        
        colorFilledView.backgroundColor = tracker.color
        trackerTitle.text = tracker.title
        emojiView.text = tracker.emoji
        increaseButton.backgroundColor = tracker.color
        configureIncreaseButton(tracker: tracker, date: date)
        configureCounterLabel()
    }
    
    private func configureCounterLabel() {
        guard let tracker = tracker else { return }
        dayCounter.text = factory.getDayCounterLabel(for: tracker)
    }
    
    private func selectedDateIsFuture() -> Bool {
        guard let selectedDate = selectedDate else {
            return true
        }
        return selectedDate > Date()
    }
    
    private func configureIncreaseButton(tracker: Tracker, date: Date) {
        guard !selectedDateIsFuture() else {
            increaseButton.isEnabled = false
            increaseButton.backgroundColor = trackerColor?.withAlphaComponent(0.2)
            increaseButton.setImage(UIImage(systemName: "plus")?
                .withTintColor(.trackerWhite, renderingMode: .alwaysOriginal), for: .normal)
            return
        }
        
        increaseButton.isEnabled = true
        let isCompleted = factory.isTrackerCompleted(trackerID: tracker.id, on: date)
        let image = isCompleted ? UIImage(named: "Cell Button Done") : UIImage(systemName: "plus")
        increaseButton.backgroundColor = isCompleted ? trackerColor?.withAlphaComponent(0.2) : trackerColor
        increaseButton.setImage(image?
            . withRenderingMode(.alwaysOriginal)
            .withTintColor(.trackerWhite), for: .normal)
    }
    
    private func setConstraints() {
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
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
    
    private func setContextMenu() {
        let interaction = UIContextMenuInteraction(delegate: self)
        contentView.addInteraction(interaction)
    }
    
    private func mark(tracker: Tracker, onDate: Date) {
        if factory.isTrackerCompleted(trackerID: tracker.id, on: onDate) {
            factory.unmarkTrackerAsCompleted(trackerID: tracker.id, on: onDate)
        } else {
            factory.markTrackerAsCompleted(trackerID: tracker.id, on: onDate)
        }
    }
    
    //MARK: - ACTIONS
    
    @objc private func didTapIncreaseButton() {
        guard
            let tracker = tracker,
            let date = selectedDate
        else { return }
    
        mark(tracker: tracker, onDate: date)
        configureIncreaseButton(tracker: tracker, date: date)
        configureCounterLabel()
        didTapIncrease?()
    }
}

extension TrackerCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let tracker = tracker else  { return .init() }
        let trackerPinned = factory.isPinned(trackerId: tracker.id)
        let pinActionTitle = trackerPinned ? "Открепить" : "Закрепить"
        
        let pinAction = UIAction(title: pinActionTitle, image: nil) { [weak self]  _ in
            self?.factory.pinTracker(id: tracker.id, needPin: !trackerPinned)
        }
        
        let editAction = UIAction(title: "Редактировать", image: nil) { [weak self] _ in
            self?.didTapEditTracker?()
        }
        
        let deleteAction = UIAction(title: "Удалить", image: nil, attributes: .destructive) { [weak self] _ in
            self?.didTapDeleteTracker?()
        }
        
        let menu = UIMenu(title: "", children: [pinAction, editAction, deleteAction])
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) {_ in
            return menu
        }
    }
}
