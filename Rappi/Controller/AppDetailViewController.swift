//
//  AppDetailViewController.swift
//  Rappi
//
//  Created by Johan Vallejo on 17/02/17.
//  Copyright © 2017 kijho. All rights reserved.
//

import UIKit
import Kingfisher

class AppDetailViewController: UIViewController {
    
    @IBOutlet weak var imageApp: UIImageView!
    @IBOutlet weak var nameApp: UILabel!
    @IBOutlet weak var categoryApp: UILabel!
    @IBOutlet weak var artistApp: UILabel!
    @IBOutlet weak var priceApp: UILabel!
    @IBOutlet weak var descriptionApp: UITextView!
    
    var app : App?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.app?.name

        configureInformation()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.descriptionApp.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    func configureInformation() {

        if let imageData = app?.image {
            self.imageApp.kf.setImage(with: ImageResource(downloadURL: URL(string: imageData)!), placeholder: #imageLiteral(resourceName: "ic_category"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        self.nameApp.text = app?.name
        self.categoryApp.text = app?.categoryId
        self.artistApp.text = app?.artist
        self.priceApp.text = app?.price
        self.descriptionApp.text = app?.summary
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
