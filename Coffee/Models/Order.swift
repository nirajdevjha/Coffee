//
//  Order.swift
//  Coffee
//
//  Created by Niraj Jha on 06/08/19.
//  Copyright © 2019 Niraj Jha. All rights reserved.
//

import Foundation

enum CoffeType: String, Codable, CaseIterable {
    case latte
    case espressino
    case cortado
    case cappucino
}

enum CoffeSize: String, Codable, CaseIterable {
    case small
    case medium
    case large
}

struct Order: Codable {
    let name: String
    let email: String
    let type: CoffeType
    let size: CoffeSize
}

extension Order {
    
    static var all: Resource<[Order]> = {
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            fatalError("URL is incorrect")
        }
        return Resource<[Order]>(url: url)
    }()
    
    static func create(vm: AddCoffeeOrderViewModel) -> Resource<Order?> {
        let order = Order(vm)
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            fatalError("URL is incorrect")
        }
        
         guard let data = try? JSONEncoder().encode(order) else {
            fatalError("Error encoding order!")
        }
        
        var resource = Resource<Order?>(url: url)
        resource.httpMethod = .post
        resource.body = data
        
        return resource
        
        
    }
}

extension Order {

    init? (_ vm: AddCoffeeOrderViewModel ) {
        guard let name = vm.name,
        let email = vm.email,
            let selectedTpe = CoffeType(rawValue: vm.selectedType?.lowercased() ?? ""),
            let selectedSize = CoffeSize(rawValue: vm.selectedSize?.lowercased() ?? "") else {
                return nil
        }
        self.name = name
        self.email = email
        self.type = selectedTpe
        self.size = selectedSize
        
    }
    
}
