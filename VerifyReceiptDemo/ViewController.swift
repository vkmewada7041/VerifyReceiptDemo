//
//  ViewController.swift
//  VerifyReceiptDemo
//
//  Created by vasishth suthar on 26/04/20.
//  Copyright © 2020 technicalinitial. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
            FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {

            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                print(receiptData)

                let receiptString = receiptData.base64EncodedString(options: [])
                
                // Read receiptData
                
                self.getReceipt(receiptString: receiptString)
            }
            catch { print("Couldn't read receipt data with error: " + error.localizedDescription) }
        }
    }

    func getReceipt(receiptString:String) {
        
        let SUBSCRIPTION_SECRET = ""

        let requestDictionary = ["receipt-data":receiptString,"password":SUBSCRIPTION_SECRET]

        guard JSONSerialization.isValidJSONObject(requestDictionary) else { print("requestDictionary is not valid JSON");  return }

        let validationURLString = "https://sandbox.itunes.apple.com/verifyReceipt"
        
    //        SandBox    = "https://sandbox.itunes.apple.com/verifyReceipt"
    //        Prodiction = "https://buy.itunes.apple.com/verifyReceipt"

        AF.request(validationURLString, method: .post, parameters: requestDictionary, encoding: JSONEncoding.default).responseData(completionHandler: { (response) in
            
            switch response.result {

            case .success(let json):
                do {
                    let jsonReceipt = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as! [String:Any]
                    
                    print(jsonReceipt)
                    
                    let receipt = jsonReceipt["receipt"] as? [String:Any]
                    let in_app = receipt?["in_app"] as? NSArray


                } catch let error as NSError {
                    print(error)
                }

            case .failure(let error):
                 print(error)
               
            }
        })
    }
}

