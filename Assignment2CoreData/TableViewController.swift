import UIKit

class TableViewController : UITableViewController {
    
    // 1. Data array
    var data: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Messages"
        
        // 2. Add the "+" button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(didTapAdd))
        
        // 3. Register cell on the built-in 'tableView'
        // In UITableViewController, you don't need to set delegates or add as subview
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        loadData()
    }
    
    func loadData() {
        // Fetch from service and refresh the built-in tableView
        self.data = CoreDataService.shared.fetchData() ?? []
        self.tableView.reloadData()
    }
    
    @objc func didTapAdd() {
        let alert = UIAlertController(title: "New Message",
                                      message: "Enter what you want to save",
                                      preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Type here..."
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            if let text = alert.textFields?.first?.text, !text.isEmpty {
                CoreDataService.shared.createMessage(text: text)
                self?.loadData()
            }
        }))
        
        present(alert, animated: true)
    }

    // MARK: - Table view data source
    // NOTE: You don't need to put these in an extension if you don't want to,
    // UITableViewController already conforms to these protocols.

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let messageObject = data[indexPath.row]
        cell.textLabel?.text = messageObject.message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let messageToDelete = data[indexPath.row]
            
            if let id = messageToDelete.id {
                CoreDataService.shared.deleteMessage(id: id)
            }
            
            data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let messageToPass = data[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.selectedMessage = messageToPass
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
