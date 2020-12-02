import Foundation

public struct ScreenshotObjects: MockObjectGraph {

    public init() {
        // Do nothing
    }

    public let userCredentials = Credentials(
        username: i18n.DefaultAccount.username,
        authToken: UUID().uuidString,
        siteAddress: i18n.DefaultSite.url
    )

    public let defaultAccount = Account(
        userID: 1,
        displayName: i18n.DefaultAccount.displayName,
        email: i18n.DefaultAccount.email,
        username: i18n.DefaultAccount.username,
        gravatarUrl: nil
    )

    public let defaultSite = Site(
        siteID: 1,
        name: i18n.DefaultSite.name,
        description: "",
        url: i18n.DefaultSite.url,
        plan: "",
        isWooCommerceActive: true,
        isWordPressStore: true,
        timezone: "UTC",
        gmtOffset: 0
    )

    public let defaultSiteAPI = SiteAPI(siteID: 1, namespaces: [
        WooAPIVersion.mark3.rawValue,
        WooAPIVersion.mark4.rawValue,
    ])

    public var sites: [Site] {
        return [defaultSite]
    }

    public func accountWithId(id: Int64) -> Account {
        return defaultAccount
    }

    public func accountSettingsWithUserId(userId: Int64) -> AccountSettings {
        return .init(userID: userId, tracksOptOut: true)
    }

    public func siteWithId(id: Int64) -> Site {
        return defaultSite
    }

    public var orders: [Order] = [
        createOrder(
            number: 2201,
            customer: Customers.MiraWorkman,
            status: .processing,
            total: 1310.00,
            items: [
                orderItem(from: Products.malayaShades, count: 4),
                orderItem(from: Products.blackCoralShades, count: 5),
            ]
        ),
        createOrder(
            number: 2155,
            customer: Customers.LydiaDonin,
            status: .processing,
            daysOld: 3,
            total: 300
        ),
        createOrder(
            number: 2116,
            customer: Customers.ChanceVicarro,
            status: .processing,
            daysOld: 4,
            total: 300
        ),
        createOrder(
            number: 2104,
            customer: Customers.MarcusCurtis,
            status: .processing,
            daysOld: 5,
            total: 420
        ),
        createOrder(
            number: 2087,
            customer: Customers.MollyBloom,
            status: .processing,
            daysOld: 6,
            total: 46.96
        ),
    ]

    public var products: [Product] = [
        Products.roseGoldShades,
        Products.coloradoShades,
        Products.blackCoralShades,
        Products.akoyaPearlShades,
        Products.malayaShades,
    ]

    public var reviews: [ProductReview] = [
        createProductReview(
            product: Products.blackCoralShades,
            customer: Customers.LydiaDonin,
            status: .hold,
            text: "Travel in style!",
            rating: 5,
            verified: true
        ),
    ]
}

struct i18n {
    struct DefaultAccount {
        static let displayName = NSLocalizedString("My Account", comment: "displayName for the screenshot demo account")
        static let email = NSLocalizedString("woocommercestore@example.com", comment: "email address for the screenshot demo account")
        static let username = NSLocalizedString("test account", comment: "username for the screenshot demo account")
    }

    struct DefaultSite {
        static let name = NSLocalizedString("Your WooCommerce Store", comment: "Store Name for the screenshot demo account")
        static let url = NSLocalizedString("example.com", comment: "")
    }
}

extension ScreenshotObjects {

    struct Customers {
        static let MiraWorkman = MockCustomer(
            firstName: "Mira",
            lastName: "Workman",
            company: nil,
            address1: "123 Main Street",
            address2: nil,
            city: "San Francisco",
            state: "CA",
            postCode: "94119",
            country: "US",
            phone: nil,
            email: nil
        )

        static let LydiaDonin = MockCustomer(firstName: "Lydia", lastName: "Donin")
        static let ChanceVicarro = MockCustomer(firstName: "Chance", lastName: "Vacarro")
        static let MarcusCurtis = MockCustomer(firstName: "Marcus", lastName: "Curtis")
        static let MollyBloom = MockCustomer(firstName: "Molly", lastName: "Bloom")
    }

    struct Products {

        static let roseGoldShades = createProduct(
            name: "Rose Gold Shades",
            price: 199.0,
            quantity: 0
        )

        static let blackCoralShades = createProduct(
            name: "Black Coral Shades",
            price: 150.00,
            quantity: -24
        )

        static let malayaShades = createProduct(
            name: "Malaya Shades",
            price: 140.00,
            quantity: 17
        )

        static let coloradoShades = createProduct(
            name: "Colorado shades",
            price: 135,
            salePrice: 100,
            quantity: 98
        )

        static let akoyaPearlShades = createProduct(
            name: "Akoya Pearl shades",
            price: 110,
            quantity: 23
        )
    }
}

struct ProductId {
    static var currentId: Int64 = 0

    static var next: Int64 {
        currentId += 1
        return currentId
    }

    static var current: Int64 {
        currentId
    }
}
