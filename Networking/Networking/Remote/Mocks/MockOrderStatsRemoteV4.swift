import Foundation

public struct MockOrderStatsRemoteV4: OrderStatsRemoteV4Protocol {

    private let objectGraph: MockObjectGraph

    public init(objectGraph: MockObjectGraph) {
        self.objectGraph = objectGraph
    }

    public func loadOrderStats(
        for siteID: Int64,
        unit: StatsGranularityV4,
        earliestDateToInclude: String,
        latestDateToInclude: String,
        quantity: Int,
        completion: @escaping (OrderStatsV4?, Error?) -> Void
    ) {
        //TODO: Implement this
        completion(nil, nil)
    }
}
