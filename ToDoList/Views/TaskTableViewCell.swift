//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by Kurbatov Artem on 29.07.2023.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    private lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var complitionIndicatorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        taskLabel.text = nil
        complitionIndicatorImageView.tintColor = .gray
    }
    
    func configureCell(with task: Task) {
        taskLabel.text = task.title
        complitionIndicatorImageView.tintColor = task.isComplited ? .systemGreen : .gray
    }
    
    private func setConstraints() {
        contentView.addSubview(taskLabel)
        contentView.addSubview(complitionIndicatorImageView)
        
        NSLayoutConstraint.activate([
            taskLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            taskLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.8),
            taskLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            taskLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            taskLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        
            complitionIndicatorImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            complitionIndicatorImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
