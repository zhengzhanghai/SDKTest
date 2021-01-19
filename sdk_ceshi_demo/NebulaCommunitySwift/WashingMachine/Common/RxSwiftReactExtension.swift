//
//  RxSwiftReactExtension.swift
//  WashingMachine
//
//  Created by Harious on 2018/3/30.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import Foundation
import RxCocoa

#if os(iOS)
    
    import RxSwift
    import UIKit
    
    extension Reactive where Base: UIControl {
        
        /// Reactive wrapper for `TouchUpInside` control event.
        public var tap: ControlEvent<Void> {
            return controlEvent(.touchUpInside)
        }
    }
    
#endif



