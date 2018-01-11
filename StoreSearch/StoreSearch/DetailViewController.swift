//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Martin Rist on 11/01/2018.
//  Copyright © 2018 Martin Rist. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK:- Outlets

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var artworkImageView: UIView!
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
    }


    // MARK:- Actions
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
}


extension DetailViewController: UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController: presented,
                                             presenting: presenting)
    }
}


extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}
