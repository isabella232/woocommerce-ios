import Foundation
import Yosemite
import Networking
import Storage
import CoreData
import Alamofire

class MockAuthenticatedState: AuthenticatedState {

    init(objectGraph: MockObjectGraph) {
        let dispatcher = Dispatcher()
        let storageManager = ServiceLocator.storageManager
        let network = NullNetwork(credentials: objectGraph.userCredentials)

        let services = [
            AccountStore(dispatcher: dispatcher, storageManager: storageManager, network: network, remote: MockAccountRemote(objectGraph: objectGraph)),
            AppSettingsStore(dispatcher: dispatcher, storageManager: storageManager, fileStorage: PListFileStorage()),
            ProductStore(dispatcher: dispatcher, storageManager: storageManager, network: network, remote: MockProductRemote(objectGraph: objectGraph)),
            MockAuthenticatedState.settingStore(dispatcher: dispatcher, storageManager: storageManager, network: network, objectGraph: objectGraph),
            MockAuthenticatedState.statsStore(dispatcher: dispatcher, storageManager: storageManager, network: network, objectGraph: objectGraph),
            OrderStore(dispatcher: dispatcher, storageManager: storageManager, network: network, remote: MockOrdersRemote(objectGraph: objectGraph)),
            MockAuthenticatedState.productReviewStore(dispatcher: dispatcher, storageManager: storageManager, network: network, objectGraph: objectGraph),
        ]

        // Set up stats to work properly
//        dispatcher.dispatch(AppSettingsAction.setStatsVersionLastShown(siteID: objectGraph.defaultSite.siteID, statsVersion: .v4))

        super.init(credentials: objectGraph.userCredentials, dispatcher: dispatcher, services: services)
    }

    private static func productReviewStore(
        dispatcher: Dispatcher,
        storageManager: StorageManagerType,
        network: Network,
        objectGraph: MockObjectGraph
    ) -> ProductReviewStore {
        return ProductReviewStore(
            dispatcher: dispatcher,
            storageManager: storageManager,
            network: network,
            remote: MockProductReviewsRemote(objectGraph: objectGraph)
        )
    }

    private static func settingStore(
        dispatcher: Dispatcher,
        storageManager: StorageManagerType,
        network: Network,
        objectGraph: MockObjectGraph
    ) -> SettingStore {
        return SettingStore(
            dispatcher: dispatcher,
            storageManager: storageManager,
            network: network,
            siteAPIRemote: MockSiteAPIRemote(objectGraph: objectGraph),
            siteSettingsRemote: MockSiteSettingsRemote(objectGraph: objectGraph)
        )
    }

    private static func statsStore(
        dispatcher: Dispatcher,
        storageManager: StorageManagerType,
        network: Network,
        objectGraph: MockObjectGraph
    ) -> StatsStoreV4 {

        return StatsStoreV4(
            dispatcher: dispatcher,
            storageManager: storageManager,
            network: network,
            siteVisitStatsRemote: MockSiteVisitStatsRemote(objectGraph: objectGraph),
            leaderboardsRemote: MockLeaderboardsRemote(objectGraph: objectGraph),
            orderStatsRemote: MockOrderStatsRemoteV4(objectGraph: objectGraph),
            productsRemote: MockProductRemote(objectGraph: objectGraph)
        )
    }
}
