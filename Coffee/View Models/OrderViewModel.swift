//
//  OrderViewModel.swift
//  Coffee
//
//  Created by Niraj Jha on 06/08/19.
//  Copyright © 2019 Niraj Jha. All rights reserved.
//

import Foundation

class OrderListViewModel {
    var ordersViewModel: [OrderViewModel]
    
    init() {
        self.ordersViewModel = [OrderViewModel]()
    }
}

extension OrderListViewModel {
    func orderViewModel(at index: Int) -> OrderViewModel {
        return self.ordersViewModel[index]
    }
}

struct OrderViewModel {
    var order: Order
}

extension OrderViewModel {
    
    var name : String {
        return order.name
    }
    
    var email: String {
        return order.email
    }
    
    var type: String {
        return order.type.rawValue.capitalized
    }
    
    var size: String {
        return order.size.rawValue.capitalized
    }
    
   
    
}
