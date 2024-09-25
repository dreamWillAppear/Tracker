import UIKit
import SnapKit


final class EditTrackerViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Public Properties
    
    var isHabbit: Bool
    var newCategoryName = ""
    var categoryName = ""
    var selectedCategory: (() -> String)?
    
    // MARK: - Private Properties
    
    private let editableTracker: Tracker?
    
    private let factory = TrackersFactory.shared
    private var categorySelected = false
    private var trackerNameEntered = false
    private var scheduleDidSet = false
    private var emojiSelected = false
    private var colorSelected = false
    private var scheduleUpdateNotification = TrackersFactory.scheduleUpdatedNotification
    
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var dayCounterLabel: UILabel = {
        guard let tracker = editableTracker else { return UILabel() }
        let label = UILabel()
        label.text = factory.getDayCounterLabel(for: tracker)
        label.textColor = .trackerBlack
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.textColor = .trackerRed
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var addTrackerNameField: UITextField = {
        let textField = UITextField()
        let leftSpace = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 10))
        let rightSpace = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 10))
        textField.leftViewMode = .always
        textField.leftView = leftSpace
        textField.rightView = rightSpace
        textField.backgroundColor = .trackerBackground
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.placeholder = "Введите название трекера"
        textField.clearButtonMode = .whileEditing
        textField.textColor = .trackerBlack
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        
        let image = UIImage(named: "Chevron")?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.trackerGray)
        let imageViewTop = UIImageView()
        imageViewTop.image = image
        let imageViewBottom = UIImageView()
        imageViewBottom.image = image
        imageViewBottom.isHidden = !isHabbit
        
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        view.backgroundColor = .trackerBackground
        view.layer.cornerRadius = 16
        view.addSubview(imageViewTop)
        isHabbit ? view.addSubview(imageViewBottom) : ()
        
        imageViewTop.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.width.equalTo(7)
            make.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(32)
        }
        
        guard isHabbit else {
            factory.schedule =  Array(repeating: true, count: WeekDay.allCases.count) //MOCK
            return view
        }
        
        imageViewBottom.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.width.equalTo(7)
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(31)
        }
        return view
    }()
    
    private lazy var categoryButton: TrackerButton = {
        let button = TrackerButton(type: .system)
        button.contentHorizontalAlignment = .leading
        button.setTitle("Категория", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        button.tintColor = .trackerBlack
        button.addTarget(self, action: #selector(didTapCategoryButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var scheduleButton: TrackerButton = {
        let button = TrackerButton(type: .system)
        button.contentHorizontalAlignment = .leading
        button.setTitle("Раписание", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        button.tintColor = .trackerBlack
        button.addTarget(self, action: #selector(didTapScheduleButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelAndCreateButtonsStackView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = self.view.backgroundColor
        view.axis = .horizontal
        view.spacing = 8
        view.distribution = .fillEqually
        return view
    }()
    
    private lazy var cancelButton: TrackerButton = {
        let button = TrackerButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.tintColor = .trackerRed
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor.trackerRed.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: TrackerButton = {
        let button = TrackerButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.tintColor = .trackerWhite
        button.backgroundColor = .trackerGray
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        return button
    }()
    
    private var selectedEmojiCellIndexPath: IndexPath?
    
    private lazy var  emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private var selectedColorCellIndexPath: IndexPath?
    
    private lazy var  colorSelectCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    // MARK: - Public Methods
    
    init(isHabbit: Bool, tracker: Tracker?) {
        self.isHabbit = isHabbit
        self.editableTracker = tracker
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scheduleDidSet = !isHabbit
        
        setUI()
        setConstraints()
        configureDismissingKeyboard()
        configureEmojiCollectionView()
        configureColorSelectCollectionView()
        setupObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: scheduleUpdateNotification, object: nil)
    }
    
    // MARK: - Private Methods
    
    private func setUI() {
        view.backgroundColor = .trackerWhite
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        
        if editableTracker != nil {
            title = "Редактирование привычки"
            configureForEdit()
            mainScrollView.addSubview(dayCounterLabel)
        } else {
            title = isHabbit ? "Новая привычка" : "Новое нерегулярное событие"
        }
        
        configureButtonsStackViews()
        
        [addTrackerNameField,
         buttonsStackView,
         warningLabel,
         emojiCollectionView,
         colorSelectCollectionView,
         cancelAndCreateButtonsStackView].forEach {
            mainScrollView.addSubview($0)
        }
        
        view.addSubview(mainScrollView)
    }
    
    //MARK: - Configure For Edit Tracker
    
    private func configureForEdit() {
        guard let tracker = editableTracker else { return }
        //настройка отображения выбранного лейбла, расписания, категории редактируемого трекера
        let selectedCategory = factory.getCategory(forTracker: tracker.id)
        factory.schedule = tracker.schedule
        factory.isPinned = tracker.isPinned
        scheduleButton.addSupplementaryView(with: configureScheduleButtonSupplementaryText(for: factory.schedule))
        categoryButton.addSupplementaryView(with: selectedCategory?.title ?? "")
        addTrackerNameField.text = tracker.title
        
        //настройка выбранного эмодзи и цвета редактируемого трекера
        if let index =  EmojiCell.emojiArray.firstIndex(where: { $0 == tracker.emoji }) {
            selectedEmojiCellIndexPath = IndexPath(item: index, section: 0)
        }
        
        if let index =  ColorSelectCell.colors.firstIndex(where: { $0 == tracker.color }) {
            selectedColorCellIndexPath = IndexPath(item: index, section: 0)
        }
        
        //настройка уже выбранной категории, эмодзи и цвета редактируемого трекера
        categoryName = selectedCategory?.title ?? ""
        newCategoryName = categoryName
        factory.selectedEmoji = tracker.emoji
        factory.selectedColor = tracker.color
    
        createButton.isEnabled = true
        createButton.backgroundColor = .trackerBlack
        createButton.setTitle("Сохранить", for: .normal)
    }
    
    private func configureEmojiCollectionView() {
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
        
        emojiCollectionView.register(
            EmojiCell.self,
            forCellWithReuseIdentifier: EmojiCell.reuseIdentifier)
        
        emojiCollectionView.register(
            EmojiCollectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: EmojiCollectionHeader.identifier)
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(addScheduleButtonSupplementaryText), name: scheduleUpdateNotification, object: nil)
    }
    
    private func configureColorSelectCollectionView() {
        colorSelectCollectionView.delegate = self
        colorSelectCollectionView.dataSource = self
        
        colorSelectCollectionView.register(
            ColorSelectCell.self,
            forCellWithReuseIdentifier:  ColorSelectCell.reuseIdentifier)
        
        colorSelectCollectionView.register(
            ColorSelectCollectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ColorSelectCollectionHeader.identifier)
    }
    
    private func configureButtonsStackViews() {
        let separatorLine = UIView()
        separatorLine.backgroundColor = .trackerGray
        
        if isHabbit {
            
            [categoryButton,
             separatorLine,
             scheduleButton].forEach {
                buttonsStackView.addArrangedSubview($0)
            }
            
            separatorLine.snp.makeConstraints { make in
                make.center.equalTo(buttonsStackView)
                make.height.equalTo(1)
                make.leading.equalTo(buttonsStackView).offset(16)
                make.trailing.equalTo(buttonsStackView).offset(-16)
            }
        } else {
            buttonsStackView.addArrangedSubview(categoryButton)
        }
        
        
        [cancelButton,
         createButton].forEach {
            cancelAndCreateButtonsStackView.addArrangedSubview($0)
        }
    }
    
    private func configureDismissingKeyboard() {
        let tapAssideKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapAssideKeyboard.cancelsTouchesInView = false
        view.addGestureRecognizer(tapAssideKeyboard)
        
        addTrackerNameField.delegate = self
    }
    
    private func tryEnableCreationButton() {
        let isEnabled = categorySelected && trackerNameEntered && scheduleDidSet && emojiSelected && colorSelected
        creationButton(mustBeEnabled: isEnabled)
    }
    
    private func creationButton(mustBeEnabled: Bool) {
        guard editableTracker == nil else {
            self.createButton.isEnabled = !categoryName.isEmpty
            return
        }
        self.createButton.isEnabled = mustBeEnabled
        self.createButton.backgroundColor = mustBeEnabled ? .trackerBlack : .trackerGray
    }
    
    private func setConstraints() {
        
        mainScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        if editableTracker != nil {
            
            dayCounterLabel.snp.makeConstraints { make in
                make.width.equalToSuperview().inset(16)
                make.height.equalTo(38)
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().inset(24)
            }
            
            addTrackerNameField.snp.makeConstraints { make in
                make.width.equalToSuperview().inset(16)
                make.height.equalTo(75)
                make.centerX.equalToSuperview()
                make.top.equalTo(dayCounterLabel.snp.bottom).inset(-40)
            }
            
        } else {
            addTrackerNameField.snp.makeConstraints { make in
                make.width.equalToSuperview().inset(16)
                make.height.equalTo(75)
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().inset(24)
            }
        }
        
        warningLabel.snp.makeConstraints { make in
            make.leading.equalTo(addTrackerNameField)
            make.trailing.equalTo(addTrackerNameField)
            make.top.equalTo(addTrackerNameField.snp.bottom).offset(6)
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(addTrackerNameField.snp.bottom).offset(24)
            make.width.equalToSuperview().inset(16)
            make.height.equalTo(isHabbit ? 150 : 75)
            make.centerX.equalToSuperview()
        }
        
        categoryButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        emojiCollectionView.snp.makeConstraints { make in
            make.top.equalTo(buttonsStackView.snp.bottom).offset(32)
            make.height.equalTo(204 + 18)
            make.width.equalToSuperview()
        }
        
        colorSelectCollectionView.snp.makeConstraints { make in
            make.top.equalTo(emojiCollectionView.snp.bottom).offset(40 - 24)
            make.height.equalTo(204 + 18)
            make.width.equalToSuperview()
        }
        
        cancelAndCreateButtonsStackView.snp.makeConstraints { make in
            make.top.equalTo(colorSelectCollectionView.snp.bottom)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(34)
        }
    }
    
    private func updateTracker() {
        guard let editableTracker = editableTracker else { return }
        factory.editTracker(
            id: editableTracker.id,
            newTitle: addTrackerNameField.text ?? "",
            newColor: factory.selectedColor,
            newEmoji: factory.selectedEmoji, 
            isPinned: factory.isPinned,
            newSchedule: factory.schedule,
            oldCategoryName: categoryName,
            newCategoryName: newCategoryName
        )
    }
    
    //MARK: - ACTIONS
    
    @objc private func didTapCategoryButton() {
        let viewController = CategorySelectViewController(selectedCategoryName: categoryName)
        viewController.categoryNameSelected = { [weak self] category in
            self?.newCategoryName = category
            self?.categorySelected = !category.isEmpty
            self?.categoryButton.addSupplementaryView(with: category)
            
            guard let editableTracker = self?.editableTracker else { return } //если при редактировании привычки создать новую категрию, а потом вернуться на экран редактирования трекера - расписание сбрасывается - пока не понял почему так, ведь все остальное остается на месте. Однако "все остальное" не храниться в factory - возможно дело в этом.
            self?.factory.schedule = editableTracker.schedule
        }
        
        present(UINavigationController(rootViewController: viewController), animated: true)
        tryEnableCreationButton()
    }
    
    @objc private func didTapScheduleButton() {
        let viewController = ScheduleViewController()
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
    
    @objc private func didTapCreateButton() {
        if editableTracker != nil {
            updateTracker()
        } else {
            let tracker = Tracker(
                id: UUID(),
                title: addTrackerNameField.text ?? "",
                color: factory.selectedColor,
                emoji: factory.selectedEmoji,
                isPinned: factory.isPinned,
                schedule: factory.schedule)
            
            factory.addToStorage(tracker: tracker, for: newCategoryName)
            factory.schedule = Array(repeating: false, count: WeekDay.allCases.count)  //приводим к исходному schedule после добавления трекера в хранилище
        }
        
        factory.updateTrackersForShowing()
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    private func configureScheduleButtonSupplementaryText(for schedule: [Bool]) -> String {
        var suoplementaryText: String = ""
        let weekdays = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
        let selectedDays = schedule.enumerated()
            .filter { $0.element }
            .map { weekdays[$0.offset] }
        scheduleButton.addSupplementaryView(with: selectedDays.joined(separator: ", "))
        suoplementaryText = selectedDays.joined(separator: ", ")
        return suoplementaryText
    }
    
    @objc private func addScheduleButtonSupplementaryText() {
        scheduleDidSet = factory.schedule.contains(true)
        tryEnableCreationButton()
        scheduleButton.addSupplementaryView(with: configureScheduleButtonSupplementaryText(for: factory.schedule))
    }
    private let appDelegate = AppDelegate()
    
    @objc private func didTapCancelButton() {
        self.dismiss(animated: true)
    }
    
    @objc private  func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - textField Delegate

extension EditTrackerViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(trackerNameEntered, categorySelected, scheduleDidSet, emojiSelected, colorSelected)
        guard let currentText = addTrackerNameField.text else { return true }
        let newTextLenght = currentText.count + string.count - range.length
        trackerNameEntered = newTextLenght != 0 ? true : false
        tryEnableCreationButton()
        
        let isBiggerThen = newTextLenght > 38
        warningLabel.isHidden = !isBiggerThen
        return !isBiggerThen
    }
    
}

//MARK: - UICollectionViewDataSource & UICollectionViewDelegate

extension EditTrackerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            
            switch collectionView {
            case emojiCollectionView:
                return EmojiCell.emojiArray.count
            default:
                return ColorSelectCell.colors.count
            }
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            switch collectionView {
            case emojiCollectionView:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.reuseIdentifier, for: indexPath) as? EmojiCell else {
                    return .init()
                }
                let isSeclected = selectedEmojiCellIndexPath == indexPath
                cell.configureCell(with: EmojiCell.emojiArray[indexPath.item], isSelected: isSeclected)
                return cell
                
            default:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorSelectCell.reuseIdentifier, for: indexPath) as? ColorSelectCell else {
                    return .init()
                }
                let isSelected = selectedColorCellIndexPath == indexPath
                
                cell.configureCell(color: ColorSelectCell.colors[indexPath.item], isSelected: isSelected)
                return cell
            }
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView {
            switch collectionView {
            case emojiCollectionView:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EmojiCollectionHeader.identifier, for: indexPath) as? EmojiCollectionHeader else {
                    return .init()
                }
                return header
                
            default:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ColorSelectCollectionHeader.identifier, for: indexPath) as? ColorSelectCollectionHeader else {
                    return .init()
                }
                return header
            }
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize {
            .init(width: 52, height: 18)
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
            
        case emojiCollectionView:
            factory.selectedEmoji = EmojiCell.emojiArray[indexPath.row]
            selectedEmojiCellIndexPath = indexPath
            emojiSelected = true
            
        default:
            factory.selectedColor = ColorSelectCell.colors[indexPath.row]
            selectedColorCellIndexPath = indexPath
            colorSelected = true
        }
        
        collectionView.reloadData()
        tryEnableCreationButton()
    }
    
}
