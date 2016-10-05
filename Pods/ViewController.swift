


import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Realmインスタンスを取得する
    let realm = try! Realm()  // ←追加
    
    // DB内のタスクが格納されるリスト。
    // 日付近い順\順でソート：降順
    // 以降内容をアップデートするとリスト内は自動的に更新される。
    let taskArray = try! Realm().objects(Task).sorted("date", ascending: false)
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
            self.view.addGestureRecognizer(tapGesture)
            
            titleTextField.text = task.title
            contentsTextView.text = task.contents
            datePicker.date = task.date
    }
    
    override func viewWillDisappear(animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            self.realm.add(self.task, update: true)
        }
        
        super.viewWillDisappear(animated)
    }
    
    func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        // MARK: UITableViewDataSourceプロトコルのメソッド
        // データの数（＝セルの数）を返すメソッド
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return taskArray.count  // ←追加する
        }
        
        // 各セルの内容を返すメソッド
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            // 再利用可能な cell を得る
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            // Cellに値を設定する.
            let task = taskArray[indexPath.row]
            cell.textLabel?.text = task.title
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            let dateString:String = formatter.stringFromDate(task.date)
            cell.detailTextLabel?.text = dateString

            
            return cell
        }
        
        // MARK: UITableViewDelegateプロトコルのメソッド
        // 各セルを選択した時に実行されるメソッド
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            performSegueWithIdentifier("cellSegue",sender: nil)
        }
        
        // セルが削除が可能なことを伝えるメソッド
        func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCellEditingStyle {
            return UITableViewCellEditingStyle.Delete
        }
        
        // Delete ボタンが押された時に呼ばれるメソッド
        func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
            if editingStyle == UITableViewCellEditingStyle.Delete {
                // データベースから削除する  // ←以降追加する
                try! realm.write {
                    self.realm.delete(self.taskArray[indexPath.row])
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
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
    }
    
           override func viewWillAppear(animated: Bool) {
             super.viewWillAppear(animated)
             tableView.reloadData()
    }
}



























