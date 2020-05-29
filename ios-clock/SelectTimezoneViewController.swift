import UIKit

class SelectTimezoneViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
	
	@IBOutlet var tableView: UITableView? = nil
	@IBOutlet var searchBar: UISearchBar? = nil
	
	let timezones = TimeZone.knownTimeZoneIdentifiers.sorted()
	var filtered = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()

		filtered = timezones
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange: String) {
        if !textDidChange.isEmpty {
            filtered = timezones.filter {
                ($0 as NSString).range(of: textDidChange, options: .caseInsensitive).location != NSNotFound
            }
        } else {
            filtered = timezones
        }
        tableView?.reloadData()
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexPath = tableView.indexPathForSelectedRow, filtered.indices.contains(indexPath.row) {
            let nav = self.navigationController
            let wvc = (nav?.viewControllers[(nav?.viewControllers.count)! - 2]) as! WorldClockViewController
            wvc.addTimezone(identifier: filtered[indexPath.row])
        }
        self.navigationController?.popViewController(animated: true)
    }

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filtered.count
	}

	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "timezone", for: indexPath)
		cell.textLabel!.text = filtered[indexPath.row]
		return cell
	}

}

