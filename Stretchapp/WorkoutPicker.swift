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

    typealias ProductList = [Workout]
    typealias CellRegistration = UICollectionView.CellRegistration<WorkoutCell, Workout>

    private lazy var collectionView = makeCollectionView()
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Workout>! = makeDataSource()

    // MARK: - Initializers

    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
        addSubviewsAndConstraints()

        updateSnapshot(Workout.dummies)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup() {
        view.backgroundColor = .clear

        collectionView.register(WorkoutCell.self, forCellWithReuseIdentifier: WorkoutCell.reuseIdentifier)
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

    func updateSnapshot(_ list: ProductList) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Workout>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(list, toSection: .all)
        dataSource.apply(snapshot)
    }

    func makeCollectionView() -> UICollectionView {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: createBasicListLayout())
        return cv
    }

    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Workout> {
        UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, product in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutCell.reuseIdentifier, for: indexPath) as! WorkoutCell
                cell.update(with: product)
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

    func createBasicListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(WorkoutCell.width), heightDimension: .absolute(WorkoutCell.height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(WorkoutCell.width), heightDimension: .absolute(WorkoutCell.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .some(NSCollectionLayoutSpacing.fixed(20))
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}



final class WorkoutCell: UICollectionViewCell {

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

