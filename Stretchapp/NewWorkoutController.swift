//
//  NewWorkoutController.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 28/03/2021.
//

import UIKit


final class NewWorkoutController: UIViewController, StretchInputDelegate, UICollectionViewDelegate {

    // MARK: - Properties

    private let saveButton = ButtonWithBackground("Save")
    private let backButton = UIButton.make(.back)
    private let wobbler = WobbleView()
    private let nameLabel = UILabel.make(.header)
    private let addButton = UIButton.make(.plusPill)
    private let addButtonBackground = UIView()

    typealias ProductList = [Workout]
    typealias CellRegistration = UICollectionView.CellRegistration<StretchCell, Stretch>

    private lazy var collectionView = makeCollectionView()
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Stretch>! = makeDataSource()
    private var data = [Stretch]()

    // MARK: - Initializers

    init(title: String) {
        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = .background
        nameLabel.text = title

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup() {
        backButton.tintColor = .background
        nameLabel.textColor = .background
        nameLabel.textAlignment = .left
        backButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
        addButton.tintColor = .background
        addButton.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi/4)
        addButtonBackground.layer.cornerRadius = 64/2
        addButtonBackground.backgroundColor = .primaryContrast

        collectionView.register(StretchCell.self, forCellWithReuseIdentifier: StretchCell.reuseIdentifier)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.clipsToBounds = false

        backButton.tintColor = .primaryContrast

        addButton.addTarget(self, action: #selector(getTextInput), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(clickedSave), for: .touchUpInside)
    }

    @objc private func clickedSave() {
        var mins = 0
        var secs = 0

        guard data.count > 0 else { return }

        data.append(Stretch.completion)

        data.forEach({
            if $0.length.type == .minutes {
                mins += $0.length.amount
            } else {
                secs += $0.length.amount
            }
        })

        let totalMins = mins + secs%60
        let workout = Workout(name: nameLabel.text ?? "NO NAME", duration: Duration(amount: totalMins, type: .minutes), stretches: data)
        DAO.saveWorkout(workout)
        dismiss(animated: true)
    }

    func receive(stretch: Stretch) {
        data.append(stretch)
        updateSnapshot(data)
    }

    func updateSnapshot(_ list: [Stretch]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Stretch>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(list, toSection: .all)
        dataSource.apply(snapshot)
    }

    func makeCollectionView() -> UICollectionView {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: createBasicListLayout())
        return cv
    }

    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Stretch> {
        UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, stretch in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StretchCell.reuseIdentifier, for: indexPath) as! StretchCell
                cell.update(with: stretch)
                return cell
            }
        )
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Implement me: Go to edit")
    }

    func createBasicListLayout() -> UICollectionViewLayout {
        let height: CGFloat = 80
        let width: CGFloat = screenWidth

        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(width), heightDimension: .absolute(height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(width), heightDimension: .absolute(height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .some(NSCollectionLayoutSpacing.fixed(20))
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    @objc private func getTextInput() {
        let vc = StretchInputController()
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }

    @objc private func exit() {
        dismiss(animated: false)
    }

    private func addSubviewsAndConstraints() {
        wobbler.transform = CGAffineTransform.init(rotationAngle: -CGFloat.pi/4).scaledBy(x: 2, y: 4).translatedBy(x: -200, y: -30)
        wobbler.alpha = 0
        view.addSubview(wobbler)
        view.addSubview(backButton)
        view.addSubview(nameLabel)
        view.addSubview(addButtonBackground)
        view.addSubview(addButton)
        view.addSubview(collectionView)
        view.addSubview(saveButton)

        saveButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(backButton)
            make.right.equalToSuperview().inset(24)
        }

        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.size.equalTo(48)
        }

        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backButton.snp.right).offset(24)
            make.right.equalToSuperview()
            make.height.equalTo(48)
            make.centerY.equalTo(backButton)
        }

        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(80)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(addButton.snp.top)
        }

        addButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-48)
        }

        addButtonBackground.snp.makeConstraints { (make) in
            make.center.equalTo(addButton)
            make.size.equalTo(64)
        }
    }
}


final class StretchCell: UICollectionViewCell {

    // MARK: - Properties

    static let reuseIdentifier = "Stretch-cell"
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

    func update(with data: Stretch) {
        cellView.leftLabel.text = data.title
        cellView.rightLabel.text = "\(data.length.amount) \(data.length.type.rawValue)"
    }
}
