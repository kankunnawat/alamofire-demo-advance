import Foundation
import Alamofire

class GitAPIManager {
    static let shared = GitAPIManager()

    func fetchPopularSwiftRepositories(completion: @escaping ([Repository]) -> Void) {
        searchRepositories(query: "language:Swift", completion: completion)
    }

    func fetchCommits(for repository: String, completion: @escaping ([Commit]) -> Void) {
        let url = "https://api.github.com/repos/\(repository)/commits"
        AF.request(url)
            .responseDecodable(of: [Commit].self) { response in
                guard let commits = response.value else {
                    return
                }
                completion(commits)
            }
    }

    func searchRepositories(query: String, completion: @escaping ([Repository]) -> Void) {
        let url = "https://api.github.com/search/repositories"
        var queryParameters: [String: Any] = ["sort": "stars", "order": "desc", "page": 1]
        queryParameters["q"] = query
        AF.request(url, parameters: queryParameters)
            .responseDecodable(of: Repositories.self) { response in
                guard let items = response.value else {
                    return completion([])
                }
                completion(items.items)
            }
    }
}
