import Foundation

public struct MockOrdersRemote: OrdersRemoteProtocol {

    private let objectGraph: MockObjectGraph

    public init(objectGraph: MockObjectGraph) {
        self.objectGraph = objectGraph
    }

    public func loadAllOrders(for siteID: Int64,
                              statusKey: String? = nil,
                              before: Date? = nil,
                              pageNumber: Int,
                              pageSize: Int,
                              completion: @escaping (Result<[Order], Error>) -> Void) {
        completion(.success(objectGraph.orders(forSiteId: siteID)))
    }

    public func loadOrder(for siteID: Int64, orderID: Int64, completion: @escaping (Order?, Error?) -> Void) {
        completion(objectGraph.order(forSiteId: siteID, orderId: orderID), nil)
    }

    public func loadOrderNotes(for siteID: Int64, orderID: Int64, completion: @escaping ([OrderNote]?, Error?) -> Void) {
        completion([], nil)
    }

    public func searchOrders(for siteID: Int64,
                             keyword: String,
                             pageNumber: Int,
                             pageSize: Int,
                             completion: @escaping ([Order]?, Error?) -> Void) {
        preconditionFailure("Not implemented yet")
    }

    public func updateOrder(from siteID: Int64, orderID: Int64, statusKey: OrderStatusEnum, completion: @escaping (Order?, Error?) -> Void) {
        preconditionFailure("Not implemented yet")
    }

    public func addOrderNote(for siteID: Int64, orderID: Int64, isCustomerNote: Bool, with note: String, completion: @escaping (OrderNote?, Error?) -> Void) {
        preconditionFailure("Not implemented yet")
    }

    public func countOrders(for siteID: Int64, statusKey: String, completion: @escaping (OrderCount?, Error?) -> Void) {
        completion(OrderCount(siteID: siteID, items: [OrderCountItem(slug: statusKey, name: statusKey, total: objectGraph.orders.count)]), nil)
    }
}
