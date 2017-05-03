//
//  ViewController.swift
//  排序算法
//
//  Created by mac on 17/4/28.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let array:NSArray = [18,-54,23,-78,40,60,20,-20,-800]
        print("数组个数:",array.count,"\n")
        
        print("求最大和子数组")
        maxSubArray(array: array)
        let maxSumSubArray = findMaxSumSubArray(array: array, low: 0, high: array.count-1)
        print(maxSumSubArray,"\n")
        
        print("排序")
        let sortArray = insertionSort(array: array)
        print(sortArray)
        let sortArray1 = divideSort(array: array)
        print(sortArray1)
    }
    
    // 求连续子数组的最大和————分治策略(算法导论P40)
    func findMaxSumSubArray(array:NSArray, low:Int, high:Int) -> NSArray{
        if low == high {
            return [low,high,array[low]]
        }else{
            let mid = Int((low+high)/2)
            
            // 递归寻找
            let lResult = findMaxSumSubArray(array: array, low: low, high: mid)
            let rResult = findMaxSumSubArray(array: array, low: mid+1, high: high)
            
            let cResult = findMaxSumSubArray_Corssing(array: array, low: low, mid: mid, hiht: high)
            
            let lSum = lResult[2] as! Int
            let rSum = rResult[2] as! Int
            let cSum = cResult[2] as! Int
            if lSum >= rSum && lSum >= cSum {
                return lResult
            }else if rSum >= lSum && rSum >= cSum {
                return rResult
            }else{
                return cResult
            }
        }
    }
    func findMaxSumSubArray_Corssing(array:NSArray, low:Int, mid:Int, hiht:Int) -> NSArray {
        if low == hiht {
            return [low,hiht,array[low]]
        }
        
        var lIndex = mid
        var lMaxSum = 0, lSum = 0
        for i in stride(from: mid, through: low, by: -1) {
            let a = array[i] as! Int
            lSum = lSum + a
            if lSum > lMaxSum {
                lMaxSum = lSum
                lIndex = i
            }
        }
        
        var rIndex = mid+1
        var rMaxSum = 0, rSum = 0
        for j in stride(from: mid+1, through: hiht, by: +1) {
            let a = array[j] as! Int
            rSum = rSum + a
            if rSum > rMaxSum {
                rMaxSum = rSum
                rIndex = j
            }
        }
        
        return [lIndex,rIndex,lMaxSum+rMaxSum]
    }
    
    // 求连续子数组的最大和————动态规划
    func maxSubArray(array:NSArray){
        var maxSum = 0, sum = 0, leftIndex = 0, leftIndex_wait = 0, rightIndex = 0
        for i in 0..<array.count {
            let a = array[i] as! Int
            sum = sum + a
            if(sum > maxSum){
                maxSum = sum
                rightIndex = i
                if leftIndex_wait > leftIndex{
                    leftIndex = leftIndex_wait
                }
            }
            if(sum < 0) {
                sum = 0
                leftIndex_wait = i+1
            }
        }
        print("leftIndex:",leftIndex,"rightIndex:",rightIndex,"maxSum:",maxSum)
    }
    
    
    
    // 插入排序(算法导论P14)
    func insertionSort(array:NSArray) -> NSArray{
        let mArray = NSMutableArray.init(array: array)
        for i in 1..<mArray.count{
            let key = mArray[i] as! Int
            var j = i-1
            while (mArray[j] as! Int) > key{
                mArray[j+1] = mArray[j]
                j = j-1
                if j<0 {
                    break
                }
            }
            mArray[j+1] = key
        }
        return mArray
    }
    
    // 分治排序(算法导论P17)
    func divideSort(array:NSArray) -> NSArray{
        if array.count == 1 {
            return array
        }else{
            let mid = Int(array.count/2)-1
            
            let arrayLeft = array.subarray(with: NSRange.init(location: 0, length: mid+1)) as NSArray
            let arrayRight = array.subarray(with: NSRange.init(location: mid+1, length: array.count-arrayLeft.count)) as NSArray
            
            let sortArray1 = divideSort(array: arrayLeft) // 递归调用
            let sortArray2 = divideSort(array: arrayRight)
            
            // 讲两个排序好了的数组进行合并
            let count = sortArray1.count + sortArray2.count
            var array1_Index = 0, array2_Index = 0
            let sortArray = NSMutableArray.init()
            for _ in 0..<count {
                if array1_Index > sortArray1.count-1 {
                    sortArray.add(sortArray2[array2_Index])
                    array2_Index += 1
                    continue
                }
                if array2_Index > sortArray2.count-1 {
                    sortArray.add(sortArray1[array1_Index])
                    array1_Index += 1
                    continue
                }
                
                let a1 = sortArray1[array1_Index] as! Int
                let a2 = sortArray2[array2_Index] as! Int
                if a1 <= a2 {
                    sortArray.add(a1)
                    array1_Index += 1
                }else{
                    sortArray.add(a2)
                    array2_Index += 1
                }
            }
            return sortArray
        }
    }
    
    
    
}

