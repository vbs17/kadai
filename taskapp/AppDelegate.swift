



import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

                                                                      //ローカル通知の他には、URLからの起動やプッシュ通知からの起動
                                 //// 通知からの起動かどうか確認する  //// 通知領域から削除する //// ユーザに通知の許可を求める
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let settings = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        if let notification = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
            application.cancelLocalNotification(notification)
        }
       return true
    }
              // アプリがフォアとバックの起動理由 // アラートを表示する // バックグランドにいる時に通知が届いた時はログに出力するだけ
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        if application.applicationState == UIApplicationState.Active {
            let alertController = UIAlertController(title: "時間になりました", message:notification.alertBody, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(defaultAction)
            window?.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
        } else {
            print("\(notification.alertBody)")
        }
        application.cancelLocalNotification(notification)
    }

    func applicationWillResignActive(application: UIApplication) {
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
            }

    func applicationWillEnterForeground(application: UIApplication) {
        
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
    }

    func applicationWillTerminate(application: UIApplication) {
        
    }


}

