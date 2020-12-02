import Foundation

public struct MockProductReviewsRemote: ProductReviewsRemoteProtocol {

    private let objectGraph: MockObjectGraph

    public init(objectGraph: MockObjectGraph) {
        self.objectGraph = objectGraph
    }

    public func loadAllProductReviews(for siteID: Int64,
                                context: String? = nil,
                                pageNumber: Int,
                                pageSize: Int,
                                products: [Int64]? = nil,
                                status: ProductReviewStatus? = nil,
                                completion: @escaping ([ProductReview]?, Error?) -> Void) {
        completion(objectGraph.reviews(forSiteId: siteID), nil)
    }

    public func loadProductReview(for siteID: Int64, reviewID: Int64, completion: @escaping (Result<ProductReview, Error>) -> Void) {
        completion(.success(objectGraph.review(forSiteId: siteID, reviewId: reviewID)!))
    }

    public func updateProductReviewStatus(for siteID: Int64, reviewID: Int64, statusKey: String, completion: @escaping (ProductReview?, Error?) -> Void) {
        preconditionFailure("Not implemented yet")
    }
}
