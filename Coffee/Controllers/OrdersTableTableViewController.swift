//
//  OrdersTableTableViewController.swift
//  Coffee
//
//  Created by Niraj Jha on 06/08/19.
//  Copyright © 2019 Niraj Jha. All rights reserved.
//

import UIKit

class OrdersTableTableViewController: UITableViewController, AddCoffeeOrderDelegate {

    var orderlistViewModel = OrderListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        populateOrders()

    }
    
    private func populateOrders() {
        
        Webservice().load(resource: Order.all) { [weak self] result in
            switch result {
                case .success(let orders):
                    print(orders)
                    self?.orderlistViewModel.ordersViewModel = orders.map(OrderViewModel.init)
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
        let addCoffeeOrderVC = navC.viewControllers.first as? AddCoffeeOrderViewController
        else {
            fatalError("Error performing segue")
        }
        
        addCoffeeOrderVC.delegate = self
    }
    
    //MARK:- Delegate methods AddCoffeeOrderDelegate
    
    func addCoffeeOrderViewControllerDidSave(order: Order, controller: UIViewController) {
         controller.dismiss(animated: true, completion: nil)
        
        let orderVM = OrderViewModel(order: order)
        orderlistViewModel.ordersViewModel.append(orderVM)
        self.tableView.insertRows(at: [IndexPath(row: orderlistViewModel.ordersViewModel.count - 1, section: 0)], with: .automatic)
    }
    
    func addCoffeeOrderViewControlleridClose(controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension OrdersTableTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderlistViewModel.ordersViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = orderlistViewModel.orderViewModel(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)
        cell.textLabel?.text = vm.type
        cell.detailTextLabel?.text = vm.size
        return cell
    }
}
