//
//  CategoryListCollectionViewController.swift
//  Rappi
//
//  Created by Johan Vallejo on 17/02/17.
//  Copyright © 2017 kijho. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CategoryCell"

class CategoryListCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var categories : [CategoryApp] = [CategoryApp]()
    var collectionViewPadding : CGFloat = 0
    let refresh = UIRefreshControl()
    let dataProvider = LocalServices()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setCollectionViewPadding()
        self.loadData()
        refresh.addTarget(self, action: #selector(self.loadData), for: UIControlEvents.valueChanged)
        collectionView?.refreshControl?.tintColor = UIColor.white
        collectionView?.refreshControl = refresh

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "Apps" {
            let apsVC = segue.destination as! AppListCollectionViewController
            let selectedIndex = collectionView?.indexPathsForSelectedItems?.first?.row
            let category = categories[selectedIndex!]
            apsVC.category = category.id
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
    
        // Configure the cell
        let category = self.categories[indexPath.row]
        cell.nameCategory.text = category.name

        return cell
    }
    
    func setCollectionViewPadding() {
        let screenWidth = self.view.frame.width
        if screenWidth >= 600 {
            collectionViewPadding = (screenWidth - (4 * 200)) / 5
        } else {
            collectionViewPadding = (screenWidth - 25)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionViewPadding, height: 80)
    }

    func loadData() {
        dataProvider.getCategories(localHandler: { (categories) in
            if let categories = categories {
                self.categories = categories
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            } else {
                print("No hay registros en CoreData")
            }
        }, remoteHandler: { (categories) in
            if let categories = categories {
                self.categories = categories
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    self.refresh.endRefreshing()
                }
            } else {
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Trabajar sin Conexion", message: "No se tiene conexion a internet", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: {
                    self.refresh.endRefreshing()
                    })
                }
            }
        })
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
