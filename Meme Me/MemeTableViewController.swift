//
//  MemeTableViewController.swift
//  Meme Me
//
//  Created by Ra Ra Ra on 4/11/15.
//  Copyright (c) 2015 Russell Austin. All rights reserved.
//

import UIKit

/// Shows the memes in a table view
class MemeTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    /// The index of the selected Meme
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        // set the Edit/Done button to the nav bar left button
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Display editor automatically if no memes
        if Meme.countAll() == 0 {
            performSegueWithIdentifier("showEditor", sender: self)
        }
        // disable the button if there are no memes (after a delete)
        navigationItem.leftBarButtonItem?.enabled = Meme.countAll() > 0
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // only supports delete
        switch editingStyle {
        case .Delete:
            Meme.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        default:
            return
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Meme.countAll()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCellWithIdentifier("memeTableCell") as! MemeTableCell
        if let meme = Meme.getAtIndex(indexPath.row) {
            cell.memeImageView.image = meme.memedImage
            cell.memeLabel.text = "\(meme.top) \(meme.bottom)"
        }
        return cell
    }
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        // toggles the bar button item between Edit and Done
        tableView.setEditing(editing, animated: animated)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !tableView.editing {
            selectedIndex = indexPath.row
            performSegueWithIdentifier("showDetail", sender: self)
        }
    }
    
    @IBAction func didPressAdd(sender: AnyObject) {
        performSegueWithIdentifier("showEditor", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            var destination = segue.destinationViewController as! DetailViewController
            if let meme = Meme.getAtIndex(selectedIndex!) {
                destination.meme = meme
            }
        }
    }
}