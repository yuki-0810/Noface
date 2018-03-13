//
//  PageMenuOption.swift
//  NoFace
//
//  Created by 阿部悠輝 on 2017/08/07.
//  Copyright © 2017年 yuki.abe. All rights reserved.
//

import Foundation
import PagingMenuController

struct PostShowsPagingOptions: PagingMenuControllerCustomizable {
    internal var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    fileprivate var pagingControllers: [UIViewController] {
        
        let vc1 = HomeViewController()
        let vc2 = FollowShowViewController()
        return [vc1, vc2]
    }
    
    fileprivate struct MenuOptions: MenuViewCustomizable {
        var displayMode: MenuDisplayMode {
            return .segmentedControl
            
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2()]
        }
        
        var focusMode: MenuFocusMode {
            return .underline(height: 1.0, color: UIColor.lightGray, horizontalPadding: 0.0, verticalPadding: 0.0)
        }
        
        var menuPosition: MenuPosition {
            return .top
        }
    }
    
    fileprivate struct MenuItem1: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            
            return .text(title: MenuItemText(text: "All Show",selectedColor:UIColor.darkGray))
        }
    }
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "Follow Show",selectedColor:UIColor.darkGray))
        }
    }
}
