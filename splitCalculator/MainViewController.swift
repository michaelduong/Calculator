//
//  MainViewController.swift
//  splitCalculator
//
//  Created by Michael Duong on 2/19/18.
//  Copyright © 2018 Turnt Labs. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var subtotalText: BillAmountTextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var perPersonLabel1: UILabel!
    @IBOutlet weak var perPersonLabel2: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var salesTaxLabel: UILabel!
    @IBOutlet weak var tipAmountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subtotalText.becomeFirstResponder()
        
        perPersonLabel1.isHidden = true
        perPersonLabel2.isHidden = true
        
        subtotalText.calculateButtonAction = {
            self.calculate()
        }
    }
    
    func calculate() {
        guard let subtotalText = self.subtotalText.text,
            let subtotal = Double(subtotalText) else {
                return
        }
        
        let roundedSubtotal = (100 * subtotal).rounded() / 100
        
        guard let tipPercentText = self.tipLabel.text,
            let tipPercent = Double(tipPercentText.replacingOccurrences(of: "%", with: "")) else {
                return
        }
        let convertedTipPercent = tipPercent / 100
        let tipAmount = roundedSubtotal * convertedTipPercent
        let roundedTipAmount = (100 * tipAmount).rounded() / 100
        
        let salesTax = 0.0685
        let salesTaxAmount = roundedSubtotal * salesTax
        let roundedSalesTaxAmount = (100 * salesTaxAmount).rounded() / 100
        
        let totalAmount = roundedSubtotal + roundedSalesTaxAmount + roundedTipAmount
        
        guard let partyText = self.partyLabel.text else { return }
        let partyTotal = Double(partyText)
        let individualAmount: Double
        if partyTotal! > 1 {
            self.perPersonLabel1.isHidden = false
            self.perPersonLabel2.isHidden = false
            individualAmount = totalAmount / partyTotal!
            
        } else {
            self.perPersonLabel1.isHidden = true
            self.perPersonLabel2.isHidden = true
            individualAmount = totalAmount
        }
        let individualTipAmount = roundedTipAmount / partyTotal!
        
        self.tipAmountLabel.text = "$" + String(format: "%.2f", individualTipAmount)
        self.salesTaxLabel.text = "$" + String(format: "%.2f", roundedSalesTaxAmount)
        self.totalLabel.text = "$" + String(format: "%.2f", individualAmount)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func tipValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        tipLabel.text = "\(currentValue)%"
    }
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        partyLabel.text = Int(sender.value).description
    }
    
}
