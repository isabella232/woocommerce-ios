import Foundation
import Alamofire

public struct MockSiteSettingsRemote: SiteSettingsRemoteProtocol {

    private let objectGraph: MockObjectGraph

    public init(objectGraph: MockObjectGraph) {
        self.objectGraph = objectGraph
    }

    public func loadGeneralSettings(for siteID: Int64, completion: @escaping ([SiteSetting]?, Error?) -> Void) {
        completion([], nil)
    }

    public func loadProductSettings(for siteID: Int64, completion: @escaping ([SiteSetting]?, Error?) -> Void) {
        completion([], nil)
    }
}
