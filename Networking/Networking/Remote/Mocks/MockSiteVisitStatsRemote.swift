import Foundation

public struct MockSiteVisitStatsRemote: SiteVisitStatsRemoteProtocol {

    private let objectGraph: MockObjectGraph

    public init(objectGraph: MockObjectGraph) {
        self.objectGraph = objectGraph
    }

    public func loadSiteVisitorStats(for siteID: Int64,
                                     siteTimezone: TimeZone? = nil,
                                     unit: StatGranularity,
                                     latestDateToInclude: Date,
                                     quantity: Int,
                                     completion: @escaping (SiteVisitStats?, Error?) -> Void
    ) {
        //TODO: Implement this!
        completion(nil, nil)
    }
}
