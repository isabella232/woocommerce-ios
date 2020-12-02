import Foundation
import Alamofire

public struct MockSiteAPIRemote: SiteAPIRemoteProtocol {

    private let objectGraph: MockObjectGraph

    public init(objectGraph: MockObjectGraph) {
        self.objectGraph = objectGraph
    }

    public func loadAPIInformation(for siteID: Int64, completion: @escaping (SiteAPI?, Error?) -> Void) {
        completion(objectGraph.defaultSiteAPI, nil)
    }
}
