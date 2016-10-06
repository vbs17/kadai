
import UIKit
import RealmSwift

class InputViewController: UIViewController {

    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var contentsText: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    //追加
    @IBOutlet weak var category: UITextField!
    
    let realm = try! Realm()
    var task:Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleText.text = task.title
        contentsText.text = task.contents
        datePicker.date = task.date
        category.text = task.category
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        try! realm.write {
            self.task.title = self.titleText.text!
            self.task.contents = self.contentsText.text
            self.task.date = self.datePicker.date
            //追加
            self.task.category = self.category.text!
            self.realm.add(self.task, update: true)
        }
        setNotification(task)

        super.viewWillDisappear(animated)
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
    func setNotification(task: Task) {
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            if notification.userInfo!["id"] as! Int == task.id {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                break
            }
        }
        
        let notification = UILocalNotification()
        
        notification.fireDate = task.date
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "\(task.title)"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["id":task.id]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
    }
}








