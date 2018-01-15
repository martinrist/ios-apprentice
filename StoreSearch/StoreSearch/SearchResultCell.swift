//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Martin Rist on 02/01/2018.
//  Copyright © 2018 Martin Rist. All rights reserved.
//

import Foundation
import UIKit

class SearchResultCell: UITableViewCell {


    // MARK:- Instance variables
    var downloadTask: URLSessionDownloadTask?

    // MARK:- Outlets

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255,
                                               blue: 160/255, alpha: 0.5)
        selectedBackgroundView = selectedView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


    // MARK:- Public Methods

    func configure(for result: SearchResult) {
        nameLabel.text = result.name

        if result.artistName.isEmpty {
            artistNameLabel.text = NSLocalizedString("Unknown", comment: "Unknown artist name")
        } else {
            artistNameLabel.text = String(format: "%@ (%@)",
                                    result.artistName, result.type)
        }

        artworkImageView.image = UIImage(named: "Placeholder")
        if let smallURL = URL(string: result.imageSmall) {
            downloadTask = artworkImageView.loadImage(url: smallURL)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
    }
}
