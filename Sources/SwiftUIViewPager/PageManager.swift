//
//  PageManager.swift
//  SwiftUICalendar
//
//  Created by 杨志远 on 2020/3/22.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import SwiftUI
import Combine

@available(iOS 13.0, *)
public class PageManager : ObservableObject {
    @Published public var currentPage : Int = 0 {
        willSet {
            if newValue >= currentPage {
                direction = .forward
            } else {
                direction = .reverse
            }
            objectWillChange.send()
        }
        
        didSet {
            onPageChange?(currentPage,direction)
        }
    }
            
    public var direction : UIPageViewController.NavigationDirection = .forward
    
    @Published public var progress : CGFloat = 0
    
    /// will not work together with disableBounce = true
    public var enableRepeat : Bool = false
    /// if set false
    /// swip gesture will not work
    public var enableSwipGesture : Bool = true
    /// if set true
    /// disable bounce for PageViewController's scrollView
    public var disableBounce : Bool = false
    /// if set true
    /// only one viewController in PageViewController at the same time
    public var disableReuse : Bool = false
    
    /// Bug: Prevent `ObservableObject` not call the updateView of `UIViewControllerRepresentable`
    /// https://stackoverflow.com/questions/58142942/swiftui-not-refresh-my-custom-uiview-with-uiviewrepresentable-observableobject
    public var onPageChange: ((Int,UIPageViewController.NavigationDirection)->Void)?
    
    public init(currentPage : Int = 0,direction : UIPageViewController.NavigationDirection = .forward,enableRepeat : Bool = false,enableSwipGesture : Bool = true, disableBounce : Bool = false,disableReuse : Bool = false) {
        self.currentPage = currentPage
        self.direction = direction
        self.enableRepeat = enableRepeat
        self.enableSwipGesture = enableSwipGesture
        self.disableBounce = disableBounce
        self.disableReuse = disableReuse
    }
}

