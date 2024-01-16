//
//  EmployeeCell.swift
//  mulTiple
//
//  Created by Emirhan Karahan on 14.01.2024.
//

import UIKit

final class EmployeeCell: UITableViewCell {
    
    static let identifier = "EmployeeCell"
    
    private lazy var employeeImageView: EmployeeImageView = {
        let imageView = EmployeeImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.accessibilityTraits = .image
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private lazy var jobDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        return label
    }()
    
    func configure(model: Employee){
        nameLabel.text = model.name
        jobDescriptionLabel.text = model.jobDescription
        Task {
            try await employeeImageView.loadImage(urlString: model.imageURL)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(employeeImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(jobDescriptionLabel)
        
        NSLayoutConstraint.activate([
            employeeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            employeeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            employeeImageView.widthAnchor.constraint(equalToConstant: 60),
            employeeImageView.heightAnchor.constraint(equalToConstant: 60),
            
            nameLabel.topAnchor.constraint(equalTo: employeeImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: employeeImageView.trailingAnchor, constant: 10),
            
            jobDescriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            jobDescriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
        ])
    }
    
}
