import UIKit

class RepositoriesViewController: UITableViewController {
    var repositories: [Repository] = []
    var selectedRepository: Repository?
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    var isLoggedIn: Bool {
        if TokenManager.shared.fetchAccessToken() != nil {
            return true
        }
        return false
    }

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        loginButton.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Avoid reloading repositories if active search is in place
        if let searchText = searchBar.text, !searchText.isEmpty {
            return
        }
        if isLoggedIn {
            loginButton.setTitle("Logout", for: .normal)
            fetchAndDisplayUserRepositories()
        } else {
            loginButton.setTitle("Login", for: .normal)
            fetchAndDisplayPopularSwiftRepositories()
        }
    }

    func fetchAndDisplayPopularSwiftRepositories() {
        loadingIndicator.startAnimating()
        GitAPIManager.shared.fetchPopularSwiftRepositories { repositories in
            self.repositories = repositories
            self.loadingIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }

    func fetchAndDisplayUserRepositories() {
        //TODO: Add more here..
    }

    func logout() {
        TokenManager.shared.clearAccessToken()
        loginButton.setTitle("Login", for: .normal)
        fetchAndDisplayPopularSwiftRepositories()
    }
}

// MARK: - UITableViewDataSource
extension RepositoriesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath)
        cell.textLabel?.text = repositories[indexPath.row].name
        cell.detailTextLabel?.text = repositories[indexPath.row].description
        return cell
    }
}

// MARK: - UITableViewDeletage
extension RepositoriesViewController {
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedRepository = repositories[indexPath.row]
        return indexPath
    }
}

// MARK: - Handling Segue
extension RepositoriesViewController {
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "LoginSegue" {
            let shouldProceed = !isLoggedIn
            if isLoggedIn {
                //logout button pressed
                logout()
            }
            return shouldProceed
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommitSegue" {
            guard let commitsViewController = segue.destination as? RepositoryCommitsViewController else {
                return
            }
            commitsViewController.selectedRepository = selectedRepository
        }
    }
}

// MARK: - UISearchBarDelegate
extension RepositoriesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            return
        }
        loadingIndicator.startAnimating()
        GitAPIManager.shared.searchRepositories(query: query) { repositories in
            self.repositories = repositories
            self.loadingIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        if isLoggedIn {
            fetchAndDisplayUserRepositories()
        } else {
            fetchAndDisplayPopularSwiftRepositories()
        }
    }
}
