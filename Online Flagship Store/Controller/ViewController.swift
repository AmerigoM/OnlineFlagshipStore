//
//  ViewController.swift
//  Online Flagship Store
//
//  Created by Amerigo Mancino on 27/01/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    // outlets
    @IBOutlet weak var readyToWear: UIButton!
    @IBOutlet weak var accessories: UIButton!
    @IBOutlet weak var lingerie: UIButton!
    @IBOutlet weak var beauty: UIButton!
    
    private var productList = [Product]()
    
    // constants
    let READY_TO_WEAR_URL = "http://api.yoox.biz/Search.API/1.3/SMC_IT/search/results.json?ave=prod&productsPerPage=50&gender=D&page=1&department=Main_Ready_To_Wear&format=lite&sortRule=Ranking"
    let ACCESSORIES_URL = "http://api.yoox.biz/Search.API/1.3/SMC_IT/search/results.json?ave=prod&productsPerPage=50&gender=D&page=1&department=Main_Accessories_All&format=lite&sortRule=Ranking"
    let LINGERIE_URL = "http://api.yoox.biz/Search.API/1.3/SMC_IT/search/results.json?ave=prod&productsPerPage=50&page=1&department=Main_Lingerie&format=lite&sortRule=Ranking"
    let BEAUTY_URL = "http://api.yoox.biz/Search.API/1.3/SMC_IT/search/results.json?ave=prod&productsPerPage=50&gender=D&page=1&department=Main_Beauty&format=lite&sortRule=Ranking"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readyToWear.imageView?.contentMode = .scaleAspectFill
        readyToWear.imageView?.layer.cornerRadius = 5
        accessories.imageView?.contentMode = .scaleAspectFill
        accessories.imageView?.layer.cornerRadius = 5
        lingerie.imageView?.contentMode = .scaleAspectFill
        lingerie.imageView?.layer.cornerRadius = 5
        beauty.imageView?.contentMode = .scaleAspectFill
        beauty.imageView?.layer.cornerRadius = 5
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            getProductList(url: READY_TO_WEAR_URL)
            break
        case 1:
            getProductList(url: ACCESSORIES_URL)
            break
        case 2:
            getProductList(url: LINGERIE_URL)
            break
        case 3:
            getProductList(url: BEAUTY_URL)
            break
        default:
            self.displayAlert(title: "Unknown tag", message: "Please contact the app support.")
        }
    }
    
    // MARK: - Networking
    
    func getProductList(url: String) {
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                let resultJSON: JSON = JSON(response.result.value!)
                let productJSON = resultJSON["ResultsLite"]["Items"]
                let jsonArray = productJSON.array!
                
                for item in jsonArray {
                    let product = Product()
                    product.title = item["ModelNames"].stringValue
                    product.category = item["MicroCategory"].stringValue
                    product.price = item["FullPrice"].stringValue
                    product.thumbnailUrl = self.calculateThumbnailUrl(item["DefaultCode10"].stringValue)
                    self.productList.append(product)
                }
            } else {
                self.displayAlert(title: "Request failure", message: "Please contact the app support.")
            }
        }
    }
    
    // MARK: - Support functions
    
    func calculateThumbnailUrl(_ defaultCode10: String) -> String {
        var urlToReturn = "https://www.stellamccartney.com/"
        
        let folderIdentifier = String(defaultCode10.prefix(2))
        urlToReturn.append(folderIdentifier)
        urlToReturn.append("/")
        urlToReturn.append(defaultCode10)
        urlToReturn.append("_12_c.jpg")
        
        return urlToReturn
    }
    
    func displayAlert(title: String, message: String) {
        // Create new alert
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create OK button without action handler
        let ok = UIAlertAction(title: "OK", style: .default)
        
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}

