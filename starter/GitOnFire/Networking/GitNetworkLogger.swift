import Foundation
import Alamofire

class GitNetworkLogger: EventMonitor {
    let queue = DispatchQueue(label: "com.raywenderlich.gitonfire.networklogger")
    func requestDidFinish(_ request: Request) {
        print("res: ", request.description)
    }

    func request<Value>(
        _ request: DataRequest,
        didParseResponse response: DataResponse<Value, AFError>
    ) {
        guard let data = response.data else { return }
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
            print("res: ", json)
        }
    }
}
