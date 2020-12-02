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

        let siteApiRemote = MockSiteAPIRemote(objectGraph: objectGraph)
        let siteSettingsRemote = SiteSettingsRemote(network: network)

        let services = [
            AccountStore(dispatcher: dispatcher, storageManager: storageManager, network: network, remote: MockAccountRemote(objectGraph: objectGraph)),
            ProductStore(dispatcher: dispatcher, storageManager: storageManager, network: network, remote: MockProductRemote(objectGraph: objectGraph)),
            SettingStore(dispatcher: dispatcher, storageManager: storageManager, network: network, siteAPIRemote: siteApiRemote, siteSettingsRemote: siteSettingsRemote),
            OrderStore(dispatcher: dispatcher, storageManager: storageManager, network: network, remote: MockOrdersRemote(objectGraph: objectGraph)),
        ]

        super.init(credentials: objectGraph.userCredentials, dispatcher: dispatcher, services: services)
    }
}
