//
//  ProductListViewControllerTableViewController.swift
//  Online Flagship Store
//
//  Created by Amerigo Mancino on 27/01/21.
//

import UIKit

class ProductCell: UITableViewCell {
    @IBOutlet weak var prodThumbnail: UIImageView!
    @IBOutlet weak var prodDescription: UILabel!
}

class ProductListViewControllerTableViewController: UITableViewController {
    
    var productList = [Product]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        self.tableView.separatorStyle = .none

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell

        // configure the cell
        cell.prodDescription.text = self.productList[indexPath.row].title + "\n" + self.productList[indexPath.row].price + " € "
        cell.prodDescription.numberOfLines = 0
        cell.prodThumbnail.imageFromServerURL(urlString: self.productList[indexPath.row].thumbnailUrl, placeholderImage: UIImage(named: "Loading")!)

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
