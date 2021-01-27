//
//  ViewController.swift
//  Online Flagship Store
//
//  Created by Amerigo Mancino on 27/01/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var readyToWear: UIButton!
    @IBOutlet weak var accessories: UIButton!
    @IBOutlet weak var lingerie: UIButton!
    @IBOutlet weak var beauty: UIButton!
    
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
        print("item")
        print(sender.tag)
    }
}

