import Foundation
import Capacitor
import FBSDKCoreKit

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(FacebookAnalytics)
public class FacebookAnalytics: CAPPlugin {

    @objc func logEvent(_ call: CAPPluginCall) {
        print("logging event")

        guard let event = call.getString("event") else {
            call.reject("Missing event argument")
            return;
        }

        print(event)

        if let valueToSum = call.getDouble("valueToSum") {
            if let params = call.getObject("params") {
                AppEvents.shared.logEvent(.init(event), valueToSum: valueToSum, parameters: params as? [AppEvents.ParameterName: Any])
            } else {
                AppEvents.shared.logEvent(.init(event), valueToSum: valueToSum)
            }
            
        } else {
            if let params = call.getObject("params") {
                AppEvents.shared.logEvent(.init(event), parameters: params as? [AppEvents.ParameterName: Any])
            } else {
                AppEvents.shared.logEvent(.init(event))
            }
        }
        

        call.resolve()
    }

    @objc func logPurchase(_ call: CAPPluginCall) {
        print("logging purchase")
        guard let amount = call.getDouble("amount") else {
            call.reject("Missing amount argument")
            return;
        }
        
        let currency = call.getString("currency") ?? "USD"
        let params = call.getObject("params") ?? [String:String]()
        
        AppEvents.shared.logPurchase(amount: amount, currency: currency, parameters: params as? [AppEvents.ParameterName: Any])

        call.resolve()
    }

    @objc func logAddPaymentInfo(_ call: CAPPluginCall) {
        print("logging logAddPaymentInfo")

        let success = call.getInt("success") ?? 0
    

        AppEvents.shared.logEvent(.addedPaymentInfo, parameters: [AppEvents.ParameterName.success: success])

        call.resolve()
    }

    @objc func logAddToCart(_ call: CAPPluginCall) {
        print("logging logAddToCart")

        guard let amount = call.getDouble("amount") else {
            call.reject("Missing amount argument")
            return;
        }
        let currency = call.getString("currency") ?? "USD"

        var params = call.getObject("params") as? [AppEvents.ParameterName: Any]
        
        params?[AppEvents.ParameterName.currency] = currency
        
        
        AppEvents.shared.logEvent(.addedToCart, valueToSum: amount, parameters: params)

        call.resolve()
    }
    
    @objc func logCompleteRegistration(_ call: CAPPluginCall) {
        print("logging logCompleteRegistration")

        let parameters = call.getObject("params") as? [AppEvents.ParameterName: Any]

        AppEvents.shared.logEvent(.completedRegistration, parameters: parameters)

        call.resolve()
    }
    @objc func logInitiatedCheckout(_ call: CAPPluginCall) {
        print("logging logInitiatedCheckout")
        guard let amount = call.getDouble("amount") else {
            call.reject("Missing amount argument")
            return;
        }        
        
        let parameters = call.getObject("params") as? [AppEvents.ParameterName: Any]

        AppEvents.shared.logEvent(.initiatedCheckout, valueToSum: amount, parameters: parameters)

        call.resolve()
    }
}
