//
//  ViewController.swift
//  zegarek
//
//  Created by Arkadiusz Wojdyła on 07/10/2022.
//

import UIKit
import Foundation
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{
    var times = [Dictionary<String,String>]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count;
    }
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         let cell = table.dequeueReusableCell(withIdentifier: "cell") as! TableData;
         cell.left.textColor = UIColor(red: 0/256.0, green: 0/256.0, blue: 0/256.0, alpha: 1)
         cell.mid.textColor = UIColor(red: 0/256.0, green: 0/256.0, blue: 0/256.0, alpha: 1)
         cell.right.textColor = UIColor(red: 0/256.0, green: 0/256.0, blue: 0/256.0, alpha: 1)
         cell.left.text = "NR RUNDY"
         cell.mid.text = "POŚR"
         cell.right.text = "ŁĄCZNY"
        return cell
    }
    
    @IBOutlet weak var sv: UIScrollView!
    var slides = Array<Any>()
    @IBOutlet weak var pc: UIPageControl!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableData;
        
        
        if(cell.left.text != "NR RUNDY"){
            if(times.count>1){
                findMaxMin()
                if(getMiliseconds(timestamp: times[indexPath.row]["mid"]!) == maks){
                    cell.left.textColor = UIColor(red: 50/256.0, green: 168/256.0, blue: 82/256.0, alpha: 1)
                    cell.mid.textColor = UIColor(red: 50/256.0, green: 168/256.0, blue: 82/256.0, alpha: 1)
                    cell.right.textColor = UIColor(red: 50/256.0, green: 168/256.0, blue: 82/256.0, alpha: 1)
                    
                    cell.left.text = times[indexPath.row]["round"]
                    cell.mid.text = times[indexPath.row]["mid"];
                    cell.right.text = times[indexPath.row]["total"];
                    return cell
                }else if(getMiliseconds(timestamp: times[indexPath.row]["mid"]!) == minimum){
                    cell.left.textColor = UIColor(red: 168/256.0, green: 50/256.0, blue: 50/256.0, alpha: 1)
                    cell.mid.textColor = UIColor(red: 168/256.0, green: 50/256.0, blue: 50/256.0, alpha: 1)
                    cell.right.textColor = UIColor(red: 168/256.0, green: 50/256.0, blue: 50/256.0, alpha: 1)
                    cell.left.text = times[indexPath.row]["round"]
                    cell.mid.text = times[indexPath.row]["mid"];
                    cell.right.text = times[indexPath.row]["total"];
                    return cell
                }
            }
        }
        cell.left.textColor = UIColor(red: 0/256.0, green: 0/256.0, blue: 0/256.0, alpha: 1)
        cell.mid.textColor = UIColor(red: 0/256.0, green: 0/256.0, blue: 0/256.0, alpha: 1)
        cell.right.textColor = UIColor(red: 0/256.0, green: 0/256.0, blue: 0/256.0, alpha: 1)
        
        
        
        
        
        
        
        
        cell.left.text = times[indexPath.row]["round"]
        cell.mid.text = times[indexPath.row]["mid"];
        cell.right.text = times[indexPath.row]["total"];
        return cell;
        
    }
    var pcanimation = Timer();

    @IBAction func pcchanged(_ sender: UIPageControl) {
        let x = CGFloat(sender.currentPage) * view.frame.width
        
        startXForAnimation = sv.contentOffset.x;
        endXForAnimation = CGFloat(sender.currentPage) * view.frame.width
        
                animationtimer =  Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(animate), userInfo: nil, repeats: true)
                
               
               
                sv.contentOffset = CGPoint(x: x, y: 0)
        
    }
    @objc func animate(){
        if(startXForAnimation == endXForAnimation){
            animationtimer.invalidate();
        }
       
        if(startXForAnimation>endXForAnimation){
            startXForAnimation -= 1;
        }else{
            startXForAnimation += 1;
        }
       
        
        
        sv.contentOffset = CGPoint(x: startXForAnimation, y: 0);
    }

    /*
     cell.left.textColor = UIColor(red: 0/256.0, green: 0/256.0, blue: 0/256.0, alpha: 1)
     
     */
    

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var table: UITableView!
    var maks=0, minimum=0;
    var tab: [Int] = []
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var bt2: UIButton!
    @IBOutlet weak var bt1: UIButton!
    var timerGoing = false;
    var timer = Timer();
    var ctx : CGContext!;
    var roundExists = false;
    var miliseconds = ((60 * 60)*50) - 3*(60*60);
    override func viewDidLoad() {
        print("start")
        super.viewDidLoad()
        bt2.layer.cornerRadius = 50
        bt1.layer.cornerRadius = 50
        // Do any additional setup after loading the view.
     
        sv.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/3)
        sv.isPagingEnabled = true    // w przypadku dwóch widoków - nadmiarowe

        // odpowiednie paski przewijania
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        let slideA : slideA = Bundle.main.loadNibNamed("slideA", owner: self, options: nil)?.first as! slideA
        let slideB = Bundle.main.loadNibNamed("slideB", owner: self, options: nil)?.first as! slideB

        slideA.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/3)
        slideB.frame = CGRect(x: view.frame.width, y: 0, width: view.frame.width, height: view.frame.height/3)
                
        slides = [slideA, slideB]
        
        
        sv.addSubview(slideA)
        sv.addSubview(slideB)
        
        sv.contentSize = CGSize(width: view.frame.width*2, height: view.frame.height-24)   // 24 - pobierz programowo wartość StatusBara'a
        
        pc.numberOfPages = slides.count
        
        
        
        tableview.dataSource = self;
        tableview.delegate = self;
        updateStopwatch()
        changeButton(title: "Start")
        sv.delegate = self;
        
        
        
        
        
        
        UIGraphicsBeginImageContext(slideB.cyferblatIv.bounds.size)
        slideB.cyferblatIv.draw(slideB.cyferblatIv.bounds)
        ctx=UIGraphicsGetCurrentContext()

        
        ctx?.setLineWidth(2.0)
        ctx?.setStrokeColor(UIColor.orange.cgColor)
        ctx?.move(to: CGPoint(x: slideB.cyferblatIv.bounds.width/2, y: slideB.cyferblatIv.bounds.height/2))
        ctx?.addLine(to: CGPoint(x: slideB.cyferblatIv.bounds.width/2, y: 0))
        ctx?.strokePath()
        
        ctx?.setStrokeColor(UIColor.red.cgColor)
        ctx?.move(to: CGPoint(x: slideB.cyferblatIv.bounds.width/2, y: slideB.cyferblatIv.bounds.height/3))
        ctx?.addLine(to: CGPoint(x: slideB.cyferblatIv.bounds.width/2, y: (slideB.cyferblatIv.bounds.height/3)/2+10))
        ctx?.strokePath()

    
        slideB.cyferblatIv.image=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(sv.contentOffset.x/view.frame.width)
        pc.currentPage = Int(pageIndex)
       scrollView.contentOffset.y = 0
    }
    
    var startXForAnimation = CGFloat(0);
    var endXForAnimation = CGFloat(0);
    var animationtimer = Timer();
    @IBAction func change(_ sender: UIPageControl) {


       
        
    }
    
    
    
    
    
    func changeButton(title: String){
        if(title=="Start"){
            bt2.setTitle("Start", for: .normal)
            bt1.setTitle("Wyzeruj", for: .normal)
            bt2.setTitleColor(UIColor(red: 51/255, green: 199/255, blue: 90/255, alpha: 1), for: .normal)
            bt2.backgroundColor = UIColor(red: 62.0/256.0, green: 94.0/256.0, blue: 58.0/256.0, alpha: 1)
        }else{
            bt2.backgroundColor = UIColor(red: 120/256.0, green: 62/256.0, blue: 58/256.0, alpha: 1)
            bt2.setTitle("Stop", for: .normal)
            bt2.setTitleColor(UIColor(red: 1.0, green: 0, blue: 0, alpha: 1), for: .normal)
        }
       
    }
    func updateStopwatch(){
        let time = Date(timeIntervalSince1970: TimeInterval(miliseconds))
        let dF = DateFormatter();
        dF.locale = Locale(identifier: "pl_PL")
        dF.setLocalizedDateFormatFromTemplate("HH:mm.ss")
        let format = dF.string(from: time);
        label.text = format;
        (slides[0] as! slideA).timerlabel.text=format;
        
        let slideB = slides[1] as! slideB;
        slideB.cyferblatText.text = format;
        
    }

    var angle = -1*(Double.pi/2);
    var angleRounds = -1*(Double.pi/2);
    var angleMinutes = -1*(Double.pi/2);
    @objc func update() {
        miliseconds += 1;
        let blat = UIImage(named: "cyferblat")
        let slideB = slides[1] as! slideB;
        UIGraphicsEndImageContext()
        slideB.cyferblatIv.image = blat
        UIGraphicsBeginImageContext(slideB.cyferblatIv.bounds.size)
        UIGraphicsBeginImageContext(slideB.cyferblatIv.bounds.size)
        slideB.cyferblatIv.draw(slideB.cyferblatIv.bounds)
        
        angle += 0.1 * (Double.pi/180.0);
        
        ctx=UIGraphicsGetCurrentContext()
        slideB.cyferblatIv.image = blat
        ctx?.setLineWidth(2.0)
        ctx?.setStrokeColor(UIColor.orange.cgColor)
        let centerX = slideB.cyferblatIv.bounds.width/2;
        let centerY = slideB.cyferblatIv.bounds.height/2
        let cosA = cos(angle)
        let sinA = sin(angle)
        let length = slideB.cyferblatIv.bounds.height/2
        ctx?.move(to: CGPoint(x: slideB.cyferblatIv.bounds.width/2, y: slideB.cyferblatIv.bounds.height/2))
        ctx?.addLine(to: CGPoint(x: CGFloat(length * cosA + centerX), y: CGFloat(length * sinA + centerY)))
        ctx?.strokePath()
        
        
        
        //minutnik
        angleMinutes += (0.1/30.0) * (Double.pi/180.0);
        let x = slideB.cyferblatIv.bounds.width/2
        let y = slideB.cyferblatIv.bounds.height/3
        let cosM = cos(angleMinutes)
        let sinM = sin(angleMinutes)
        let lengthM = (slideB.cyferblatIv.bounds.height/3)/2-10
        
        ctx?.setStrokeColor(UIColor.orange.cgColor)
        ctx?.move(to: CGPoint(x: slideB.cyferblatIv.bounds.width/2, y: slideB.cyferblatIv.bounds.height/3 - 3))
        ctx?.addLine(to: CGPoint(x: CGFloat(lengthM * cosM + x), y: CGFloat(lengthM * sinM + y)))
        ctx?.strokePath()
        
        
        if(roundExists){
            ctx?.setStrokeColor(UIColor.blue.cgColor)
            ctx=UIGraphicsGetCurrentContext()
            slideB.cyferblatIv.image = blat
            ctx?.setLineWidth(2.0)
            ctx?.setStrokeColor(UIColor.orange.cgColor)
            var centerX = slideB.cyferblatIv.bounds.width/2;
            var centerY = slideB.cyferblatIv.bounds.height/2
            var cosA = cos(angle)
            var sinA = sin(angle)
            var length = slideB.cyferblatIv.bounds.height/2
            ctx?.move(to: CGPoint(x: slideB.cyferblatIv.bounds.width/2, y: slideB.cyferblatIv.bounds.height/2))
            ctx?.addLine(to: CGPoint(x: CGFloat(length * cosA + centerX), y: CGFloat(length * sinA + centerY)))
            ctx?.strokePath()
            
            angleRounds += 0.1 * (Double.pi/180.0);
            
            ctx=UIGraphicsGetCurrentContext()
            slideB.cyferblatIv.image = blat
            ctx?.setLineWidth(2.0)
            ctx?.setStrokeColor(UIColor.blue.cgColor)
             centerX = slideB.cyferblatIv.bounds.width/2;
             centerY = slideB.cyferblatIv.bounds.height/2
             cosA = cos(angleRounds)
             sinA = sin(angleRounds)
             length = slideB.cyferblatIv.bounds.height/2
            ctx?.move(to: CGPoint(x: slideB.cyferblatIv.bounds.width/2, y: slideB.cyferblatIv.bounds.height/2))
            ctx?.addLine(to: CGPoint(x: CGFloat(length * cosA + centerX), y: CGFloat(length * sinA + centerY)))
            ctx?.strokePath()
            
        }
        
        slideB.cyferblatIv.image=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        
        
        
        updateStopwatch()
    }
    
    
    @IBAction func stoperStartStop(_ sender: Any) {
        if(timerGoing == false){
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
            timerGoing = true;
            
            
            bt1.setTitle("Runda", for: .normal)
            
           changeButton(title: "Stop")
            
            
        }else{
            timerGoing = false;
           changeButton(title: "Start")
            timer.invalidate();
        }
    }
    @IBAction func rounds(_ sender: Any) {
        if(timerGoing){
            roundExists = true;
            angleRounds  = -1*(Double.pi/2);
            let mms = miliseconds
            let time = Date(timeIntervalSince1970: TimeInterval(mms))
            let dF = DateFormatter();
            dF.locale = Locale(identifier: "pl_PL")
            dF.setLocalizedDateFormatFromTemplate("HH:mm.ss")
            let format = dF.string(from: time);
            var mid = ""

            if(times.count == 0){
                mid = format
            }else{
                let str = times[0]["total"]!
                let sliced = str.components(separatedBy: ":")
                let minuets = Int(sliced[0]) ?? 0
                let seconds = Int(sliced[1]) ?? 0
                let mmseconds = Int(sliced[2]) ?? 0
                let sliced2 = format.components(separatedBy: ":")
                let minuets2 = Int(sliced2[0]) ?? 0
                let seconds2 = Int(sliced2[1]) ?? 0
                let mmseconds2 = Int(sliced2[2]) ?? 0
                let s1 = (minuets2 * 6000) + (seconds2 * 100) + mmseconds2
                let s2 = (minuets * 6000) + (seconds * 100) + mmseconds
                var i = s1 - s2
                let newminutes = (i / 6000)
                i = i - (i / 6000) * 6000
                let newseconds = i/100
                i = i - (i/100) * 100
                let newmms = i
                var newminutesString = String(newminutes)
                var newsecondsString = String(newseconds)
                var newmmsString = String(newmms)
                if(newminutes<10){
                    newminutesString = "0"+newminutesString
                }
                if(newseconds<10){
                    newsecondsString = "0"+newsecondsString
                }
                if(newmms<10){
                    newmmsString = "0"+newmmsString
                }
                mid = newminutesString+":"+newsecondsString+":"+newmmsString
            }
            times.insert(["round": "Runda \(times.count+1)", "mid": mid, "total": format, "type": "normal"], at: 0)
            findMaxMin()
            tableview.reloadData()
           
            
        }else{
            miliseconds = ((60 * 60)*50) - 3*(60*60);
            findMaxMin()
            times.removeAll()
            angle = -1*(Double.pi/2);
            let blat = UIImage(named: "cyferblat")
            let slideB = slides[1] as! slideB;
            
            UIGraphicsEndImageContext()
            slideB.cyferblatIv.image = blat
            UIGraphicsBeginImageContext(slideB.cyferblatIv.bounds.size)
            UIGraphicsBeginImageContext(slideB.cyferblatIv.bounds.size)
            slideB.cyferblatIv.draw(slideB.cyferblatIv.bounds)
            angle += 0.1 * (Double.pi/180.0);
            ctx=UIGraphicsGetCurrentContext()
            slideB.cyferblatIv.image = blat
            ctx?.setLineWidth(2.0)
            ctx?.setStrokeColor(UIColor.orange.cgColor)
            let centerX = slideB.cyferblatIv.bounds.width/2;
            let centerY = slideB.cyferblatIv.bounds.height/2
            let cosA = cos(angle)
            let sinA = sin(angle)
            let length = slideB.cyferblatIv.bounds.height/2
            ctx?.move(to: CGPoint(x: slideB.cyferblatIv.bounds.width/2, y: slideB.cyferblatIv.bounds.height/2))
            ctx?.addLine(to: CGPoint(x: CGFloat(length * cosA + centerX), y: CGFloat(length * sinA + centerY)))
            ctx?.strokePath()
            
            
            ctx?.setStrokeColor(UIColor.red.cgColor)
            ctx?.move(to: CGPoint(x: slideB.cyferblatIv.bounds.width/2, y: slideB.cyferblatIv.bounds.height/3))
            ctx?.addLine(to: CGPoint(x: slideB.cyferblatIv.bounds.width/2, y: (slideB.cyferblatIv.bounds.height/3)/2+10))
            ctx?.strokePath()
            
            
            
            slideB.cyferblatIv.image=UIGraphicsGetImageFromCurrentImageContext()
            
            
            UIGraphicsEndImageContext()
            tableview.reloadData();
            updateStopwatch()
        }
    }
    func findMaxMin(){
        if(times.count>0){
            var min = getMiliseconds(timestamp: times[0]["mid"]!);
            var max = getMiliseconds(timestamp: times[0]["mid"]!);
            var h = 0;
            for i in times{
                if(min >= getMiliseconds(timestamp: i["mid"]!)){min = getMiliseconds(timestamp: i["mid"]!)}
                if( max <= getMiliseconds(timestamp: i["mid"]!)){max = getMiliseconds(timestamp: i["mid"]!)}
                h += 1;
            }
            maks = max;
            minimum = min;
        }
    }
    func getMiliseconds(timestamp: String)->Int{
        let sliced = timestamp.components(separatedBy: ":")
        let minuets = Int(sliced[0]) ?? 0
        let seconds = Int(sliced[1]) ?? 0
        let mmseconds = Int(sliced[2]) ?? 0
        return (minuets * 6000) + (seconds * 100) + mmseconds
    }
}
class TableData : UITableViewCell {
    @IBOutlet weak var right: UILabel!
    @IBOutlet weak var mid: UILabel!
    @IBOutlet weak var left: UILabel!
}


