/*
  File name: ViewController.swift
  App description : Calculator App Basic and additional Functionality
  Author's name: Satender Yadav, Apeksha Parmar
  StudentID: 301293305,301205325
  Date: 10/23/22.
  Version: 1.0
 */

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var InputLabel: UILabel!
  
    @IBOutlet weak var ResultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //this method enables user input based on numbers and operators
    @IBAction func NumberButton_Pressed(_ sender: UIButton) {
        let button = sender as UIButton
        let buttonValue = button.titleLabel?.text
        
        switch (buttonValue)
        {
        case ".":
            if(!InputLabel.text!.contains("."))
            {
                InputLabel.text?.append(buttonValue!)
            }
        case "=":
            var providedString: String = String(InputLabel.text!)         // Get user input
            var result = basicAndScientificCalc(var: providedString)     // call calculate to get expression result
            ResultLabel.text = formatResult(result: result)              // format and display result
        case "+/-":
            toggleButton()
        default:
            InputLabel.text == "0" ? InputLabel.text = buttonValue : InputLabel.text?.append(buttonValue!)
        }
    }
        
    
    // Perform scientic and basic calculator operations
    func basicAndScientificCalc(var providedString: String) -> Double {
        var formatInput = providedString.map { "\($0)" }.joined(separator: " ") // format by adding space between
        let inputArray = formatInput.split(separator: " ").map(String.init)
       
        switch providedString {
        case _ where providedString.contains("sin"):
            let value = Double(inputArray[4] + inputArray[5])
            return Double(sin(value ?? 0))
        case _ where providedString.contains("cos"):
            let value = Double(inputArray[4] + inputArray[5])
            return Double(cos(value ?? 0))
        case _ where providedString.contains("tan"):
            let value = Double(inputArray[4] + inputArray[5])
            return Double(tan(value ?? 0))
        case _ where providedString.contains("Rand"):
            return Double(Double.random(in: 1...100))
        case _ where providedString.contains("x^2"):
            return Double((Double(inputArray[0]) ?? 0) * (Double(inputArray[0]) ?? 0))
        case _ where providedString.contains("√x"):
            let value = Double(inputArray[2] + inputArray[3])
            return Double(sqrt(value ?? 0))
        default:
            return calculate(var: formatInput)  // Calculate basic operations
           }
    }
    
    
    //this method toggles + and - button by replacing the character
    func toggleButton() {
        if(InputLabel.text?.description.last == "+")
        {
            if let range = InputLabel.text?.description.range(of: "+") {
                let updatedString = InputLabel.text?.description.replacingCharacters(in: range, with: "-")
                InputLabel.text = updatedString
                
            }
        } else if (InputLabel.text?.description.last == "-") {
            if let range = InputLabel.text?.description.range(of: "-") {
                let updatedString = InputLabel.text?.description.replacingCharacters(in: range, with: "+")
                InputLabel.text = updatedString
                
            }
        }
    }
    
    
    // this method clears single and all value in input label, result label
    @IBAction func ExtraButton_Pressed(_ sender: UIButton) {
        let button = sender as UIButton
        let buttonText = button.titleLabel?.text
        switch buttonText
        {
        case "AC":
            ResultLabel.text = "0"
            InputLabel.text = "0"
            
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
    
    
    // Calculate given expression by parsing with stack structure
    func calculate(var providedExpression: String) -> Double {
        let inputValues = providedExpression.split(separator: " ").map(String.init)
        let stackOperand = CalculatorStack()
        let stackOperator = CalculatorStack()

        for (_, inputValue) in inputValues.enumerated() {
            if inputValue.isTypeNumber {
                stackOperand.pushValue(value: inputValue)  // Add number input
            }
            if inputValue.isTypeOperator {
                while stackOperator.lookValue.OperatorPrecedence <= inputValue.OperatorPrecedence {  // stack operators based on precedence
                    if !stackOperator.empty {
                        var calcResult = 0.0
                        switch stackOperator.lookValue {
                        case "+":
                            calcResult = Double(stackOperand.popValue())! + Double(stackOperand.popValue())!
                        case "-":
                            calcResult = Double(stackOperand.stackValue[stackOperand.stackValue.count-2])! - Double(stackOperand.popValue())!
                            stackOperand.popValue()
                        case "x":
                            calcResult = Double(stackOperand.popValue())! * Double(stackOperand.popValue())!
                        case "/":
                            calcResult = Double(stackOperand.stackValue[stackOperand.stackValue.count-2])! / Double(stackOperand.popValue())!
                            stackOperand.popValue()
                        case "%":
                            calcResult = Double(stackOperand.popValue())! / 100
                            stackOperand.popValue()
                        case "π":
                            calcResult = Double(stackOperand.popValue())! * 3.141592653589793238
                            stackOperand.popValue()
                        default:
                            calcResult = 0
                        }
                        stackOperator.popValue()
                        stackOperand.pushValue(value: "\(calcResult)")
                    }
                }
                stackOperator.pushValue(value: inputValue)
            }
        }

        while !stackOperator.empty {          // perform operations when there are operators
            var calcResult = 0.0
            switch stackOperator.lookValue {
            case "+":
                calcResult = Double(stackOperand.popValue())! + Double(stackOperand.popValue())!
            case "-":
                calcResult = Double(stackOperand.stackValue[stackOperand.stackValue.count-2])! - Double(stackOperand.popValue())!
                stackOperand.popValue()
            case "x":
                calcResult = Double(stackOperand.popValue())! * Double(stackOperand.popValue())!
            case "/":
                calcResult = Double(stackOperand.stackValue[stackOperand.stackValue.count-2])! / Double(stackOperand.popValue())!
                stackOperand.popValue()
            case "%":
                calcResult = Double(stackOperand.popValue())! / 100
                stackOperand.popValue()
            case "π":
                calcResult = Double(stackOperand.popValue())! * 3.141592653589793238
                stackOperand.popValue()
            default:
                calcResult = 0
            }
            stackOperator.popValue()
            stackOperand.pushValue(value: "\(calcResult)")
        }

        return Double(stackOperand.popValue())!
   }
    
    // This method formats decimal to 8 places for result value
    func formatResult(result:Double) -> String
    {
        if(result.description.count > 8)
        {
            return String(round(100000000 * result) / 100000000)
        } else if (result.truncatingRemainder(dividingBy: 1) == 0)
        {
            return String(format: "%.0f", result)
        } else {
            return String(result)
        }
    }
}


/*
 * class CalculatorStack - to perform parsing of expressions
 * have basic function like pop, push, lookValue, empty
 */
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

//Formated string extension to return value based on switch case
extension String {
    var OperatorPrecedence: Int {
        get {
            switch self {
                case "+":
                return 1
                case "-":
                return 1
                case "x":
                return 0
                case "/":
                return 0
                case "%":
                return 0
                case "π":
                return 0
            default:
                return 100
            }
        }
    }
    
    var isTypeNumber: Bool {
        get {
            return !isTypeOperator
        }
    }
    
    var isTypeOperator: Bool {
        get {
            return ("+-x/%π" as NSString).contains(self)
        }
    }
}
