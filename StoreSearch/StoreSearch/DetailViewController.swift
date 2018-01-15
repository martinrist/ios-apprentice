//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Martin Rist on 11/01/2018.
//  Copyright © 2018 Martin Rist. All rights reserved.
//

import UIKit
import Foundation

class DetailViewController: UIViewController {

    // MARK:- Internal structures

    enum AnimationStyle {
        case slide
        case fade
    }


    // MARK:- Instance variables

    var searchResult: SearchResult!
    var downloadTask: URLSessionDownloadTask?
    var dismissStyle = AnimationStyle.fade


    // MARK:- Outlets

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!


    // MARK:- View lifecycle

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    deinit {
        print("deinit \(self)")
        downloadTask?.cancel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = UIColor(red: 20/255, green: 160/255,
                                 blue: 160/255, alpha: 1)
        popupView.layer.cornerRadius = 10

        let gestureRecogniser = UITapGestureRecognizer(target: self,
                                                       action: #selector(close))
        gestureRecogniser.cancelsTouchesInView = false
        gestureRecogniser.delegate = self
        view.addGestureRecognizer(gestureRecogniser)

        if let _ = searchResult {
            updateUI()
        }

        view.backgroundColor = UIColor.clear
    }


    // MARK:- Actions
    @IBAction func close() {
        dismissStyle = .slide
        dismiss(animated: true, completion: nil)
    }

    @IBAction func openInStore() {
        if let url = URL(string: searchResult.storeURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }


    // MARK:- Helper methods
    func updateUI() {
        nameLabel.text = searchResult.name

        if searchResult.artistName.isEmpty {
            artistNameLabel.text = NSLocalizedString("Unknown", comment: "Unknown artist name")
        } else {
            artistNameLabel.text = searchResult.artistName
        }

        kindLabel.text = searchResult.type
        genreLabel.text = searchResult.genre

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = searchResult.currency

        let priceText: String
        if searchResult.price == 0 {
            priceText = NSLocalizedString("Free", comment: "Free price label")
        } else if let text = formatter.string(from: searchResult.price as NSNumber) {
            priceText = text
        } else {
            priceText = ""
        }

        priceButton.setTitle(priceText, for: .normal)

        if let largeURL = URL(string: searchResult.imageLarge) {
            downloadTask = artworkImageView.loadImage(url: largeURL)
        }
    }

}


// MARK:- UIViewControllerTransitioningDelegate extension

extension DetailViewController: UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController: presented,
                                             presenting: presenting)
    }

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BounceAnimationController()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch dismissStyle {
        case .slide:
            return SlideOutAnimationController()
        case .fade:
            return FadeOutAnimationController()
        }
    }
}


// MARK:- UIGestureRecognizerDelegate extension

extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}
