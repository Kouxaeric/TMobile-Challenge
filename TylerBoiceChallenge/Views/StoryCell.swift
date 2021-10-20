//
//  StoryCell.swift
//  TylerBoiceChallenge
//
//  Created by Tyler Boice on 19/10/21.
//

import UIKit

class StoryCell: UITableViewCell {
    
    static let identifier = "StoryCell"
    
    // MARK: - override
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private properties
    lazy private var storyImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy private var storyTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    lazy private var storyNumCommentsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - internal func
    func configureCell(title: String?, numComments: String?, data: Data?) {
        storyTitleLabel.text = title
        storyNumCommentsLabel.text = "# comments: \(numComments ?? "")"
        storyImageView.image = nil
        
        if let data = data {
            storyImageView.image = UIImage(data: data)
        }
    }
    
    // MARK: - private func
    private func setUpUI() {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        
        stackView.addArrangedSubview(storyTitleLabel)
        stackView.addArrangedSubview(storyImageView)
        stackView.addArrangedSubview(storyNumCommentsLabel)
        
        contentView.addSubview(stackView)
        
        // setup constraint
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 15.0).isActive = true
        
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15.0).isActive = true
    }
}
