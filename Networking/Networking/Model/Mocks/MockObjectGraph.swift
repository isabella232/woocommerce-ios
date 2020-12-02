import Foundation

public protocol MockObjectGraph {

    var userCredentials: Credentials { get }
    var defaultAccount: Account { get }
    var defaultSite: Site { get }
    var defaultSiteAPI: SiteAPI { get }

    var sites: [Site] { get }
    var orders: [Order] { get }
    var products: [Product] { get }

    func accountWithId(id: Int64) -> Account
    func accountSettingsWithUserId(userId: Int64) -> AccountSettings

    func siteWithId(id: Int64) -> Site
}

struct MockCustomer {
    let firstName: String
    let lastName: String
    let company: String?
    let address1: String
    let address2: String?
    let city: String
    let state: String
    let postCode: String
    let country: String
    let phone: String?
    let email: String?

    init(
        firstName: String,
         lastName: String,
        company: String? = nil,
        address1: String = "",
        address2: String? = nil,
        city: String = "",
        state: String = "",
        postCode: String = "",
        country: String = "",
        phone: String? = nil,
        email: String? = nil
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.company = company
        self.address1 = address1
        self.address2 = address2
        self.city = city
        self.state = state
        self.postCode = postCode
        self.country = country
        self.phone = phone
        self.email = email
    }

    var billingAddress: Address {
        .init(
            firstName: firstName,
            lastName: lastName,
            company: company,
            address1: address1,
            address2: address2,
            city: city,
            state: state,
            postcode: postCode,
            country: country,
            phone: phone,
            email: email
        )
    }

    var shippingAddress: Address {
        return billingAddress
    }
}

// MARK: Product Accessors
extension MockObjectGraph {

    func product(forSiteId siteId: Int64, productId: Int64) -> Product {
        return products(forSiteId: siteId).first { $0.productID == productId }!
    }

    func products(forSiteId siteId: Int64) -> [Product] {
        return products.filter { $0.siteID == siteId }
    }

    func products(forSiteId siteId: Int64, productIds: [Int64]) -> [Product] {
        return products(forSiteId: siteId).filter { productIds.contains($0.productID) }
    }
}

// MARK: Order Accessors
extension MockObjectGraph {

    func order(forSiteId siteId: Int64, orderId: Int64) -> Order? {
        return orders(forSiteId: siteId).first { $0.orderID == orderId }
    }

    func orders(forSiteId siteId: Int64) -> [Order] {
        return orders.filter { $0.siteID == siteId }
    }
}

// MARK: Product => OrderItem Transformer
let priceFormatter = NumberFormatter()

extension MockObjectGraph {

    static func orderItem(from product: Product, count: Decimal) -> OrderItem {

        let price = priceFormatter.number(from: product.price)!.decimalValue as NSDecimalNumber
        let total = priceFormatter.number(from: product.price)!.decimalValue * count

        return OrderItem(
            itemID: 0,
            name: product.name,
            productID: product.productID,
            variationID: 0,
            quantity: count,
            price: price,
            sku: nil,
            subtotal: "\(total)",
            subtotalTax: "",
            taxClass: "",
            taxes: [],
            total: "\(total)",
            totalTax: "0",
            attributes: []
        )
    }
}

fileprivate let baseResourceUrl = "http://localhost:9285/"

// MARK: Product Creation Helper
extension MockObjectGraph {

    static func createProduct(
        name: String,
        price: Decimal,
        salePrice: Decimal? = nil,
        quantity: Int64,
        siteId: Int64 = 1,
        image: ProductImage? = nil
    ) -> Product {

        let productId = ProductId.next

        let defaultImage = ProductImage(
            imageID: productId,
            dateCreated: Date(),
            dateModified: nil,
            src: baseResourceUrl + name.slugified!,
            name: name,
            alt: name
        )

        return Product(
            siteID: siteId,
            productID: productId,
            name: name,
            slug: name.slugified!,
            permalink: "",
            date: Date(),
            dateCreated: Date(),
            dateModified: nil,
            dateOnSaleStart: nil,
            dateOnSaleEnd: nil,
            productTypeKey: "",
            statusKey: "",
            featured: true,
            catalogVisibilityKey: "",
            fullDescription: nil,
            shortDescription: nil,
            sku: nil,
            price: priceFormatter.string(from: price as NSNumber)!,
            regularPrice: nil,
            salePrice: salePrice == nil ? nil : priceFormatter.string(from: salePrice! as NSNumber)!,
            onSale: salePrice != nil,
            purchasable: true,
            totalSales: 99,
            virtual: false,
            downloadable: false,
            downloads: [],
            downloadLimit: 0,
            downloadExpiry: 0,
            buttonText: "Buy",
            externalURL: nil,
            taxStatusKey: "foo",
            taxClass: nil,
            manageStock: true,
            stockQuantity: quantity,
            stockStatusKey: ProductStockStatus.from(quantity: quantity).rawValue,
            backordersKey: "",
            backordersAllowed: true,
            backordered: quantity < 0,
            soldIndividually: true,
            weight: "20 grams",
            dimensions: .init(length: "10", width: "10", height: "10"),
            shippingRequired: true,
            shippingTaxable: true,
            shippingClass: "",
            shippingClassID: 0,
            productShippingClass: .none,
            reviewsAllowed: true,
            averageRating: "5",
            ratingCount: 64,
            relatedIDs: [],
            upsellIDs: [],
            crossSellIDs: [],
            parentID: 0,
            purchaseNote: nil,
            categories: [],
            tags: [],
            images: image != nil ? [image!] : [defaultImage],
            attributes: [],
            defaultAttributes: [],
            variations: [],
            groupedProducts: [],
            menuOrder: 0
        )
    }
}

// MARK: Order Creation Helper
extension MockObjectGraph {
    static func createOrder(
        number: Int64,
        customer: MockCustomer,
        status: OrderStatusEnum,
        daysOld: Int = 0,
        total: Decimal,
        items: [OrderItem] = []
    ) -> Order {

        Order(
            siteID: 1,
            orderID: number,
            parentID: 0,
            customerID: 1,
            number: "\(number)",
            status: status,
            currency: "USD",
            customerNote: nil,
            dateCreated: Calendar.current.date(byAdding: .day, value: daysOld * -1, to: Date()) ?? Date(),
            dateModified: Date(),
            datePaid: nil,
            discountTotal: "0",
            discountTax: "0",
            shippingTotal: "0",
            shippingTax: "0",
            total: priceFormatter.string(from: total as NSNumber)!,
            totalTax: "0",
            paymentMethodID: "0",
            paymentMethodTitle: "MasterCard",
            items: items,
            billingAddress: customer.billingAddress,
            shippingAddress: customer.billingAddress,
            shippingLines: [],
            coupons: [],
            refunds: []
        )
    }
}
