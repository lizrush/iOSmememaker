//
//  DetailViewController.swift
//  meme-editor
//
//  Created by liz on 14/4/17.
//  Copyright © 2017 liz. All rights reserved.
//

import UIKit

internal class DetailViewController : UIViewController {
  @IBOutlet weak var detailImageView: UIImageView!

  var meme: Meme!

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = true
    detailImageView.contentMode = .scaleAspectFit
    detailImageView.image = meme.memedImage
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.tabBarController?.tabBar.isHidden = false
  }
}
