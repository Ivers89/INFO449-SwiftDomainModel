struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//

import Foundation

public struct Money {
    
    var amount: Int
    var currency: String
    
    enum MoneyError: Error {
        case invalidCurrency(String)
    }
    
    init(amount: Int, currency: String) {
        self.amount = max(0, amount)
        self.currency = currency.uppercased()
    }
    
    func convert(_ targetCurrency: String) -> Money {

        let amountInUSD: Double
        switch currency {
        case "USD":
            amountInUSD = Double(amount)
        case "GBP":
            amountInUSD = Double(amount) * 2.0
        case "EUR":
            amountInUSD = Double(amount) / 1.5
        case "CAN":
            amountInUSD = Double(amount) / 1.25
        default:
            print("invalid currency: \(currency)")
            return self
        }
        
        let targetAmount: Int
        switch targetCurrency {
        case "USD":
            targetAmount = Int(amountInUSD.rounded())
        case "GBP":
            targetAmount = Int((amountInUSD * 0.5).rounded())
        case "EUR":
            targetAmount = Int((amountInUSD * 1.5).rounded())
        case "CAN":
            targetAmount = Int((amountInUSD * 1.25).rounded())
        default:
            print("invalid currency: \(targetCurrency)")
            return self
        }

        return Money(amount: targetAmount, currency: targetCurrency)
    }
    
    func add(_ other: Money) -> Money {
        let converted = self.convert(other.currency)
        let sum = converted.amount + other.amount
        print(Money(amount: Int(sum), currency: currency))
        return Money(amount: Int(sum), currency: other.currency)
    }

    func subtract(_ other: Money) -> Money {
        let converted = self.convert(other.currency)
        let difference = converted.amount - other.amount
        if difference < 0 {
            return self
        } else {
            return Money(amount: difference, currency: other.currency)
        }
    }
}

////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    var title: String
    var type: JobType
    
    init (title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    func calculateIncome (_ args: Int = 2000) -> Int {
        switch type {
        case .Hourly(let wage):
            return Int(wage * Double(args))
        case .Salary (let salary):
            return Int(salary)
            
        }
    }
    
    public func raise(byAmount amount: Double) {
        switch type {
        case .Hourly(let wage):
            type = .Hourly(wage + amount)
        case .Salary(let yearly):
            type = .Salary(yearly + UInt(amount))
        }
    }

    public func raise(byPercent percent: Double) {
        switch type {
        case .Hourly(let salary):
            type = .Hourly(salary * (1.0 + percent))
        case .Salary(let yearly):
            let newSalary = Double(yearly) * (1.0 + percent)
            type = .Salary(UInt(newSalary.rounded()))
        }
    }
    
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String {
        didSet {
            if firstName.isEmpty {
                firstName = "Default"
            }
        }
    }
    
    var lastName: String {
        didSet {
            if lastName.isEmpty {
                lastName = "Default"
            }
        }
    }
    var age: Int {
        didSet {
            if age < 0 {
                age = oldValue
            }
        }
    }
    var job: Job? {
        didSet {
            if age < 16 {
                job = nil
            } else if let job = job {
                if case .Hourly(let wage) = job.type, wage < 0 {
                    self.job = nil
                } else {
                    print("Valid job assigned")
                }
            }
        }
    }
    
    var spouse: Person? {
        didSet {
            if age < 18 || spouse === self {
                spouse = nil
            }
        }
    }
    
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName.isEmpty ? "Default" : firstName
        self.lastName = lastName.isEmpty ? "Default" : lastName
        self.age = age
    }
    
    func toString() -> String {
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job?.title ?? "nil") spouse:\(spouse?.firstName ?? "nil")]"
    }
    
}

////////////////////////////////////
// Family
//
public class Family {
    var members: [Person] = []
    
    init(spouse1: Person, spouse2: Person) {
        if (spouse1.spouse == nil && spouse2.spouse == nil) {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            self.members = [spouse1,spouse2]
        } else {
            fatalError("One or Both of the spouses are cheating!")
        }
    }
    
    public func householdIncome() -> Int {
        var total = 0
        for member in members {
            if let job = member.job {
                total += job.calculateIncome()
            }
        }
        return total
    }
    
    func haveChild(_ child: Person) -> Bool {
            let parent1 = members[0]
            let parent2 = members[1]

            if (parent1.age >= 21 || parent2.age >= 21) {
                members.append(child)
                return true
            }

            return false
        }
    
    
}
