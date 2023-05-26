//
//  HabitCollectionViewController.swift
//  Habits
//
//  Created by Natasha Machado on 2023-05-25.
//

import UIKit

private let reuseIdentifier = "Cell"

enum Section: Hashable, Comparable {
  case favorites
  case category(_ category: Category)
}

class HabitCollectionViewController: UICollectionViewController {
  
  
  var dataSource: DataSourceType!
  var model = Model()
  var habitsRequestTask: Task<Void, Never>? = nil
  deinit { habitsRequestTask?.cancel() }
  
  struct Model {
    var habitsByName = [String: Habit]()
    var favoriteHabits: [Habit] {
      return Settings.shared.favoriteHabits
    }
  }
  
  
  
  override func viewDidLoad() {
    dataSource = createDataSource()
    collectionView.dataSource = dataSource
    collectionView.collectionViewLayout = createLayout()
    super.viewDidLoad()
  }
  
  
  func update() {
    habitsRequestTask?.cancel()
    habitsRequestTask = Task {
      if let habits = try? await HabitRequest().send() {
        self.model.habitsByName = habits
      } else {
        self.model.habitsByName = [:]
      }
      self.updateCollectionView()
      habitsRequestTask = nil
    }
  }
  
  func updateCollectionView() {
    var itemsBySection = model.habitsByName.values.reduce(into:[ViewModel.Section: [ViewModel.Item]]()) { partial, habit in let item = habit
      let section: ViewModel.Section
      if model.favoriteHabits.contains(habit) {
        section = .favorites
      } else {
        section = .category(habit.category)
      }
      partial[section, default: []].append(item)
    }
    dataSource.applySnapshotUsing(sectionIDs:sectionIDs,itemsBySection: itemsBySection)
    itemsBySection = itemsBySection.mapValues { $0.sorted() }
  }
  
  let sectionIDs = itemsBySection.keys.sorted()
  
  typealias DataSourceType =
  UICollectionViewDiffableDataSource<ViewModel.Section,ViewModel.Item>
  enum ViewModel {
    enum Section: Hashable {
      case favorites
      case category(_ category: Category)
    }
    typealias Item = Habit
  }
  
  static func < (lhs: Section, rhs: Section) -> Bool {
    switch (lhs, rhs) {
    case (.category(let l), .category(let r)):
      return l.name < r.name
    case (.favorites, _):
      return true
    case (_, .favorites):
      return false
    }
  }
  
  func createDataSource() -> DataSourceType {
    let dataSource = DataSourceType(collectionView: collectionView) {
      (collectionView, indexPath, item) in
      let cell =
      collectionView.dequeueReusableCell(withReuseIdentifier: "Habit", for: indexPath) as! UICollectionViewListCell
      var content = cell.defaultContentConfiguration()
      content.text = item.name
      cell.contentConfiguration = content
      return cell
    }
    return dataSource
    dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
      let header = collectionView.dequeueReusableSupplementaryView(ofKind: "SectionHeader", withReuseIdentifier: "HeaderView", for:indexPath) as! NamedSectionHeaderView
      let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
      switch section {
      case .favorites:
        header.nameLabel.text = "Favorites"
      case .category(let category):
        header.nameLabel.text = category.name
      }
      
      return header
    }
    
    
    func createLayout() -> UICollectionViewCompositionalLayout {
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
      let groupSize =
      NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                             heightDimension: .absolute(44))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize:
                                                      groupSize, subitem: item, count: 1)
      
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                      leading: 10, bottom: 0, trailing: 10)
      
      return UICollectionViewCompositionalLayout(section: section)
      let headerSize =
      NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                             heightDimension: .absolute(36))
      let sectionHeader =
      NSCollectionLayoutBoundarySupplementaryItem(layoutSize:
                                                    headerSize, elementKind: "SectionHeader", alignment: .top)
      sectionHeader.pinToVisibleBounds = true
       
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                      leading: 10, bottom: 0, trailing: 10)
      section.boundarySupplementaryItems = [sectionHeader]
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      update()
    }
    
  }
}
