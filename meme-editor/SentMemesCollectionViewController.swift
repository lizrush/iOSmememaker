//
//  CollectionViewContoller.swift
//  meme-editor
//
//  Created by liz on 13/4/17.
//  Copyright © 2017 liz. All rights reserved.
//

import UIKit

internal class SentMemesCollectionViewController : UICollectionViewController {
  var appDelegate: AppDelegate!
  var memes: [Meme]!

  @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

  override func viewDidLoad() {
    super.viewDidLoad()
    appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    setFlowLayout()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    memes = appDelegate.memesCollection
    collectionView?.reloadData()
  }


  func setFlowLayout() {
    let space: CGFloat = 2.0
    let dimension = (self.view.frame.size.width - (2 * space)) / 3.0

    flowLayout.minimumInteritemSpacing = space
    flowLayout.minimumLineSpacing = space
    flowLayout.itemSize = CGSize(width: dimension, height: dimension)
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return memes.count
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
    detailViewController.meme = memes[(indexPath as NSIndexPath).row]
    navigationController!.pushViewController(detailViewController, animated: true)
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
    let meme = self.memes[(indexPath as NSIndexPath).row]
    cell.memeImageView.image = meme.memedImage
    cell.memeImageView.contentMode = UIViewContentMode.scaleAspectFit

    return cell
  }
}
