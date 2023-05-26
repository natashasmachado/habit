//
//  NamedSectionHeaderView..swift
//  Habits
//
//  Created by Natasha Machado on 2023-05-25.
//

import UIKit

class NamedSectionHeaderView_: UICollectionReusableView {
      let nameLabel: UILabel = {
          let label = UILabel()
          label.textColor = .label
          label.font = UIFont.boldSystemFont(ofSize: 17)
   
          return label
      }()
   
      override init(frame: CGRect) {
          super.init(frame: frame)
          setupView()
      }
   
      required init?(coder: NSCoder) {
          super.init(coder: coder)
          setupView()
      }
   
      private func setupView() {
          backgroundColor = .systemGray5
   
          addSubview(nameLabel)
          nameLabel.translatesAutoresizingMaskIntoConstraints = false
   
          NSLayoutConstraint.activate([
              nameLabel.leadingAnchor.constraint(equalTo:
                 leadingAnchor, constant: 12),
              nameLabel.centerYAnchor.constraint(equalTo:
                 centerYAnchor)
          ])
      }
  }
