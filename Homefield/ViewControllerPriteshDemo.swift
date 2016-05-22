//
//  ViewController.swift
//  Pie Chart View
//
//  Created by Hamish Knight on 04/03/2016.
//  Copyright © 2016 Redonkulous Apps. All rights reserved.
//

import UIKit

class ViewControllerPriteshDemo: UIViewController {
    
    let pieChartView = PieChartView()
    var tasks=[Task]()
    var userActivities = [String: [String]]()
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    private var animator: UIDynamicAnimator!
    
    private var gravity: UIGravityBehavior!
    
    private var collision: UICollisionBehavior!
    
    func calculate(){
        self.tasks=appDelegate.storedTasks
        for task in self.tasks{
            if((task.username) != nil){
                if((userActivities[task.username]) != nil){
                    userActivities[task.username]?.append(task.description!)
                }else{
                    userActivities[task.username!]=[String].init(arrayLiteral: task.description!)
                }
                
            }
        }
        print(userActivities.count)
    }
    
    
    func generateRandomColor()->UIColor{
        let randomR = CGFloat(arc4random_uniform(255) + 1)
        let randomG = CGFloat(arc4random_uniform(255) + 1)
        let randomB = CGFloat(arc4random_uniform(255) + 1)
        
        return UIColor.init(red: randomR/255.0, green: randomG/255.0, blue: randomB/255.0, alpha: 1.0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calculate()
        pieChartView.frame = CGRect(x: 30, y: /*40*/40, width: 300/*UIScreen.mainScreen().bounds.size.width*/, height: 400)
        
        
        for activity in userActivities{
            print(activity)
            let percentageValue = Float.init(activity.1.count)*100/Float.init(tasks.count)
            pieChartView.segments.append(
                Segment(color: self.generateRandomColor(), name:activity.0, value: CGFloat(percentageValue)))
        }
        
        
        pieChartView.segmentLabelFont = UIFont.systemFontOfSize(15)
        pieChartView.showSegmentValueInLabel = true
        
        view.addSubview(pieChartView)
        
        
        animator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [pieChartView])
        animator.addBehavior(gravity)
        
        collision = UICollisionBehavior(items: [pieChartView])
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        
        let itemBehaviour = UIDynamicItemBehavior(items: [pieChartView])
        itemBehaviour.elasticity = 0.8
        animator.addBehavior(itemBehaviour)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

