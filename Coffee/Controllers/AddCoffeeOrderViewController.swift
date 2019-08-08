//
//  AddCoffeeOrderViewController.swift
//  Coffee
//
//  Created by Niraj Jha on 06/08/19.
//  Copyright © 2019 Niraj Jha. All rights reserved.
//

import UIKit

protocol AddCoffeeOrderDelegate: class {
    func addCoffeeOrderViewControllerDidSave(order: Order, controller: UIViewController)
    func addCoffeeOrderViewControlleridClose(controller: UIViewController)
}

class AddCoffeeOrderViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    private var coffeeSizeSegmentedControl: UISegmentedControl!
    private var addCoffeeOrderViewModel = AddCoffeeOrderViewModel()
    weak var delegate: AddCoffeeOrderDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        coffeeSizeSegmentedControl = UISegmentedControl(items: addCoffeeOrderViewModel.sizes)
        coffeeSizeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(coffeeSizeSegmentedControl)
        coffeeSizeSegmentedControl.topAnchor.constraint(
            equalTo: tableView.bottomAnchor, constant: 20).isActive = true
        coffeeSizeSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @IBAction func save() {
        
        let name = nameTextField.text
        let email = emailTextField.text
        
        let selectedSize = coffeeSizeSegmentedControl.titleForSegment(at: coffeeSizeSegmentedControl.selectedSegmentIndex)
        
        guard let indexPath = tableView.indexPathForSelectedRow else { fatalError("Error in selecting the Coffee Type") }
        
        addCoffeeOrderViewModel.name = name
        addCoffeeOrderViewModel.email = email
        addCoffeeOrderViewModel.selectedSize = selectedSize
        addCoffeeOrderViewModel.selectedType = addCoffeeOrderViewModel.types[indexPath.row]
        
        Webservice().load(resource: Order.create(vm: self.addCoffeeOrderViewModel)) { result in
            switch result {
            case .success(let order):
                if let order = order, let delegate = self.delegate {
                    DispatchQueue.main.async {
                        delegate.addCoffeeOrderViewControllerDidSave(order: order, controller: self)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
    }
    
    @IBAction func close() {
        
        if let delegate = delegate {
            delegate.addCoffeeOrderViewControlleridClose(controller: self)
        }
    }

}

extension AddCoffeeOrderViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addCoffeeOrderViewModel.types.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeetypeTableViewCell", for: indexPath)
        cell.textLabel?.text = addCoffeeOrderViewModel.types[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
}
