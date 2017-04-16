//
//  SentMemesTableViewController.swift
//  meme-editor
//
//  Created by liz on 14/4/17.
//  Copyright © 2017 liz. All rights reserved.
//

import UIKit

internal class SentMemesTableViewController : UITableViewController {

  var appDelegate: AppDelegate!
  var memes: [Meme]!
  var deleteMemeIndexPath: NSIndexPath? = nil
  var memeToDelete: Meme!

  override func viewDidLoad() {
    super.viewDidLoad()
    appDelegate = (UIApplication.shared.delegate as! AppDelegate)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    memes = appDelegate.memesCollection
    tableView?.reloadData()
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return memes.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let meme = self.memes[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCollectionTableViewCell", for: indexPath) as! MemeCollectionTableViewCell
    cell.title.text = meme.topTextField
    cell.imageView?.image = meme.memedImage

    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
    detailViewController.meme = memes[(indexPath as NSIndexPath).row]
    navigationController!.pushViewController(detailViewController, animated: true)

  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      memeToDelete = self.memes[indexPath.row]
      deleteMemeIndexPath = indexPath as NSIndexPath
      confirmDelete()
    }
  }

  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == UITableViewCellEditingStyle.delete {

      tableView.reloadData()
    }
  }

  func confirmDelete() {
    let alert = UIAlertController(title: "Delete Meme", message: "Are you sure you want to permanently delete this meme?", preferredStyle: .actionSheet)

    let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteMeme)
    let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteMeme)

    alert.addAction(DeleteAction)
    alert.addAction(CancelAction)

    self.present(alert, animated: true, completion: nil)
  }

  func handleDeleteMeme(alertAction: UIAlertAction!) -> Void {
    if let indexPath = deleteMemeIndexPath {
      tableView.beginUpdates()
      memes.remove(at: indexPath.row)

      // Remove memes from shared memeCollection
      if let i = appDelegate.memesCollection.index(where: { $0.memedImage == memeToDelete.memedImage }) {
        appDelegate.memesCollection.remove(at: i)
      }

      tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
      deleteMemeIndexPath = nil

      tableView.endUpdates()
    }
  }

  func cancelDeleteMeme(alertAction: UIAlertAction!) {
    deleteMemeIndexPath = nil
  }
}

// Extension added to convert a CGRectMake since Swift doesn't like that
extension CGRect {
  init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
    self.init(x:x, y:y, width:w, height:h)
  }
}
