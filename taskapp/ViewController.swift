


import UIKit
import RealmSwift


class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    //追加
    @IBOutlet weak var search: UISearchBar!
    
    let realm = try! Realm()
    //各ユーザーのタスクデータがある
    //データの一覧を取得するにはRealmクラスのobjects:メソッドでクラスを指定
    let taskArray = try! Realm().objects(Task).sorted("date", ascending: false)
        
        override func viewDidLoad() {
            super.viewDidLoad()
        }
    
        override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
               func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
             return taskArray.count
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            let task = taskArray[indexPath.row]
            cell.textLabel?.text = task.title
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            let dateString:String = formatter.stringFromDate(task.date)
            cell.detailTextLabel?.text = dateString
            
            return cell
        }
        
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            performSegueWithIdentifier("cellSegue",sender: nil)
        }
        
    
        func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCellEditingStyle {
            return UITableViewCellEditingStyle.Delete
        }
        
       
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {if editingStyle == UITableViewCellEditingStyle.Delete {
        let task = taskArray[indexPath.row]
        
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            if notification.userInfo!["id"] as! Int == task.id {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                break
            }
        }

        try! realm.write {
            self.realm.delete(self.taskArray[indexPath.row])
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
          }
      }
  }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        let inputViewController:InputViewController = segue.destinationViewController as! InputViewController
        
        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
        } else {
            let task = Task()
            task.date = NSDate()
            
            if taskArray.count != 0 {
                task.id = taskArray.max("id")! + 1
            }
            
            inputViewController.task = task
        }
    }
    
    //課題
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        search.endEditing(true)
        
        var taskcategory = realm.objects(Task).filter("")
        
        if(search.text != "") {
            let predicate = NSPredicate(format: "category = %@", search.text!)
            taskcategory = realm.objects(Task).filter(predicate)
        }
        
        do {
            
        } catch {
            print(error)
        }
        
       
        tableView.reloadData()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}

