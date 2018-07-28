//
//  DateManager.swift
//  calendar syutoku
//
//  Created by 倉茂未央那 on 2018/07/07.
//  Copyright © 2018年 倉茂未央那. All rights reserved.
//

import UIKit

class DateManager {
    
    //現在の日付
    private var selectedDate = Date()
    
    //１週間に何日あるか
    private let daysPerWeek:Int = 7
    
    //セルの個数(nilが入らないようにする)
    private var numberOfItems:Int = 0
    
    /*      指定した月から現在の月までのセルの数を返すメソッド
     ** 引数　-> startDate 指定した月 カレンダーを始める月
     ** return -> セルの総数
     */
    func cellCount(startDate:Date) -> Int{
        //startDate(1番最初の日時)の年月を取り出す
        let startDateComponents = Calendar.current.dateComponents([.year ,.month], from:startDate)
        
        //currentDate(現在の日時)の年月を取り出す
        let currentDateComponents = Calendar.current.dateComponents([.year ,.month], from:selectedDate)
        
        //startDateとcurrentDateが何ヶ月離れているか fromとtoの差を取り出す
        let components = Calendar.current.dateComponents([.year,.month], from: startDateComponents, to: currentDateComponents)
        
        //startDateとcurrentDateが何ヶ月離れているか計算する
        let numberOfMonth = components.month! + components.year! * 12
        
        //１月ずつ何日あるか見ていく
        for i in 0 ..< numberOfMonth + 1{
            
            //monthをiに設定したdateComponentsを用意し、startDateからi月分足した日付(date)を取得する
            var dateComponents = DateComponents()
            dateComponents.month = i
            let date = Calendar.current.date(byAdding: dateComponents, to: startDate)
            
            //取得した月に週がいくつあるかを取得　in(その月)にof(週)が何個あるか
            let dateRange = Calendar.current.range(of: .weekOfMonth, in: .month, for: date!)
            
            //月の初日が何曜日かを取得 日曜日==1
            let ordinalityOfFirstDay = Calendar.current.ordinality(of: .day, in: .weekOfMonth, for: firstDateOfMonth(date:date!))
            
            //その月の始まりが日曜日かどうかで場合分け
            if(ordinalityOfFirstDay == 1 || i == 0){
                numberOfItems = numberOfItems + dateRange!.count * daysPerWeek
            }else{
                numberOfItems = numberOfItems + (dateRange!.count - 1) * daysPerWeek
            }
        }
        //セルの総数を返す
        return numberOfItems
    }
    
    
    
    /*      指定された月の初日を取得        */
    func firstDateOfMonth(date:Date) -> Date{
        //渡された日時から日にちを１にした日付を返す
        var components = Calendar.current.dateComponents([.year ,.month, .day], from:date)
        components.day = 1
        let firstDateMonth = Calendar.current.date(from: components)
        return firstDateMonth!
    }
    
    
    /*      表記する日にちの取得　週のカレンダー
     ** 引数　row          ->  UICollectionViewのIndexPath.row
     ** startDate    ->  指定した月　カレンダーを始める月
     ** return  date      ->  セルに入れる日付
     */
    func dateForCellAtIndexPathWeeks(row:Int,startDate:Date) -> Date{
        //始まりの日が週の何番目かを計算(日曜日が１) 指定した月の初日から数える
        let ordinalityOfFirstDay = Calendar.current.ordinality(of: .day, in: .weekOfMonth, for: firstDateOfMonth(date:startDate))
        var dateComponents = DateComponents()
        dateComponents.day = row - (ordinalityOfFirstDay! - 1)
        //計算して、基準の日から何日マイナス、加算するか dateComponents.day = -2 とか
        let date = Calendar.current.date(byAdding:dateComponents,to:firstDateOfMonth(date:startDate))
        return date!
    }
    
    
    
    /*      表記の変更 これをセルを作成する時に呼び出す
     引数  row         -> UICollectionViewのIndexPath.row
     startDate   -> 指定した月　カレンダーを始める月
     return  String   -> セルに入れる日付をString型にしたもの
     */
    func conversionDateFormat(row:Int,startDate:Date) -> String{
        let cellDate = dateForCellAtIndexPathWeeks(row: row,startDate:startDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: cellDate)
        
    }
    
    
    //月を返す
    func monthTag(row:Int,startDate:Date) -> String{
        let cellDate = dateForCellAtIndexPathWeeks(row: row,startDate:startDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "YM"
        return formatter.string(from:cellDate)
    }
    
    
}
