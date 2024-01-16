//
//  ViewController.swift
//  mulTiple
//
//  Created by Emirhan Karahan on 6.01.2024.
//

import UIKit

final class ViewController: UIViewController {
    
    private lazy var employeeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "HOME_TITLE")
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    private lazy var employeeTipLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "HOME_SUBTITLE")
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    private lazy var employeesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        tableView.register(EmployeeCell.self, forCellReuseIdentifier: EmployeeCell.identifier)
        return tableView
    }()
    
    private var employees: [Employee] = [] {
        didSet {
            employeesTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
       
        Task {
            do {
                employees = try await fetchEmployees()
            }
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = AppConfig.appName
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .app
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        view.addSubview(employeeLabel)
        view.addSubview(employeeTipLabel)
        view.addSubview(employeesTableView)
        
        NSLayoutConstraint.activate([
            employeeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            employeeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            
            employeeTipLabel.leadingAnchor.constraint(equalTo: employeeLabel.leadingAnchor),
            employeeTipLabel.topAnchor.constraint(equalTo: employeeLabel.bottomAnchor),
            
            employeesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            employeesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            employeesTableView.topAnchor.constraint(equalTo: employeeTipLabel.bottomAnchor, constant: 10),
            employeesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: UITableView Configurations
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeCell.identifier, for: indexPath) as! EmployeeCell
        cell.configure(model: employees[indexPath.row])
        return cell
    }
    
}

// MARK: API Calls
extension ViewController {
    
    private func fetchEmployees() async throws -> [Employee] {
        let endpoint = AppConfig.apiUrl + "employees"
        guard let url = URL(string: endpoint) else {
            throw EmployeeError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw EmployeeError.unexpectedStatusCode
        }
        
        do {
            let data = try JSONDecoder().decode(EmployeeModel.self, from: data)
            return data.employees
        } catch {
            throw EmployeeError.decodingError
        }
    }
    
}

enum EmployeeError: Error {
    case unexpectedStatusCode
    case decodingError
    case invalidURL
}

struct EmployeeModel: Codable {
    let employees: [Employee]
}

struct Employee: Codable {
    let name, jobDescription, imageURL: String

    enum CodingKeys: String, CodingKey {
        case name, jobDescription
        case imageURL = "imageUrl"
    }
}

#Preview {
    UINavigationController(rootViewController: ViewController())
}

