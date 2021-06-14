//
//  HomeVC.swift
//  Eventor
//
//  Created by Saleh on 19/05/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase


class HomeVC: UIViewController, UISearchBarDelegate {
    
    var FirebaseStorage: Storage?
    
    var events = [Event]()
    
    //var myEvents = [String]()
    
    var returnCell: String = "events"
    var isRefreshing:Bool = false
    @IBOutlet weak var homeNavBar: UINavigationItem!
    
    let viewOne:UIView = UIView.init(frame: CGRect.init())
    let viewTow:UIView = UIView.init(frame: CGRect.init())
    let reFreshBGView:UIView = UIView.init(frame: CGRect.init())

    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var filterBtn: UIBarButtonItem!
    
    @IBOutlet weak var collectionView:UICollectionView!
    let cellScaling :CGFloat = 0.7

    @IBOutlet var FilterView: UIView!
    
    @IBOutlet weak var attendenceTypeSeg: UISegmentedControl!
    var attendenceTypeSegment: String!
    
    var EventManagerProfileImage = ""
    var EventManagerName = ""
    
    var isSearching: Bool!
    var isFiltering: Bool!
    var searchTxtVal = ""
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBtn: UIBarButtonItem!
    var searchBarIsSown = true
    
    @IBOutlet weak var RefreashView:UIView!

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var refresher: UIRefreshControl!

    let Ref: DatabaseReference = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HindeKeyboardViewTouched()
        UIApplication.shared.statusBarView?.backgroundColor = hexStringToUIColor("#fe5427")
        
        createBtn.isHidden = true
        
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem!.customView?.alpha = 0.0
        
        if (Auth.auth().currentUser == nil) {
            performSegue(withIdentifier: "notRegisteredUser", sender: nil)
        } else {
            if currnetUser.uType == userGeneral.getEMStrFormat(){
                self.navigationItem.rightBarButtonItem = nil
                self.navigationItem.leftBarButtonItem = nil
                self.createBtn.isHidden = false
            }
        }
        
        togglrSearchBar()
        
        self.RefreashView.frame.size = CGSize(width: RefreashView.layer.frame.height, height: RefreashView.layer.frame.height)
        self.RefreashView.layer.cornerRadius =  RefreashView.layer.frame.height / 2
        
        //collection View
        
        let screenSize =  UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        let cellHeight = floor(screenSize.height * cellScaling)

        let EveX = (view.bounds.width - cellWidth) / 2.0
        let EveY = (view.bounds.height - cellHeight) / 2.0
        
        let layout  = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionView?.contentInset = UIEdgeInsets(top: EveY, left: EveX, bottom: EveY, right: EveX)
        
        RefreashView.addSubview(activityIndicator)
        activityIndicator.center = RefreashView.center
        
        isSearching = false
        isFiltering = false
        
        
        loadEvents()
        FBDBHandler.FBDBHandlerObj.loadUsers(onSucces:{}, onError: {_ in })
        ShowHiMsg()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        sniffSideRefrishAndSearch(times: 2)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func ShowHiMsg(){
        var msg = ""
        let color:UIColor = UIColor(named: "orangRed3")!
        if currnetUser.uType == userGeneral.getNUStrFormat(){
            msg = "Hi \((currnetUser as! normalUser).name!) "
            
        }else if currnetUser.uType == userGeneral.getEMStrFormat(){
            msg = "Hi \((currnetUser as! eventManager).name!) "
        }
        
        notificationHelper.notificationHelperObj.showError(callerVC: self, Err: msg, color: color)

    }
    
