//
//  ViewController.swift
//  TylerBoiceChallenge
//
//  Created by Tyler Boice on 19/10/21.
//

import UIKit
import Combine

class StoriesViewController: UIViewController {

    private let viewModel = StoriesViewModel()
    private var subscribers = Set<AnyCancellable>()
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.dataSource = self
        tableview.prefetchDataSource = self
        tableview.register(StoryCell.self, forCellReuseIdentifier: StoryCell.identifier)
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setupBinding()
    }
    
    // MARK:- private func
    private func setUpUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        // configure constraint
        let safeArea = view.safeAreaLayoutGuide
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    }
    
    private func setupBinding() {
        viewModel
            .$stories
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &subscribers)
        
        viewModel
            .$rowToUpdate
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] row in
                self?.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
            }
            .store(in: &subscribers)
        
        viewModel.loadStories()
    }
}

extension StoriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.totals
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryCell.identifier, for: indexPath) as? StoryCell
        else { return UITableViewCell() }
        
        let row = indexPath.row
        let title = viewModel.getTitle(at: row)
        let numComments = viewModel.getNumComments(at: row)
        let data = viewModel.getImage(by: row)
        cell.configureCell(title: title, numComments: numComments, data: data)
        return cell
    }
}

extension StoriesViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let rows = indexPaths.map{ $0.row }
        viewModel.loadMoreStories(currentRows: rows)
    }
}
