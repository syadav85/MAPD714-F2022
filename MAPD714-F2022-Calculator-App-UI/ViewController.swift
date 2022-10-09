/*
  File name: ViewController.swift
  App description : Calculator App
  Author's name: Satender Yadav, Apeksha Parmar
  StudentID: 301293305,301205325
  Date: 9/23/22.
  Version: 1.0
 */

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var InputLabel: UILabel!
  
    @IBOutlet weak var ResultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func NumberButton_Pressed(_ sender: UIButton) {
        
        let button = sender as UIButton
                let buttonText = button.titleLabel?.text
                
                switch (buttonText)
                {
                case ".":
                    if(!InputLabel.text!.contains("."))
                    {
                        InputLabel.text?.append(buttonText!)
                    }
                case "=":
                    var providedText: String = String(InputLabel.text!)
                    print(providedText)
                    providedText = providedText.map { "\($0)" }.joined(separator: " ")
                    print(providedText)
                    InputLabel.text = providedText
                    var resultHere = calculate(var: providedText)
                    ResultLabel.text = String(format: "%.2f", resultHere)
                    print(resultHere)
                    
                default:
                    if(InputLabel.text == "0")
                    {
                        InputLabel.text = buttonText
                    }
                    else
                    {
                        InputLabel.text?.append(buttonText!)
                    }
                    
                }

    }
    
    @IBAction func ExtraButton_Pressed(_ sender: UIButton) {
        
        let button = sender as UIButton
                let buttonText = button.titleLabel?.text
                switch buttonText
                {
                case "AC":
                    ResultLabel.text = "0"
                    InputLabel.text = "0"
//                    lhs = 0.0
//                    rhs = 0.0
//                    haveLHS = false
//                    haveRHS = false
//                    inputReady = true
//                    activeOperator = ""
                default:
                    if(InputLabel.text!.count == 1)
                    {
                        InputLabel.text = "0"
                    }
                    else
                    {
                        InputLabel.text?.removeLast()
                    }
                }

    }
    
    func calculate(var expression: String) -> Double {
        var inputValues = expression.split(separator: " ").map(String.init)
        var stackOperand = CalculatorStack()
        var stackOperator = CalculatorStack()

//        var tokens: [String] = Array(arrayLiteral: expression)
        for (index, inputValue) in inputValues.enumerated() {
            
            if inputValue.isNumber {
                stackOperand.pushValue(value: inputValue)
            }

            if inputValue.isOperator {
                while stackOperator.lookValue.OperatorPrecedence <= inputValue.OperatorPrecedence {
                    if !stackOperator.empty {
                        var res = 0.0
                        switch stackOperator.lookValue {
                        case "+":
                            res = Double(stackOperand.popValue())! + Double(stackOperand.popValue())!
                        case "-":
                            res = Double(stackOperand.stackValue[stackOperand.stackValue.count-2])! - Double(stackOperand.popValue())!
                            stackOperand.popValue()
                        case "*":
                            res = Double(stackOperand.popValue())! * Double(stackOperand.popValue())!
                        case "/":
                            res = Double(stackOperand.stackValue[stackOperand.stackValue.count-2])! / Double(stackOperand.popValue())!
                            stackOperand.popValue()
                        case "%":
                            res = Double(stackOperand.popValue())! / 100
                            stackOperand.popValue()
                        default:
                            res = 0
                        }
                        stackOperator.popValue()
                        stackOperand.pushValue(value: "\(res)")
                    }
                }
                stackOperator.pushValue(value: inputValue)
            }

        }

        while !stackOperator.empty {
            var calcResult = 0.0
            switch stackOperator.lookValue {
            case "+":
                calcResult = Double(stackOperand.popValue())! + Double(stackOperand.popValue())!
            case "-":
                calcResult = Double(stackOperand.stackValue[stackOperand.stackValue.count-2])! - Double(stackOperand.popValue())!
                stackOperand.popValue()
            case "*":
                calcResult = Double(stackOperand.popValue())! * Double(stackOperand.popValue())!
            case "/":
                calcResult = Double(stackOperand.stackValue[stackOperand.stackValue.count-2])! / Double(stackOperand.popValue())!
                stackOperand.popValue()
            case "%":
                calcResult = Double(stackOperand.popValue())! / 100
                stackOperand.popValue()
            default:
                calcResult = 0
            }
            stackOperator.popValue()
            stackOperand.pushValue(value: "\(calcResult)")
        }


        return Double(stackOperand.popValue())!

   }

    
}

class CalculatorStack {
    
    var stackValue: [String] = []
    var lookValue: String {
        get {
            if stackValue.count != 0 {
                return stackValue[stackValue.count-1]
            } else {
                return ""
            }
        }
    }
    
    func popValue() -> String {
        var initialValue = String()
        if stackValue.count != 0 {
            initialValue = stackValue[stackValue.count-1]
            stackValue.remove(at: stackValue.count-1)
        } else if stackValue.count == 0 {
            initialValue = ""
        }
        return initialValue
    }
    
    var empty: Bool {
        get {
            return stackValue.count == 0
        }
    }
    
    func pushValue(value: String) {
        stackValue.append(value)
    }
    
}

extension String {
    
    var OperatorPrecedence: Int {
        get {
            switch self {
                case "+":
                return 1
                case "-":
                return 1
                case "*":
                return 0
                case "/":
                return 0
                case "%":
                return 0
            default:
                return 100
            }
        }
    }
    
    var isOperator: Bool {
        get {
            return ("+-*/%" as NSString).contains(self)
        }
    }
    
    var isNumber: Bool {
        get {
            return !isOperator
        }
    }
    
}

