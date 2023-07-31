//
//  ListViewController.swift
//  ToDoList
//
//  Created by Kurbatov Artem on 29.07.2023.
//

import UIKit

class ListViewController: UIViewController {
    
    private lazy var listTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: Identifiers.taskCell)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let presenter: ListPresenter
    private var tasks: [Task] = []
    
    init(presenter: ListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        listTableView.dataSource = self
        viewSetup()
    }
    
    private func viewSetup() {
        view.backgroundColor = .systemGray6
        self.tasks = self.presenter.loadTasks()
        setConstraints()
        setupNavigationBar()
        setBackgroundColor()
    }
    
    private func setupNavigationBar() {
        self.title = "To Do list"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidTap))
    }
    
    private func setBackgroundColor() {
        view.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : .systemGray6
    }
    
    private func setConstraints() {
        view.addSubview(listTableView)
        
        NSLayoutConstraint.activate([
            listTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            listTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func addButtonDidTap() {
        self.presenter.addTask(self) { [weak self] taskTitle in
            guard let self else {return}
            self.tasks.append(Task(title: taskTitle))
            self.presenter.saveTasks(self.tasks)
            DispatchQueue.main.async {
                self.listTableView.reloadData()
            }
        }
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = listTableView.dequeueReusableCell(withIdentifier: Identifiers.taskCell, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(with: tasks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listTableView.deselectRow(at: indexPath, animated: true)
        tasks[indexPath.row].isComplited.toggle()
        presenter.saveTasks(tasks)
        listTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let remove = UIContextualAction(style: .destructive, title: "") { (action, view, success:(Bool) -> Void) in
            self.tasks.remove(at: indexPath.row)
            self.presenter.saveTasks(self.tasks)
            self.listTableView.reloadData()
            success(true)
        }
        remove.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [remove])
    }
}
