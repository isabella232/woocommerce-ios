import Foundation

public struct MockLeaderboardsRemote: LeaderboardsRemoteProtocol {

    private let objectGraph: MockObjectGraph

    public init(objectGraph: MockObjectGraph) {
        self.objectGraph = objectGraph
    }

    public func loadLeaderboards(for siteID: Int64,
                                 unit: StatsGranularityV4,
                                 earliestDateToInclude: String,
                                 latestDateToInclude: String,
                                 quantity: Int,
                                 completion: @escaping (Result<[Leaderboard], Error>) -> Void) {
        // TODO: Implement This
        completion(.success([]))
    }
}
