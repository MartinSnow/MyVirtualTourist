//
//  GCDBlackBox.swift
//  MyVirtualTourist
//
//  Created by Ma Ding on 17/9/16.
//  Copyright © 2017年 Ma Ding. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
