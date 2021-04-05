import UIKit


enum DurationType: String, Codable {
    case minutes = "m"
    case seconds = "s"

    enum CodingKeys: String, CodingKey {
       case minutes
       case seconds
    }
}


struct Duration: Hashable, Codable {
    let amount: Int
    let type: DurationType

    enum CodingKeys: String, CodingKey {
       case amount
       case type
    }
}


struct Workout: Hashable, Codable {
    let name: String
    let duration: Duration
    let stretches: [Stretch]

    static let dummy = Workout(name: "Test workout", duration: Duration(amount: 45, type: .seconds), stretches: Stretch.forDebugging)
    static let dummies = [
        Workout(name: "Forward folding", duration: Duration(amount: 45, type: .seconds), stretches: Stretch.forDebugging),
        Workout(name: "Gabos Schnip", duration: Duration(amount: 45, type: .minutes), stretches: Stretch.favourites),
        Workout(name: "Programmer stretches", duration: Duration(amount: 10, type: .minutes), stretches: Stretch.forDebugging)]

    enum CodingKeys: String, CodingKey {
       case name
       case duration
       case stretches
    }
}


enum Section: Int, CaseIterable {
    case featured
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
//        let layout = makeListLayout()
        let layoutConfig = makeSwipeableLayoutConfig()
        let layout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return collectionView
    }

    func updateSnapshot(_ list: WorkoutList) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Workout>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(list, toSection: .all)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func makeSwipeableLayoutConfig() -> UICollectionLayoutListConfiguration {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .grouped)
        layoutConfig.trailingSwipeActionsConfigurationProvider = { [unowned self] (indexPath) in
            // 1
             guard let item = dataSource.itemIdentifier(for: indexPath) else {
                 return nil
             }

             // 2
             // Create action 1
             let action1 = UIContextualAction(style: .normal, title: "Action 1") { (action, view, completion) in

                 // 3
                 // Handle swipe action by showing alert message
                 handleSwipe(for: action, item: item)

                 // 4
                 // Trigger the action completion handler
                 completion(true)
             }
             // 5
             action1.backgroundColor = .systemGreen
            return UISwipeActionsConfiguration(actions: [action1])
        }

        return layoutConfig
    }


    func handleSwipe(for action: UIContextualAction, item: Workout) {

        let alert = UIAlertController(title: action.title,
                                      message: item.name,
                                      preferredStyle: .alert)

        let okAction = UIAlertAction(title:"OK", style: .default, handler: { (_) in })
        alert.addAction(okAction)

        present(alert, animated: true, completion:nil)
    }

    typealias WorkoutCellRegistration = UICollectionView.CellRegistration<WorkoutCell, Workout>
    func makeCellRegistration() -> WorkoutCellRegistration {
        return UICollectionView.CellRegistration<WorkoutCell, Workout> { (cell, indexPath, item) in
            // Define how data should be shown using content configuration
            var content = cell.defaultContentConfiguration() // FIXME: I need to make this my self
            content.text = item.name
            cell.contentConfiguration = content
        }
    }

    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Workout> {
        UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, workout in
                let cellRegistration = self.makeCellRegistration()
                let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: workout)
                cell.update(with: workout)
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

final class WorkoutCell: UICollectionViewListCell {

    // MARK: - Properties

    static let reuseIdentifier = "Workout-cell"
    static let height: CGFloat = 80
    static let width: CGFloat = screenWidth

    let cellView = WorkoutCellView()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func setup() {
        backgroundColor = .clear
    }

    private func addSubviewsAndConstraints() {
        contentView.addSubview(cellView)
        cellView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    // MARK: API

    func update(with data: Workout) {
        cellView.leftLabel.text = data.name
        cellView.rightLabel.text = "\(data.duration.amount) \(data.duration.type.rawValue)"
    }
}


final class WorkoutCellView: UIView {

    // MARK: - Properties

    let leftLabel = UILabel.make(.header)
    let rightLabel = UILabel.make(.header)
    let background = UIView()

    // MARK: - Initializers

    init() {
        super.init(frame: .zero)

        setup()
        addSubviewsAndConstraints()
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
        }

        rightLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(background).inset(16)
            make.width.equalTo(100)
        }
    }
}

