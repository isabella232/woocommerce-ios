import Yosemite

/// Provides data needed for shipping settings.
///
protocol ProductShippingSettingsViewModelOutput {
    typealias Section = ProductShippingSettingsViewController.Section

    /// Table view sections.
    var sections: [Section] { get }

    /// The product before any shipping changes.
    var product: ProductFormDataModel { get }

    var weight: String? { get }
    var length: String? { get }
    var width: String? { get }
    var height: String? { get }

    /// Only for UI display and list selector
    /// Nil and not editable until the shipping class is synced at a later point.
    var shippingClass: ProductShippingClass? { get }
}

/// Handles actions related to the shipping settings data.
///
protocol ProductShippingSettingsActionHandler {
    // Input field actions
    func handleWeightChange(_ weight: String?)
    func handleLengthChange(_ length: String?)
    func handleWidthChange(_ width: String?)
    func handleHeightChange(_ height: String?)
    func handleShippingClassChange(_ shippingClass: ProductShippingClass?)

    /// If the product has a shipping class (slug & ID), the shipping class is synced to get the name and for list selector.
    func onShippingClassRetrieved(shippingClass: ProductShippingClass)

    // Navigation actions
    func completeUpdating(onCompletion: ProductShippingSettingsViewController.Completion)
    func hasUnsavedChanges() -> Bool
}

/// Provides view data for shipping settings, and handles init/UI/navigation actions needed in product shipping settings.
///
final class ProductShippingSettingsViewModel: ProductShippingSettingsViewModelOutput {
    let sections: [Section]
    let product: ProductFormDataModel

    // Editable data
    //
    private(set) var weight: String?
    private(set) var length: String?
    private(set) var width: String?
    private(set) var height: String?
    private var shippingClassSlug: String?
    private var shippingClassID: Int64

    /// Nil and not editable until the shipping class is synced at a later point.
    private(set) var shippingClass: ProductShippingClass?
    private var originalShippingClass: ProductShippingClass?

    init(product: ProductFormDataModel) {
        self.product = product
        weight = product.weight
        length = product.dimensions.length
        width = product.dimensions.width
        height = product.dimensions.height
        shippingClassSlug = product.shippingClass
        shippingClassID = product.shippingClassID

        // TODO-2580: re-enable shipping class for `ProductVariation` when the API issue is fixed.
        switch product {
        case is EditableProductModel:
            sections = [
                Section(rows: [.weight, .length, .width, .height]),
                Section(rows: [.shippingClass])
            ]
        case is EditableProductVariationModel:
            sections = [
                Section(rows: [.weight, .length, .width, .height])
            ]
        default:
            fatalError("Unsupported product type: \(product)")
        }
    }
}

extension ProductShippingSettingsViewModel: ProductShippingSettingsActionHandler {
    func handleWeightChange(_ weight: String?) {
        self.weight = weight
    }

    func handleLengthChange(_ length: String?) {
        self.length = length
    }

    func handleWidthChange(_ width: String?) {
        self.width = width
    }

    func handleHeightChange(_ height: String?) {
        self.height = height
    }

    func handleShippingClassChange(_ shippingClass: ProductShippingClass?) {
        self.shippingClass = shippingClass
        self.shippingClassSlug = shippingClass?.slug
        self.shippingClassID = shippingClass?.shippingClassID ?? 0
    }

    func onShippingClassRetrieved(shippingClass: ProductShippingClass) {
        self.shippingClass = shippingClass
        originalShippingClass = shippingClass
    }

    func completeUpdating(onCompletion: ProductShippingSettingsViewController.Completion) {
        let dimensions = ProductDimensions(length: length ?? "",
                                           width: width ?? "",
                                           height: height ?? "")
        onCompletion(weight,
                     dimensions,
                     shippingClassSlug,
                     shippingClassID,
                     hasUnsavedChanges())
    }

    func hasUnsavedChanges() -> Bool {
        weight != product.weight
            || length != product.dimensions.length
            || width != product.dimensions.width
            || height != product.dimensions.height
            || shippingClass != originalShippingClass
    }
}
