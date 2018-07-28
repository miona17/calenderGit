////
////  CalendarView.swift
////  calendar syutoku
////
////  Created by 倉茂未央那 on 2018/07/07.
////  Copyright © 2018年 倉茂未央那. All rights reserved.
////
//
//import UIKit
//
//@objc protocol CalendarViewDelegate {
//    func changeMonth(_ text:String)
//}
//
//class CalendarView: UICollectionView{
//
//    //セルの余白
//    let cellMargin:CGFloat = 2.0
//    let dateManager = DateManager()
//    //１週間に何日あるか(行数)
//    let daysPerWeek:Int = 7
//    var startDate:Date!
//
//    var calendarDelegate:CalendarViewDelegate!
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
//        super.init(frame: frame, collectionViewLayout: layout)
//        self.register(CalendarCell.self, forCellWithReuseIdentifier: "collectCell")
//        self.delegate = self
//        self.dataSource = self
//        self.backgroundColor = .white
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let visibleCell = self.visibleCells.filter{
//            return self.bounds.contains($0.frame)
//        }
//
//        var visibleCellTag = Array<Int>()
//        if(visibleCell != []){
//            visibleCellTag = visibleCell.map{$0.tag}
//            //月は奇数か偶数か　割り切れるものだけを取り出す
//            let even = visibleCellTag.filter{
//                return $0 % 2 == 0
//            }
//            let odd = visibleCellTag.filter{
//                return $0 % 2 != 0
//            }
//            //oddかevenの多い方を返す
//            let month = even.count >= odd.count ? even[0] : odd[0]
//
//            //桁数によって分岐
//            let digit = numberOfDigit(month: month)
//            var text = ""
//            if(digit == 5){
//                text = String(month / 10) + "年" + String(month % 10) + "月"
//            }else if(digit == 6){
//                text = String(month / 100) + "年" + String(month % 100) + "月"
//            }
//            if calendarDelegate != nil {
//                calendarDelegate.changeMonth(text)
//            }
//        }
//    }
//
//    func numberOfDigit(month:Int) -> Int{
//        var num = month
//        var cnt = 1
//        while(num / 10 != 0){
//            cnt = cnt + 1
//            num = num / 10
//        }
//        return cnt
//
//    }
//
//}
//
//extension CalendarView:UICollectionViewDelegate {
//    //選択した時
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//    }
//}
//
//extension CalendarView: UICollectionViewDataSource {
//
//    //セクションの数
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    //セルの総数
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return dateManager.cellCount(startDate:startDate)
//    }
//
//    //セルの設定
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell:CalendarCell = collectionView.dequeueReusableCell(withReuseIdentifier:"collectCell",for:indexPath as IndexPath) as! CalendarCell
//
//        //土曜日は赤　日曜日は青　にテキストカラーを変更する
//        if(indexPath.row % 7 == 0){
//            cell.textLabel.textColor = UIColor.red
//        }else if(indexPath.row % 7 == 6){
//            cell.textLabel.textColor = UIColor.blue
//        }else{
//            cell.textLabel.textColor = UIColor.gray
//        }
//        cell.tag = Int(dateManager.monthTag(row:indexPath.row,startDate:startDate))!
//        //セルの日付を取得し
//        cell.textLabel.text = dateManager.conversionDateFormat(row:indexPath.row,startDate:startDate)
//
//        //セルの日付を取得
//        let day = Int(dateManager.conversionDateFormat(row:indexPath.row,startDate:startDate!))!
//        if(day == 1){
//            cell.textLabel.border(positions:[.Top,.Left],borderWidth:1,borderColor:UIColor.black)
//        }else if(day <= 7){
//            cell.textLabel.border(positions:[.Top],borderWidth:1,borderColor:UIColor.black)
//        }else{
//            cell.textLabel.border(positions:[.Top],borderWidth:0,borderColor:UIColor.white)
//        }
//        return cell
//    }
//}
//
//extension CalendarView: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,minimumLineSpacingForSectionAt section:Int) -> CGFloat{
//        return cellMargin
//    }
//
//    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,minimumInteritemSpacingForSectionAt section:Int) -> CGFloat{
//        return cellMargin
//    }
//
//
//    //セルのサイズを設定
//    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAt indexPath:IndexPath) -> CGSize{
//        let numberOfMargin:CGFloat = 8.0
//        let width:CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin) / CGFloat(daysPerWeek)
//        let height:CGFloat = width * 2.0
//        return CGSize(width:width,height:height)
//    }
//}
//



import UIKit

@objc protocol CalendarViewDelegate {
    func changeMonth(_ text:String)
}

class CalendarView: UICollectionView{
    
    //セルの余白
    let cellMargin:CGFloat = 2.0
    let dateManager = DateManager()
    //１週間に何日あるか(行数)
    let daysPerWeek:Int = 7
    var startDate:Date!
    
    var calendarDelegate:CalendarViewDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(CalendarCell.self, forCellWithReuseIdentifier: "collectCell")
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = .white
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleCell = self.visibleCells.filter{
            return self.bounds.contains($0.frame)
        }
        
        var visibleCellTag = Array<Int>()
        if(visibleCell != []){
            visibleCellTag = visibleCell.map{$0.tag}
            //月は奇数か偶数か　割り切れるものだけを取り出す
            let even = visibleCellTag.filter{
                return $0 % 2 == 0
            }
            let odd = visibleCellTag.filter{
                return $0 % 2 != 0
            }
            //oddかevenの多い方を返す
            let month = even.count >= odd.count ? even[0] : odd[0]
            
            //桁数によって分岐
            let digit = numberOfDigit(month: month)
            var text = ""
            if(digit == 5){
                text = String(month / 10) + "年" + String(month % 10) + "月"
            }else if(digit == 6){
                text = String(month / 100) + "年" + String(month % 100) + "月"
            }
            if calendarDelegate != nil {
                calendarDelegate.changeMonth(text)
            }
        }
    }
    
    func numberOfDigit(month:Int) -> Int{
        var num = month
        var cnt = 1
        while(num / 10 != 0){
            cnt = cnt + 1
            num = num / 10
        }
        return cnt
        
    }
    
}