    @objc func loadEvents() {
        if (isSearching && !isFiltering) {
            FBDBHandler.FBDBHandlerObj.searchForEvents(keyWord: searchTxtVal, filterBy: nil, onSucces: {
                self.endRefrising()
                self.events = allEventsGlobalArry
                self.collectionView.reloadData()

            }, onError: {_ in})
        } else if (isSearching && isFiltering) {
            FBDBHandler.FBDBHandlerObj.searchForEvents(keyWord: searchTxtVal, filterBy: attendenceTypeSegment, onSucces: {
                self.endRefrising()
                self.events = allEventsGlobalArry
                self.collectionView.reloadData()

            }, onError: {_ in})
        } else {
            FBDBHandler.FBDBHandlerObj.loadEves(onSucces: {
                if currnetUser.uType != userGeneral.getEMStrFormat(){
                    self.endRefrising()
                    self.events = allEventsGlobalArry
                    self.collectionView.reloadData()

                }else{
                    print("\nYYYYYYYYYYYYYYYYYY\n")
                    FBDBHandler.FBDBHandlerObj.loadMyEventsID(UID: currnetUser.UID, completion: {
                        if let MyEventIds:[String] =  (currnetUser as! eventManager).MyEvents {
                            print("\n==================\n")
                            
                            let  MyEvents:[Event] = Event.getEveListByIDsFromGolbEveArry(EIDs: MyEventIds)
                            print(MyEvents)
                            self.endRefrising()
                            self.events = MyEvents
                            self.collectionView.reloadData()
                        }
                    })
                }
               
            }, onError: {_ in })
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { //search
        if (searchBar.text == "") { //validation
           notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "Search Bar cannot be empty", color: .red)
        }
        else {
            
        
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        self.navigationItem.leftBarButtonItem?.customView?.alpha = 1.0
        isSearching = true
        
        view.endEditing(true)
        searchTxtVal = searchBar.text!
        FBDBHandler.FBDBHandlerObj.searchForEvents(keyWord: searchTxtVal, filterBy: nil, onSucces: {
            self.collectionView.reloadData()
        }, onError: {_ in})
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem?.customView?.alpha = 0.0
        isSearching = false
        isFiltering = false
        
        view.endEditing(true)
        searchBar.text = ""
        searchBtn.isEnabled = true
        togglrSearchBar()
        loadEvents()
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        searchBtn.isEnabled = false
        togglrSearchBar()
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        self.FilterView.removeFromSuperview()
    }
    
    @IBAction func filterBtnPressed(_ sender: Any) {
        self.FilterView.frame.size = self.view.frame.size
        self.view.addSubview(self.FilterView)
        self.FilterView.center = self.view.center
    }
    
    @IBAction func attendenceTypeSeg(_ sender: UISegmentedControl) {
        attendenceTypeSegment = sender.titleForSegment(at: sender.selectedSegmentIndex)
    }
    
    //Filter
    @IBAction func applyBtnPressed(_ sender: Any) {
        isFiltering = true
        view.endEditing(true)
        searchTxtVal = searchBar.text!
        FBDBHandler.FBDBHandlerObj.searchForEvents(keyWord: searchTxtVal, filterBy: attendenceTypeSegment, onSucces: {
            self.collectionView.reloadData()
        }, onError: {_ in})
        
        self.FilterView.removeFromSuperview()
    }
    
    @IBAction func removeFilterBtnPressed(_ sender: Any) {
        isFiltering = false
        searchBarSearchButtonClicked(self.searchBar)
        self.FilterView.removeFromSuperview()
    }

    @IBAction func createBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "createEvent", sender: nil)
    }
    
    func togglrSearchBar() {
        if searchBarIsSown {
            //hide
            searchBarIsSown = false
            UIView.animate(withDuration: 0.5 , animations: {
                self.searchBar.transform = CGAffineTransform.init(translationX: 0, y: -(self.searchBar.frame.size.height))
                self.collectionView.transform = CGAffineTransform.init(translationX: 0, y: -((self.searchBar.frame.size.height)/2))
                
            })
        }else{
            //show
            searchBarIsSown = true
            UIView.animate(withDuration: 0.5 , animations: {
                self.searchBar.transform = .identity
                self.collectionView.transform = .identity
            })
        }
    }
    
    func  sniffSideRefrishAndSearch(times:Int){
        var _times = abs(times)
        for i in 0..._times{
            UIView.animate(withDuration: 0.2 , animations: {
                self.searchBar.transform = CGAffineTransform.init(translationX: 0, y: -(self.searchBar.frame.size.height))
                self.searchBar.transform = CGAffineTransform.init(translationX: 0, y: 10)
                self.collectionView.transform = CGAffineTransform.init(translationX: 0, y: 10)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.searchBar.transform = CGAffineTransform.init(translationX: 0, y: (self.searchBar.frame.size.height))
                    self.searchBar.transform = CGAffineTransform.init(translationX: 0, y: 10)
                    self.collectionView.transform = CGAffineTransform.init(translationX: 0, y: 0)
                }
            })
        }
    }
}



extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (events.count != 0) {
            returnCell = "events"
            return  events.count
        }else {
            returnCell = "noEvents"
            return  1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(returnCell == "events"){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCVCell", for: indexPath) as! EventCollectionViewCell
            print("\(indexPath.row)>>\(events.count)")
            if (indexPath.row < events.count){
                cell.EventObj = events.reversed()[indexPath.row]
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoEventsCell", for: indexPath) as! UICollectionViewCell
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true)
        let VC = storyboard?.instantiateViewController(withIdentifier: "ViewEventVC") as? ViewEventVC
        if (indexPath.row < events.count){
            let eachEvent = events.reversed()[indexPath.row]
            
            VC?.fromWhere = "Home"
            VC?.EveHolder = eachEvent

            FBDBHandler.FBDBHandlerObj.loadIdOfSubscribers(EventObj: eachEvent, completion: {
                VC?.SubscribersLbl.text = "\(String(describing: eachEvent.getNumOfSubscribers()))"
            })
            self.navigationController?.pushViewController(VC!, animated: true)
        }
    }
    
    
    
    
    //to stop in the center of the cell
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
        
        print(roundedIndex)//the index will move to
        print(index) // where is the posetion is scrolling to
        print(offset) // positon of the tap(fingerTap in the screen)
    }

    //showing custom refreash
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var x = scrollView.contentOffset.x + scrollView.contentInset.left
        print(x)
        
        if (x < 0 ){
            if setRView(ByX: -x){
                scrollView.contentOffset.x =  0
            }
        }
    }
    
    func setRView(ByX:CGFloat)-> Bool{
        if (ByX > 100  && ByX < 200 && !isRefreshing){
            self.loadEvents()
            startRefrising()
            return true
        } else if (!isRefreshing){
            RefreashView.frame.size = CGSize(width: 100 + ByX , height: RefreashView.frame.height)
            return false
        }
        return false
    }
    
    func startRefrising(){
        isRefreshing = true
        RefreashView.frame.size = CGSize(width: 300 , height: RefreashView.frame.height)

        let viewCenter =  view.center
        reFreshBGView.frame.size  = view.frame.size
        reFreshBGView.center = viewCenter

        viewOne.backgroundColor = .red
        viewTow.backgroundColor = .orange
        reFreshBGView.backgroundColor = .clear

        viewOne.center.y = viewCenter.y
        viewTow.center.y = viewCenter.y
        viewOne.alpha = 0
        viewTow.alpha = 0

        view.addSubview(viewOne)
        view.addSubview(viewTow)
        view.addSubview(reFreshBGView)

        UIView.animate(withDuration: 0.5 , animations: {
            self.viewOne.layer.cornerRadius = 80/2
            self.viewTow.layer.cornerRadius = 50/2

            self.viewOne.frame.size = CGSize(width: 80 , height: 80)
            self.viewTow.frame.size = CGSize(width: 50 , height: 50)


            self.viewOne.center = viewCenter
            self.viewTow.center = viewCenter
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.viewOne.alpha = 0.8
                self.viewTow.alpha = 0.8
            }
        })
        
        let vOneframe = CGSize(width: 80 , height: 80)
        let Vtowframe = CGSize(width: 50 , height: 50)

        UIView.animate(withDuration: 0.5, delay: 0.1, options: [.repeat, .autoreverse], animations: {
            
            self.viewOne.frame.size = Vtowframe
            self.viewTow.frame.size = vOneframe
            
        }, completion: { (finished: Bool) -> Void in
            
        })
    }
    
    func endRefrising(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isRefreshing = false
            self.viewOne.layer.removeAllAnimations()
            self.viewTow.layer.removeAllAnimations()
            
            self.viewOne.removeFromSuperview()
            self.viewTow.removeFromSuperview()
            self.reFreshBGView.removeFromSuperview()

        }
    }
}
