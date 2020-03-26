//
//  PageControl.swift
//  SwiftUIViewPager
//
//  Created by 杨 on 2020/3/26.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import SwiftUI
import UIKit

@available(iOS 13.0, *)
public struct PageControl: UIViewRepresentable {
    
    public var numberOfPages : Int
    @Binding public var currentPage : Int
    
    public var tintColor : UIColor = .gray
    public var currentTintColor : UIColor = .white
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    public init(numberOfPages: Int, currentPage: Binding<Int>) {
        self.numberOfPages = numberOfPages
        self._currentPage = currentPage
    }

    
    public func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        control.addTarget(context.coordinator, action: #selector(Coordinator.updateCurrentPage(sender:)), for: .valueChanged)
        control.pageIndicatorTintColor = tintColor
        control.currentPageIndicatorTintColor = currentTintColor
        return control
    }
    
    public func updateUIView(_ uiView: UIPageControl, context: Context) {
        let last = context.coordinator.last
        if last == currentPage {
            return
        }
        uiView.currentPage = currentPage
    }
    
    public class Coordinator: NSObject {
        var control : PageControl
        var last : Int = NSNotFound
        
        init(_ control : PageControl) {
            self.control = control
        }
        
        @objc func updateCurrentPage(sender: UIPageControl) {
            control.currentPage = sender.currentPage
        }
    }
}

@available(iOS 13.0, *)
extension PageControl : Buildable {
    public func pageIndicatorTintColor(_ value : UIColor)-> Self {
        mutating(keyPath: \.tintColor, value: value)
    }
    
    public func currentPageIndicatorTintColor(_ value : UIColor)-> Self {
        mutating(keyPath: \.tintColor, value: value)
    }
}