extension CalendarView:UICollectionViewDelegate {
    //選択した時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension CalendarView: UICollectionViewDataSource {
    
    //セクションの数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //セルの総数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateManager.cellCount(startDate:startDate)
    }
    
    //セルの設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CalendarCell = collectionView.dequeueReusableCell(withReuseIdentifier:"collectCell",for:indexPath as IndexPath) as! CalendarCell
        
        //土曜日は赤　日曜日は青　にテキストカラーを変更する
        if(indexPath.row % 7 == 0){
            cell.textLabel.textColor = UIColor.red
        }else if(indexPath.row % 7 == 6){
            cell.textLabel.textColor = UIColor.blue
        }else{
            cell.textLabel.textColor = UIColor.gray
        }
        cell.tag = Int(dateManager.monthTag(row:indexPath.row,startDate:startDate))!
        //セルの日付を取得し
        cell.textLabel.text = dateManager.conversionDateFormat(row:indexPath.row,startDate:startDate)
        
        //セルの日付を取得
        let day = Int(dateManager.conversionDateFormat(row:indexPath.row,startDate:startDate!))!
        if(day == 1){
            cell.textLabel.border(positions:[.Top,.Left],borderWidth:1,borderColor:UIColor.black)
        }else if(day <= 7){
            cell.textLabel.border(positions:[.Top],borderWidth:1,borderColor:UIColor.black)
        }else{
            cell.textLabel.border(positions:[.Top],borderWidth:0,borderColor:UIColor.white)
        }
        return cell
    }
}

extension CalendarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,minimumLineSpacingForSectionAt section:Int) -> CGFloat{
        return cellMargin
    }
    
    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,minimumInteritemSpacingForSectionAt section:Int) -> CGFloat{
        return cellMargin
    }
    
    
    //セルのサイズを設定
    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAt indexPath:IndexPath) -> CGSize{
        let numberOfMargin:CGFloat = 8.0
        let width:CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin) / CGFloat(daysPerWeek)
        let height:CGFloat = width * 2.0
        return CGSize(width:width,height:height)
    }
}

