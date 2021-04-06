import UIKit


enum Section: Int, CaseIterable {
    case all
}


final class WorkoutPicker: UIViewController, UICollectionViewDelegate {

    // MARK: - Properties

    typealias WorkoutList = [Workout]

    private lazy var collectionView = makeCollectionView()
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Workout>! = makeDataSource()

    // MARK: - Initializers

    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
        addSubviewsAndConstraints()

        let workouts = DAO.getWorkouts()
        updateSnapshot(workouts)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup() {
        view.backgroundColor = .clear
        view.clipsToBounds = true
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.clipsToBounds = false
    }

    private func addSubviewsAndConstraints() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    func makeCollectionView() -> UICollectionView {
        let layoutConfig = makeSwipeableLayoutConfig()
        let layout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .purple
        return collectionView
    }

    func updateSnapshot(_ list: WorkoutList) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Workout>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(list, toSection: .all)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func makeSwipeableLayoutConfig() -> UICollectionLayoutListConfiguration {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        layoutConfig.showsSeparators = false
        layoutConfig.backgroundColor = .clear
        layoutConfig.trailingSwipeActionsConfigurationProvider = { [unowned self] (indexPath) in
//            guard let item = dataSource.itemIdentifier(for: indexPath) else { return nil }

            let deleteAction = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
                completion(true)
            }

            deleteAction.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
                UIImage.x?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
            }

            deleteAction.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)

            return UISwipeActionsConfiguration(actions: [deleteAction])
        }

        return layoutConfig
    }

    func handleSwipe(for action: UIContextualAction, item: Workout) {
        let alert = UIAlertController(title: action.title, message: item.name, preferredStyle: .alert)
        let okAction = UIAlertAction(title:"OK", style: .default, handler: { (_) in })
        alert.addAction(okAction)
        present(alert, animated: true, completion:nil)
    }

    typealias WorkoutCellRegistration = UICollectionView.CellRegistration<WorkoutListCell, Workout>
    func makeCellRegistration() -> WorkoutCellRegistration {
        return UICollectionView.CellRegistration<WorkoutListCell, Workout> { (cell, indexPath, workout) in
            // Takes data and uses content configuration to display it
            cell.workout = workout
            cell.backgroundConfiguration = self.makeBackgroundConfiguration()
        }
    }

    func makeBackgroundConfiguration() -> UIBackgroundConfiguration {
        var test = UIBackgroundConfiguration.listPlainCell()
        test.backgroundColor = .clear

        return test
    }

    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Workout> {
        UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, workout in
                let cellRegistration = self.makeCellRegistration()
                let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: workout)
                return cell
            }
        )
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let workout = dataSource.itemIdentifier(for: indexPath) {
            let vc = StretchingViewController(workout.stretches)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
}









struct WorkoutCellContentConfiguration: UIContentConfiguration, Hashable {

    // MARK: - Properties

    var name: String?
    var durationString: String?

    // MARK: - Initializers

    // MARK: - Methods

    func updated(for state: UIConfigurationState) -> Self {
        let updatedConfiguration = self
        return updatedConfiguration
    }

    func makeContentView() -> UIView & UIContentView {
        let cv = WorkoutCellContentView(configuration: self)
        cv.backgroundColor = .clear
        return cv
    }
}



class WorkoutCellContentView: UIView, UIContentView {

    // MARK: - Properties

    let leftLabel = UILabel.make(.header)
    let rightLabel = UILabel.make(.header)
    let background = UIView()

    private var currentConfiguration: WorkoutCellContentConfiguration!
    var configuration: UIContentConfiguration {
        get { currentConfiguration }
        set {
            guard let newConfiguration = newValue as? WorkoutCellContentConfiguration else {
                assertionFailure()
                return
            }
            apply(configuration: newConfiguration)
        }
    }

    // MARK: - Initializers

    init(configuration: WorkoutCellContentConfiguration) {
        super.init(frame: .zero)

        setup()
        addSubviewsAndConstraints()

        apply(configuration: configuration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func setup() {
        background.layer.cornerRadius = 22
        background.backgroundColor = .white

        leftLabel.text = "Hands folded behind the back"
        leftLabel.textAlignment = .left
        leftLabel.numberOfLines = 2
        leftLabel.font = UIFont.fulbo(18)

        rightLabel.text = "90 s"
        rightLabel.font = UIFont.fulbo(24)
        rightLabel.textAlignment = .right
        rightLabel.textColor = UIColor(hex: "#FFC73C")
    }

    func addSubviewsAndConstraints() {
        [background, leftLabel, rightLabel].forEach({ addSubview($0) })

        background.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(6)
        }

        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(background).offset(16)
            make.right.equalTo(rightLabel.snp.left).inset(8)
            make.top.bottom.equalTo(background)
            make.height.equalTo(80).priority(.high)
        }

        rightLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(leftLabel)
            make.right.equalTo(background).inset(16)
            make.width.equalTo(100)
            make.height.equalTo(leftLabel)
        }
    }

    // MARK: - Methods

    private func apply(configuration: WorkoutCellContentConfiguration) {
        // Only apply configuration if new configuration and current configuration are not the same
        guard currentConfiguration != configuration else {
            return
        }

        // Replace current configuration with new configuration
        currentConfiguration = configuration

        leftLabel.text = configuration.name
        rightLabel.text = configuration.durationString
    }
}


final class WorkoutListCell: UICollectionViewListCell {

    // MARK: - Properties

    var workout: Workout?

    // MARK: - Initializers

    override func updateConfiguration(using state: UICellConfigurationState) {
        guard let workout = workout else { return }

        var newConfiguration = WorkoutCellContentConfiguration().updated(for: state)
        newConfiguration.durationString = "\(workout.duration.amount) m"
        newConfiguration.name = workout.name
        contentConfiguration = newConfiguration
    }
}


//final class WorkoutCell: UICollectionViewListCell {
//
//    // MARK: - Properties
//
//    static let height: CGFloat = 80
//    static let width: CGFloat = screenWidth
//
//    let cellView = WorkoutCellView()
//
//    // MARK: - Initializers
//
//    override init(frame: CGRect) {
//        super.init(frame: .zero)
//
//        setup()
//        addSubviewsAndConstraints()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - Methods
//
//    func setup() {
//        backgroundColor = .clear
//    }
//
//    private func addSubviewsAndConstraints() {
//        contentView.addSubview(cellView)
//        cellView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
//    }
//
//    // MARK: API
//
//    func update(with data: Workout) {
//        cellView.leftLabel.text = data.name
//        cellView.rightLabel.text = "\(data.duration.amount) \(data.duration.type.rawValue)"
//    }
//}



