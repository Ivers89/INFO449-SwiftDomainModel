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
        self.amount = amount
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
    
    func add(_ args: Money) -> Money {
        let converted = args.convert(currency)
        let sum = amount + converted.amount
        return Money(amount: sum, currency: currency)
    }

    func subtract(_ args: Money) -> Money {
        let converted = args.convert(currency)
        let difference = amount - converted.amount
        return Money(amount: difference, currency: currency)
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
}

////////////////////////////////////
// Person
//
public class Person {
}

////////////////////////////////////
// Family
//
public class Family {
}
