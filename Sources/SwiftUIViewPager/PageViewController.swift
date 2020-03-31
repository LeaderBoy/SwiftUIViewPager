//
//  PageViewController.swift
//  SwiftUICalendar
//
//  Created by 杨志远 on 2020/3/21.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import SwiftUI
import UIKit

@available(iOS 13.0, *)
struct PageViewController: UIViewControllerRepresentable {
    var controllers: [UIViewController]
    @ObservedObject var pageManager : PageManager

    var enableRepeat : Bool  {
        return pageManager.enableRepeat
    }
    var enableSwipGesture : Bool  {
        return pageManager.enableSwipGesture
    }
    var disableBounce : Bool {
        return pageManager.disableBounce
    }
    var disableReuse : Bool {
        return pageManager.disableReuse
    }
    var currentPage: Int {
        return pageManager.currentPage
    }
    var direction : UIPageViewController.NavigationDirection {
        return pageManager.direction
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIPageViewController {
        let page = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        page.delegate = context.coordinator
        
        for view in page.view.subviews {
           if let scrollView = view as? UIScrollView {
                scrollView.delegate = context.coordinator
           }
        }
        
        if enableSwipGesture {
            page.dataSource = context.coordinator
        }
        return page
    }

    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        let coordinator = context.coordinator
        if coordinator.last == currentPage {
            return
        }
        if disableReuse {
            pageViewController.setViewControllers([self.controllers[0]], direction: direction, animated: true)
        } else {
            pageViewController.setViewControllers([self.controllers[currentPage]], direction: direction, animated: true)
        }
        coordinator.last = currentPage
    }

    class Coordinator: NSObject {
        var parent: PageViewController
        var last : Int = NSNotFound
        
        var disableDounce : Bool {
            return parent.disableBounce
        }
        
        var currentPage : Int {
            return parent.currentPage
        }

        init(_ pageViewController: PageViewController) {
            self.parent = pageViewController
        }
    }
}

/// MARK: UIPageViewControllerDataSource
@available(iOS 13.0, *)
extension PageViewController.Coordinator : UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        guard let index = parent.controllers.firstIndex(of: viewController) else {
            return nil
        }
        if index == 0 {
            if self.parent.enableRepeat {
                return parent.controllers.last
            } else {
                return nil
            }
        }
        return parent.controllers[index - 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let index = parent.controllers.firstIndex(of: viewController) else {
            return nil
        }
        if index + 1 == parent.controllers.count {
            if self.parent.enableRepeat {
                return parent.controllers.first
            } else {
                return nil
            }
        }
        return parent.controllers[index + 1]
    }
}
/// MARK: UIPageViewControllerDelegate
@available(iOS 13.0, *)
extension PageViewController.Coordinator : UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
            let visibleViewController = pageViewController.viewControllers?.first,
            let index = parent.controllers.firstIndex(of: visibleViewController)
        {
            last = index
            parent.pageManager.currentPage = index
        }
    }
}

/// MARK: UIScrollViewDelegate
@available(iOS 13.0, *)
extension PageViewController.Coordinator : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        disableBounceAction(in: scrollView)
        progressAction(in: scrollView)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        disableBounceAction(in: scrollView)
    }
    
    func progressAction(in scrollView : UIScrollView) {
        let width = scrollView.frame.size.width
        if width == 0 {
            return
        }
        let offsetX = scrollView.contentOffset.x
        let progress = (offsetX - width) / width
        self.parent.pageManager.progress = progress
    }
    
    func disableBounceAction(in scrollView : UIScrollView) {
        if disableDounce {
            let count = self.parent.controllers.count
            if currentPage == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width {
                scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
            } else if currentPage == count - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width {
                scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
            }
        }
    }
}
