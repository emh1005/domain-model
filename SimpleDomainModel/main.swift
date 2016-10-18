//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
    return "I have been tested"
}

open class TestMe {
    open func Please() -> String {
        return "I have been tested"
    }
}

////////////////////////////////////
// Money
//

public struct Money {
    public var amount : Int
    public var currency : String
    private let exchangeRate : [String : Double] = ["USD" : 1, "EUR" : 1.5, "CAN" : 1.25, "GBP" : 0.5]
    
    public func convert(_ to: String) -> Money {
        let new = Double(self.amount) / exchangeRate[self.currency]! * exchangeRate[to]!
        return Money(amount: Int(new), currency: to)
    }
    
    public func add(_ to: Money) -> Money {
        let new = Double(self.amount) / exchangeRate[self.currency]! * exchangeRate[to.currency]!
        return Money(amount: Int(new) + to.amount, currency: to.currency)
    }
    public func subtract(_ from: Money) -> Money {
        let new = Double(self.amount) / exchangeRate[self.currency]! * exchangeRate[from.currency]!
        return Money(amount: Int(new) - from.amount, currency: from.currency)
    }
}




////////////////////////////////////
// Job
//
open class Job {
    static let NONE = Job(title: "(NONE)", type: Job.JobType.Salary(0))
    fileprivate var title : String
    fileprivate var type : JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
    
    open func calculateIncome(_ hours: Int) -> Int {
        switch type {
        case let .Salary(value):
            return value
        case let .Hourly(value):
            return Int(value * Double(hours))
        }
    }
    
    open func raise(_ amt : Double) {
        switch self.type {
        case let .Salary(value):
            self.type = .Salary(value + Int(amt))
        case let .Hourly(value):
            self.type = .Hourly(value + amt)
        }
    }
}

////////////////////////////////////
// Person
//
open class Person {
    static let NONE = Person(firstName: "(NONE)", lastName: "(NONE)", age: 0)
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    
    fileprivate var _job : Job? = nil
    open var job : Job? {
        get {
            if age >= 16 && _job != nil {
                return _job!
            } else {
                return nil
            }
        }
        set(value) {
            _job = value
        }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get {
            if age >= 18 && _spouse != nil {
                return _spouse!
            } else {
                return nil
            }
        }
        set(value) {
            _spouse = value
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    open func toString() -> String {
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job) spouse:\(spouse)]"
    }
}

////////////////////////////////////
// Family
//

open class Family {
    fileprivate var members : [Person] = []
    
    public init(spouse1: Person, spouse2: Person) {
        if spouse1.spouse == nil && spouse2.spouse == nil {
            members.append(spouse1)
            members.append(spouse2)
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
        } else {
            print ("no")
        }
        
    }
    
    open func haveChild(_ child: Person) -> Bool {
        members.append(child)
        return true
    }
    
    open func householdIncome() -> Int {
        var income = 0
        for i in members {
            if i.job != nil {
                income += i.job!.calculateIncome(2000)
            }
        }
        return income
    }
}
