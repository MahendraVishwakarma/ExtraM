//
//  HomeViewController.swift
//  Mahendra
//
//  Created by Mahendra Vishwakarma on 24/08/20.
//  Copyright © 2020 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var searchController: UISearchController?
    @IBOutlet weak var homeCollectionView: UICollectionView!
    var defaultLayout: CellLayout = .three
    var viewModel: HomeViewModel?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    private func setupUI() {
        homeCollectionView.register(UINib(nibName: String(describing: HomePhotoCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: HomePhotoCell.self))
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        
        viewModel = HomeViewModel()
        viewModel?.delegate = self
        
        let page_number = viewModel?.photos?.photos != nil ? (viewModel?.photos?.photos.page ?? 0)  + 1 : 1
        let url = String(format: URLs.photos, page_number)
        
        activityIndicator.startAnimating()
        viewModel?.fetchData(url: url)
        
        // searchBar initialization
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchBar.placeholder = "search photo"
        
        //searchController?.searchBar.delegate = self
        self.definesPresentationContext = true
        searchController?.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
    } 
    
    @IBAction private func menuTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Layouts", message: "you can choose following layout format", preferredStyle: .actionSheet)
        
        let actionTwo = UIAlertAction(title: "🏞 🏞", style: .default) {[weak self] (alt) in
            self?.defaultLayout = .two
            self?.homeCollectionView.reloadData()
        }
        
        let actionThree = UIAlertAction(title: "🏞 🏞 🏞", style: .default) {[weak self] (alt) in
            self?.defaultLayout = .three
            self?.homeCollectionView.reloadData()
        }
        
        let actionFour = UIAlertAction(title: "🏞 🏞 🏞 🏞", style: .default) {[weak self] (alt) in
            self?.defaultLayout = .four
            self?.homeCollectionView.reloadData()
        }
        
        let actinCancel = UIAlertAction(title: "Cancel", style: .cancel) { (alt) in
            
        }
        
        alert.addAction(actionTwo)
        alert.addAction(actionThree)
        alert.addAction(actionFour)
        alert.addAction(actinCancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}


extension HomeViewController: FetchDataProtocols {
   
    func updateView() {
        DispatchQueue.main.async {
            self.homeCollectionView.reloadData()
            self.activityIndicator.stopAnimating()
        }
        
    }
}
