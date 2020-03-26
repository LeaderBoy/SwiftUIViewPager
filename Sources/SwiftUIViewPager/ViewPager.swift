//
//  PageView.swift
//  SwiftUICalendar
//
//  Created by 杨志远 on 2020/3/21.
//  Copyright © 2020 iOS Developer. All rights reserved.
//
import SwiftUI

@available(iOS 13.0, *)
public struct ViewPager<Page: View>: View {
    public var viewControllers: [UIHostingController<Page>]
    
    @ObservedObject public var pageManager : PageManager
    
    public init(pageManager : PageManager,views: [Page]) {
        self.pageManager = pageManager
        self.viewControllers = views.map { UIHostingController(rootView: $0) }
    }

    public var body: some View {
        PageViewController(controllers: viewControllers, pageManager: pageManager)
    }
}

@available(iOS 13.0, *)
struct ViewPager_Previews: PreviewProvider {
    static var previews: some View {
        ViewPager(pageManager: PageManager(), views: [Color.red,Color.green])
            .aspectRatio(3/2, contentMode: .fit)
    }
}
