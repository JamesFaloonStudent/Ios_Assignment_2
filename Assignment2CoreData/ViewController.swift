import UIKit

class ViewController: UIViewController {
    
    // 1. Make this a variable so it can be updated
    var data: [Message] = []
    
    // 2. Create the table as a property so other functions can see it
    let tableview = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Add the "+" button to the right side of the navigation bar
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                target: self,
                                                                action: #selector(didTapAdd))
        
        
        // Setup Table Frame & Constraints
        tableview.frame = self.view.bounds
        tableview.delegate = self
        tableview.dataSource = self
        
        // Register a cell class
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableview)
        
        // 3. Fetch the data and refresh the table
        loadData()
    }
    
    func loadData() {
        // Fetch from service and refresh UI
//        CoreDataService.shared.createTestData();
        self.data = CoreDataService.shared.fetchData() ?? []
        self.tableview.reloadData()
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
                // 1. Save to Core Data
                CoreDataService.shared.createMessage(text: text)
                
                // 2. Refresh the UI
                self?.loadData()
            }
        }))
        
        present(alert, animated: true)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Use dequeue for better performance
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Get the specific message object for this row
        let messageObject = data[indexPath.row]
        
        // Set the text from the message attribute
        cell.textLabel?.text = messageObject.message
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // 1. Get the message to delete
            let messageToDelete = data[indexPath.row]
            
            // 2. Delete from Core Data via your service
            // Since your deleteMessage uses UUID, we pass the id
            if let id = messageToDelete.id {
                CoreDataService.shared.deleteMessage(id: id)
            }
            
            // 3. Update the local array and the UI
            data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1. Deselect the row so it doesn't stay gray
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 2. Get the specific message that was clicked
        let messageToPass = data[indexPath.row]
        
        // 3. Initialize the second View Controller
        let detailVC = DetailViewController()
        
        // 4. Pass the data!
        detailVC.selectedMessage = messageToPass
        
        // 5. Push it onto the navigation controller
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}




