////
////  App42ServiceList.swift
////  SkyEscape
////
////  Created by Allen Boynton on 9/14/16.
////  Copyright © 2016 Full Sail. All rights reserved.
////
//
//import UIKit
//
//class App42ServiceList: UITableViewController {
//    
//    let apiKey = "9d8e35010812acb92f8052053395150c6afe1e0411092e91be1f6f254cb87254"
//    let secretKey = "309c6e89f054756581d75a315ce22f77eb20e22225907f77d8ff7a311f2af327"
//    
//    
//    var serviceList:NSDictionary? = nil
//    var sortedKeys:NSArray? = nil
//    
//    var servicesCount = 0
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        /***
//         * Innitialising App42API
//         */
//        App42API.initializeWithAPIKey(apiKey, andSecretKey: secretKey)
//        App42API.enableApp42Trace(true)
//        
//        /*** Initialised ***/
//        
//        self.navigationItem.title = "App42 Services"
//        
//        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        
//        let filePath:String = NSBundle.mainBundle().pathForResource("App42Services", ofType: "plist")!
//        
//        serviceList = NSDictionary(contentsOfFile: filePath)!
//        servicesCount = (serviceList?.count)!
//        let allKeys:NSMutableArray = NSMutableArray(array: (serviceList?.allKeys)!)
//        
//        sortedKeys = allKeys.sortedArrayUsingSelector(#selector(NSString.caseInsensitiveCompare(_:)))
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    // MARK: - Table view data source
//    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 1
//    }
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.~
//        // Return the number of rows in the section.
//        return servicesCount
//    }
//    
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
//        
//        // Configure the cell...
//        let index = indexPath.row
//        cell.textLabel!.text = sortedKeys?.objectAtIndex(index) as? String
//        return cell
//    }
//    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let cell = tableView.cellForRowAtIndexPath(indexPath)
//        let cellText = cell?.textLabel!.text
//        if cellText == "User Service"
//        {
//            let userServiceAPI:UserServiceAPI = UserServiceAPI(style: UITableViewStyle.Plain)
//            userServiceAPI.apiList = serviceList?.objectForKey(cellText!) as? NSArray
//            self.navigationController?.pushViewController(userServiceAPI, animated: true)
//        }
//        else if cellText == "Game Service"
//        {
//            let gameServiceAPI:GameServiceAPI = GameServiceAPI(style: UITableViewStyle.Plain)
//            gameServiceAPI.apiList = serviceList?.objectForKey(cellText!) as? NSArray
//            self.navigationController?.pushViewController(gameServiceAPI, animated: true)
//        }
//        else if cellText == "Storage Service"
//        {
//            let storageServiceAPI:StorageServiceAPI = StorageServiceAPI(style: UITableViewStyle.Plain)
//            storageServiceAPI.apiList = serviceList?.objectForKey(cellText!) as? NSArray
//            self.navigationController?.pushViewController(storageServiceAPI, animated: true)
//        }
//        else if cellText == "PushNotification Service"
//        {
//            let pushServiceAPI:PushNotificationServiceAPI = PushNotificationServiceAPI(style: UITableViewStyle.Plain)
//            pushServiceAPI.apiList = serviceList?.objectForKey(cellText!) as? NSArray
//            self.navigationController?.pushViewController(pushServiceAPI, animated: true)
//        }
//        else if cellText == "Scoreboard Service"
//        {
//            let sbServiceAPI:ScoreboardServiceAPI = ScoreboardServiceAPI(style: UITableViewStyle.Plain)
//            sbServiceAPI.apiList = serviceList?.objectForKey(cellText!) as? NSArray
//            self.navigationController?.pushViewController(sbServiceAPI, animated: true)
//        }
//        else if cellText == "Reward Service"
//        {
//            let rewardServiceAPI:RewardServiceAPI = RewardServiceAPI(style: UITableViewStyle.Plain)
//            rewardServiceAPI.apiList = serviceList?.objectForKey(cellText!) as? NSArray
//            self.navigationController?.pushViewController(rewardServiceAPI, animated: true)
//        }
//        else if cellText == "Upload Service"
//        {
//            let rewardServiceAPI:UploadServiceAPI = UploadServiceAPI(style: UITableViewStyle.Plain)
//            rewardServiceAPI.apiList = serviceList?.objectForKey(cellText!) as? NSArray
//            self.navigationController?.pushViewController(rewardServiceAPI, animated: true)
//        }
//        else if cellText == "Catalogue Service"
//        {
//            let catalogueServiceAPI:CatalogueServiceAPI = CatalogueServiceAPI(style: UITableViewStyle.Plain)
//            catalogueServiceAPI.apiList = serviceList?.objectForKey(cellText!) as? NSArray
//            self.navigationController?.pushViewController(catalogueServiceAPI, animated: true)
//        }
//        else if cellText == "Message Service"
//        {
//            let messageServiceAPI:MessageServiceAPI = MessageServiceAPI(style: UITableViewStyle.Plain)
//            messageServiceAPI.apiList = serviceList?.objectForKey(cellText!) as? NSArray
//            self.navigationController?.pushViewController(messageServiceAPI, animated: true)
//        }
//        else if cellText == "Achievement Service"
//        {
//            let achievementServiceAPI:AchievementServiceAPI = AchievementServiceAPI(style: UITableViewStyle.Plain)
//            achievementServiceAPI.apiList = serviceList?.objectForKey(cellText!) as? NSArray
//            self.navigationController?.pushViewController(achievementServiceAPI, animated: true)
//        }
//        else if cellText == "Timer Service"
//        {
//            let timerServiceAPI:TimerServiceAPI = TimerServiceAPI(style: UITableViewStyle.Plain)
//            timerServiceAPI.apiList = serviceList?.objectForKey(cellText!) as? NSArray
//            self.navigationController?.pushViewController(timerServiceAPI, animated: true)
//        }
//        else if cellText == "Buddy Service"
//        {
//            let buddyServiceAPI:BuddyServiceAPI = BuddyServiceAPI(style: UITableViewStyle.Plain)
//            buddyServiceAPI.apiList = serviceList?.objectForKey(cellText!) as? NSArray
//            self.navigationController?.pushViewController(buddyServiceAPI, animated: true)
//        }
//        else if cellText == "Log Service"
//        {
//            let logServiceAPI:LoggingServiceAPI = LoggingServiceAPI(style: UITableViewStyle.Plain)
//            logServiceAPI.apiList = serviceList?.objectForKey(cellText!) as? NSArray
//            self.navigationController?.pushViewController(logServiceAPI, animated: true)
//        }
//            /*   else if cellText == "Avatar Service"
//             {
//             let avatarServiceAPI:AvatarServiceAPI = AvatarServiceAPI(style: UITableViewStyle.Plain)
//             avatarServiceAPI.apiList = serviceList?.objectForKey(cellText!) as? NSArray
//             self.navigationController?.pushViewController(avatarServiceAPI, animated: true)
//             }*/
//        else if cellText == "Email Service"
//        {
//            let emailServiceAPI:EmailServiceAPI = EmailServiceAPI(style: UITableViewStyle.Plain)
//            emailServiceAPI.apiList = serviceList?.objectForKey(cellText!) as? NSArray
//            self.navigationController?.pushViewController(emailServiceAPI, animated: true)
//        }
//        else if cellText == "Event Service"
//        {
//            let eventServiceAPI:EventServiceAPI = EventServiceAPI(style: UITableViewStyle.Plain)
//            eventServiceAPI.apiList = serviceList?.objectForKey(cellText!) as? NSArray
//            self.navigationController?.pushViewController(eventServiceAPI, animated: true)
//        }
//        else if cellText == "Geo Service"
//        {
//            let geoServiceAPI:GeoServiceAPI = GeoServiceAPI(style: UITableViewStyle.Plain)
//            geoServiceAPI.apiList = serviceList?.objectForKey(cellText!) as? NSArray
//            self.navigationController?.pushViewController(geoServiceAPI, animated: true)
//        }
//        else if cellText == "Custom Code Service"
//        {
//            let customCodeServiceAPI:CustomCodeServiceAPI = CustomCodeServiceAPI(style: UITableViewStyle.Plain)
//            customCodeServiceAPI.apiList=serviceList?.objectForKey(cellText!) as? NSArray
//            self.navigationController?.pushViewController(customCodeServiceAPI, animated: true)
//        }
//        else if cellText == "Gift Service"
//        {
//            let giftServiceAPI:GiftServiceAPI = GiftServiceAPI(style: UITableViewStyle.Plain)
//            giftServiceAPI.apiList=serviceList?.objectForKey(cellText!) as? NSArray
//            self.navigationController?.pushViewController(giftServiceAPI, animated: true)
//        }
//        else if cellText == "PhotoGalleryService"
//        {
//            let photogalleryServiceAPI:PhotoGalleryServiceAPI = PhotoGalleryServiceAPI(style: UITableViewStyle.Plain)
//            photogalleryServiceAPI.apiList=serviceList?.objectForKey(cellText!) as? NSArray
//            self.navigationController?.pushViewController(photogalleryServiceAPI, animated: true)
//        }
//        else if cellText == "Recommend Service"
//        {
//            let recommenderServiceAPI:RecommenderServiceAPI = RecommenderServiceAPI(style: UITableViewStyle.Plain)
//            recommenderServiceAPI.apiList=serviceList?.objectForKey(cellText!) as? NSArray
//            self.navigationController?.pushViewController(recommenderServiceAPI, animated: true)
//        }
//        else if cellText == "Cart Service"
//        {
//            let cartServiceAPI:CartServiceAPI = CartServiceAPI(style: UITableViewStyle.Plain)
//            cartServiceAPI.apiList=serviceList?.objectForKey(cellText!) as? NSArray
//            self.navigationController?.pushViewController(cartServiceAPI, animated: true)
//        }
//        else if cellText == "Social Service"
//        {
//            let socialServiceAPI:SocialServiceAPI = SocialServiceAPI(style: UITableViewStyle.Plain)
//            socialServiceAPI.apiList=serviceList?.objectForKey(cellText!) as? NSArray
//            self.navigationController?.pushViewController(socialServiceAPI, animated: true)
//        }
//        else if cellText == "Review Service"
//        {
//            let reviewServiceAPI:ReviewServiceAPI = ReviewServiceAPI(style: UITableViewStyle.Plain)
//            reviewServiceAPI.apiList=serviceList?.objectForKey(cellText!) as? NSArray
//            self.navigationController?.pushViewController(reviewServiceAPI, animated: true)
//        }
//        else if cellText == "ABTest Service"
//        {
//            let abTestServiceAPI:ABTestServiceAPI = ABTestServiceAPI(style: UITableViewStyle.Plain)
//            abTestServiceAPI.apiList=serviceList?.objectForKey(cellText!) as? NSArray
//            self.navigationController?.pushViewController(abTestServiceAPI, animated: true)
//        }
//        else if cellText == "Session Service"
//        {
//            let sessionServiceAPI:SessionServiceAPI = SessionServiceAPI(style: UITableViewStyle.Plain)
//            sessionServiceAPI.apiList=serviceList?.objectForKey(cellText!) as? NSArray
//            self.navigationController?.pushViewController(sessionServiceAPI, animated: true)
//        }
//        
//        
//        
//        
//        /*
//         // Override to support conditional editing of the table view.
//         override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//         // Return NO if you do not want the specified item to be editable.
//         return true
//         }
//         */
//        
//        /*
//         // Override to support editing the table view.
//         override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//         if editingStyle == .Delete {
//         // Delete the row from the data source
//         tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//         } else if editingStyle == .Insert {
//         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//         }
//         }
//         */
//        
//        /*
//         // Override to support rearranging the table view.
//         override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
//         
//         }
//         */
//        
//        /*
//         // Override to support conditional rearranging of the table view.
//         override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//         // Return NO if you do not want the item to be re-orderable.
//         return true
//         }
//         */
//        
//        /*
//         // MARK: - Navigation
//         
//         // In a storyboard-based application, you will often want to do a little preparation before navigation
//         override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//         // Get the new view controller using [segue destinationViewController].
//         // Pass the selected object to the new view controller.
//         }
//         */
//        
//    }
//}
