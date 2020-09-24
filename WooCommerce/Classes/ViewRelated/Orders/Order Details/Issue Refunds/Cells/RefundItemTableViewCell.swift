import UIKit

/// Displays an item to be refunded
///
final class RefundItemTableViewCell: UITableViewCell {

    /// Item image view: Product image
    ///
    @IBOutlet private var itemImageView: UIImageView!

    /// Placeholder image view: Needed to show a placeholder that has some insets from the `itemImageView`
    ///
    @IBOutlet private var placeholderImageView: UIImageView!

    /// Item title: Product name
    ///
    @IBOutlet private var itemTitle: UILabel!

    /// Item caption: Product quanity and price
    ///
    @IBOutlet private var itemCaption: UILabel!

    /// Quantity button: Quantity to be refunded
    ///
    @IBOutlet private var itemQuantityButton: UIButton!

    /// Needed to change it's axis with larger accessibility traits
    ///
    @IBOutlet private var itemsStackView: UIStackView!

    /// Needed to make sure the `itemImageView` grows at the same ratio as the dynamic fonts
    ///
    @IBOutlet private var itemImageViewHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        applyCellStyles()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        adjustItemsStackViewAxis()
        adjustItemImageViewHeight()
    }
}

// MARK: View Styles Configuration
private extension RefundItemTableViewCell {
    func applyCellStyles() {
        applyCellBackgroundStyle()
        applyItemImageStyles()
        applyLabelsStyles()
        //applyRefundQuantityButtonStyle()
        adjustItemsStackViewAxis()
    }

    func applyItemImageStyles() {
        itemImageView.layer.borderWidth = 0.5
        itemImageView.layer.borderColor = UIColor.border.cgColor
        adjustItemImageViewHeight()
    }

    func applyCellBackgroundStyle() {
        applyDefaultBackgroundStyle()
    }

    func applyLabelsStyles() {
        itemTitle.applyBodyStyle()
        itemCaption.applyFootnoteStyle()
    }

    func applyRefundQuantityButtonStyle() {
        itemQuantityButton.applySecondaryButtonStyle()
        itemQuantityButton.titleLabel?.applyBodyStyle()
    }

    /// Changes the items stack view axis depending on the view `preferredContentSizeCategory`.
    ///
    func adjustItemsStackViewAxis() {
        itemsStackView.axis = traitCollection.preferredContentSizeCategory > .accessibilityMedium ? .vertical : .horizontal
    }

    /// Changes the items image view height acording to the current trait collection
    ///
    func adjustItemImageViewHeight() {
        itemImageViewHeightConstraint.constant = UIFontMetrics.default.scaledValue(for: 39, compatibleWith: traitCollection)
    }
}

// MARK: ViewModel Rendering
extension RefundItemTableViewCell {

    /// Configure cell with the provided view model
    ///
    func configure(with viewModel: RefundItemViewModel) {
        itemTitle.text = viewModel.productTitle
        itemCaption.text = viewModel.productQuantityAndPrice
        itemQuantityButton.setTitle(viewModel.quantityToRefund, for: .normal)
        applyRefundQuantityButtonStyle()

        if let _ = viewModel.productImage {
            // TODO: fill product image
            placeholderImageView.image = nil
        } else {
            itemImageView.image = nil
            placeholderImageView.image = .productPlaceholderImage
        }
    }
}

// MARK: Actions
private extension RefundItemTableViewCell {
    @IBAction func quantityButtonPressed(_ sender: Any) {
        print("Item quantity button pressed")
    }
}

// MARK: - Previews
#if canImport(SwiftUI) && DEBUG

import SwiftUI

private struct RefundItemTableViewCellRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let nib = UINib(nibName: "RefundItemTableViewCell", bundle: nil)
        guard let cell = nib.instantiate(withOwner: self, options: nil).first as? RefundItemTableViewCell else {
            fatalError("Could not create RefundItemTableViewCell")
        }

        let viewModel = RefundItemViewModel(productImage: nil,
                                            productTitle: "Hoddie - Big",
                                            productQuantityAndPrice: "2 x $29.99 each",
                                            quantityToRefund: "1")
        cell.configure(with: viewModel)
        return cell
    }

    func updateUIView(_ view: UIView, context: Context) {
        // no op
    }
}

@available(iOS 13.0, *)
struct RefundItemTableViewCell_Previews: PreviewProvider {

    private static func makeStack() -> some View {
        VStack {
            RefundItemTableViewCellRepresentable()
        }
    }

    static var previews: some View {
        Group {
            makeStack()
                .previewLayout(.fixed(width: 359, height: 76))
                .previewDisplayName("Light")

            makeStack()
                .previewLayout(.fixed(width: 359, height: 76))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark")

            makeStack()
                .previewLayout(.fixed(width: 359, height: 96))
                .environment(\.sizeCategory, .accessibilityMedium)
                .previewDisplayName("Large Font")

            makeStack()
                .previewLayout(.fixed(width: 359, height: 420))
                .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
                .previewDisplayName("Extra Large Font")
        }
    }
}

#endif
