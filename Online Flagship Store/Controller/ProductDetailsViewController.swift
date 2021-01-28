//
//  ProductDetailsViewController.swift
//  Online Flagship Store
//
//  Created by Amerigo Mancino on 27/01/21.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var madeInLabel: UILabel!
    var productDetail = Product()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = productDetail.title
        self.priceLabel.text = productDetail.price + " €"
        self.madeInLabel.text = productDetail.madeIn
        
        let customDescription = productDetail.details.replacingOccurrences(of: "<br>", with: "\n")
        self.descriptionTextField.text = customDescription
        self.descriptionTextField.isEditable = false
        self.descriptionTextField.isSelectable = false
        
        self.imageLabel.imageFromServerURL(urlString: productDetail.thumbnailUrl, placeholderImage: UIImage(named: "Loading")!)
    }


}
