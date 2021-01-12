//
//  ExamHistoryTableViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/11.
//

import UIKit

protocol ExamHistoryTableViewProtocol: AnyObject {
    func updateLoading(_ isLoading: Bool)
    func updateTable(_ scores: [PlayScore])
    func displayError(_ message: String)
}

class ExamHistoryTableViewController: UITableViewController {

    private var presenter: ExamHistoryPresenterProtocol!

    private var scores: [PlayScore] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return scores.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExamHistoryTableViewCell", for: indexPath) as? ExamHistoryTableViewCell else {
            fatalError("The dequeued cell is not instance of ExamHistoryTableViewCell.")
        }

        let item = scores[indexPath.item]
        
        cell.dateLabel.text = item.tookDateText
        cell.scoreLabel.text = item.score
        cell.averageAnswerTimeLabel.text = item.averageAnswerSecText
        
        return cell
    }

    func inject(presenter: ExamHistoryPresenterProtocol) {
        self.presenter = presenter
    }
}

extension ExamHistoryTableViewController: ExamHistoryTableViewProtocol {
    // MARK: - View methods
    func updateLoading(_ isLoading: Bool) {
        // deprecatedになった
        // UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
    }

    func updateTable(_ scores: [PlayScore]) {
        self.scores = scores
        self.tableView.reloadData()
        self.tableView.setContentOffset(CGPoint.zero, animated: false)
    }

    func displayError(_ message: String) {
        // TODO
        print("Error: \(message)")
    }
}
