//
//  InAppPurchaseManager.swift
//  ThoughtsBlogApp
//
//  Created by Stefan Dojcinovic on 14.10.21..
//

import Foundation
import Purchases
import StoreKit

final class InAppPurchaseManager {
    static let shared = InAppPurchaseManager()
    
    private init() { }
    
    func isPremium() -> Bool {
        return UserDefaults.standard.bool(forKey: "premium")
    }
    
    public func subscribe(package: Purchases.Package, completion: @escaping (Bool) -> Void ) {
        guard !isPremium() else {
            completion(true)
            print("User already subscribed!")
            return
        }
        Purchases.shared.purchasePackage(package) { transaction, info, error, userCanceled in
            guard let transaction = transaction,
                  let entitelments = info?.entitlements,
                  error == nil,
                  !userCanceled else { return }
            switch transaction.transactionState {
            case .purchasing:
                print("Purchasing")
            case .purchased:
                if entitelments.all["Premium"]?.isActive == true {
                    print("Purchased!")
                    UserDefaults.standard.set(true, forKey: "premium")
                    completion(true)
                } else {
                    print("Purchase failed!")
                    UserDefaults.standard.set(false, forKey: "premium")
                    completion(false)
                }
            case .failed:
                print("Failed")
            case .restored:
                print("Rstore")
            case .deferred:
                print("Deffered")
            @unknown default:
                print("Default")
            }
        }
    }
    
    public func fetchPackages(completion: @escaping (Purchases.Package?) -> Void) {
        Purchases.shared.offerings { offerings, error in
            guard let package = offerings?.offering(identifier: "default")?.availablePackages.first,
                  error == nil else {
                completion(nil)
                return
            }
            completion(package)
        }
    }
    
    public func restorePurchases(completion: @escaping (Bool) -> Void) {
        Purchases.shared.restoreTransactions { info, error in
            guard let entitlements = info?.entitlements,
                  error == nil else { return }
            if entitlements.all["Premium"]?.isActive == true {
                print("Restored success")
                UserDefaults.standard.set(true, forKey: "premium")
                completion(true)
            } else {
                print("Restore failed")
                UserDefaults.standard.set(false, forKey: "premium")
                completion(false)
            }

        }
    }
    
    public func getSubscriptionStatus(completion: ((Bool) -> Void)?) {
        Purchases.shared.purchaserInfo { info, error in
            guard let entitlements = info?.entitlements, error == nil else { return }
            print(entitlements)
            if entitlements.all["Premium"]?.isActive == true {
                print("Got updated status of subscribed")
                UserDefaults.standard.set(true, forKey: "premium")
                completion?(true)
            } else {
                print("Got updated status of NOT subscribed")
                UserDefaults.standard.set(false, forKey: "premium")
                completion?(false)
            }
        }
    }
}
