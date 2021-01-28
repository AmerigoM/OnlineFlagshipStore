//
//  ProductListViewControllerTableViewController.swift
//  Online Flagship Store
//
//  Created by Amerigo Mancino on 27/01/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProductCell: UITableViewCell {
    @IBOutlet weak var prodThumbnail: UIImageView!
    @IBOutlet weak var prodDescription: UILabel!
}

class ProductListViewControllerTableViewController: UITableViewController {
    
    var productList = [Product]()
    var chosenIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        self.tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.restore()
        return self.productList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // enable dark mode when active
        self.overrideUserInterfaceStyle = .unspecified

        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell

        // configure the cell
        cell.prodDescription.text = self.productList[indexPath.row].title + "\n" + self.productList[indexPath.row].price + " € "
        cell.prodDescription.numberOfLines = 0
        cell.prodThumbnail.imageFromServerURL(urlString: self.productList[indexPath.row].thumbnailUrl, placeholderImage: UIImage(named: "Loading")!)

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetails" {
            let destinationVC = segue.destination as! ProductDetailsViewController
            destinationVC.productDetail = self.productList[chosenIndex]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let url = "http://api.yoox.biz/Item.API/1.0/SMC_IT/item/" + self.productList[indexPath.row].code + ".json"
        
        // show spinner
        let spinner = SpinnerViewController()
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
        
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                let resultJSON: JSON = JSON(response.result.value!)
                
                let descriptionJSON = resultJSON["Item"]["Descriptions"]
                let descriptionArray = descriptionJSON.array!
                
                for item in descriptionArray {
                    if item["Key"] == "Composition" {
                        self.productList[indexPath.row].composition = item["Value"].stringValue
                    } else {
                        if item["Key"] == "Details" {
                            self.productList[indexPath.row].details = item["Value"].stringValue
                        }
                    }
                }
                
                self.productList[indexPath.row].madeIn = resultJSON["Item"]["MadeIn"].stringValue
                
                self.chosenIndex = indexPath.row
                
                self.performSegue(withIdentifier: "segueToDetails", sender: self)
            } else {
                let dialogMessage = UIAlertController(title: "Request Failure", message: "Please check your internet connection or contact the app support.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default)
                dialogMessage.addAction(ok)
                self.present(dialogMessage, animated: true, completion: nil)
            }
            
            // dismiss spinner
            spinner.willMove(toParent: nil)
            spinner.view.removeFromSuperview()
            spinner.removeFromParent()
        }
    }
}

// MARK: - Extensions

extension UIImageView {

    public func imageFromServerURL(urlString: String, placeholderImage: UIImage) {
        
        if self.image == nil {
              self.image = placeholderImage
        }

        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error ?? "No Error")
                return
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })

        }).resume()
    }
}

extension UITableView {
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
    
}
