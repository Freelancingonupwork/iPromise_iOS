//
//  APIHelper.swift
//  iPromise
//
//  Created by Apple on 28/03/23.
//

import SwiftyJSON
import UIKit
import Alamofire


class APIHelper
{
    private init(){
        
    }

    class Connectivity {
        class func isConnectedToInternet() ->Bool {
            return NetworkReachabilityManager()!.isReachable
        }
    }
    
    static let sharedInstance = APIHelper()
    
    //MARK: - get/post/put/delete request
    func networkService(controller: UIViewController,apiurl: apiKey, extraParam : String? = "", methodType : HTTPMethod, param: [String : Any], withCompletion completion: @escaping apiResponseHandler)
    {
        LoaderVC.showLoader()
        Log.info("apiurl - \(appUrl)\(apiurl.rawValue)\(extraParam ?? "")")
        Log.info("param - \(param)")

        let headers : HTTPHeaders = [ "Authorization" : "Bearer \(Utils.getUserDetail(.accessToken))"]
        Log.info("token  - \(Utils.getUserDetail(.accessToken))")
        
        let url = "\(appUrl)\(apiurl.rawValue)\(extraParam ?? "")"
        
          AF.request(url, method: methodType, parameters: param, encoding: URLEncoding.default, headers: headers).responseData{ (response:DataResponse)  in
            Log.info("response - \(response)")
            switch(response.result) {
                case .success(_):
                        let jsonSerialized = try? JSONSerialization.jsonObject(with: response.data ?? Data(), options: []) as? [String : Any]
                        LoaderVC.hideLoader()
                        if let json = jsonSerialized{
                                Log.info("response json - \(json)")
                            if "\(json["status"] ?? "0")"  == "success" || ("\(json["errors"] ?? true)" == "0")
                            {
                                completion(JSON(json), "1")
                            }
                            else{
                                if "\(json["code"] ?? "0")"  == errorCode {
                                    completion(JSON(json), errorCode)
                                }
                                else{
                                    completion(JSON(json), "\(json["message"] as? String ?? "")")
                                }
                            }
                        }

                    break
                case .failure(_):
                    if !Connectivity.isConnectedToInternet()
                    {

                        Utils.showToast(strMessage: messageKey.noInternet)
                    }
                    else{
                        Utils.showToast(strMessage: messageKey.somethingWrong)
                    }
                    break
            }
            LoaderVC.hideLoader()
        }
    }
    
    func networkServiceJSON(controller: UIViewController,apiurl:apiKey, extraParam : String? = "",  methodType : String,  param: [String : Any], withCompletion completion:@escaping (_ responseJSON: (JSON), _ code:String)->()) {
        LoaderVC.showLoader()
        Log.info("apiurl - \(appUrl)\(apiurl.rawValue)\(extraParam ?? "")")
        Log.info("param - \(param)")
        let url = URL(string: "\(appUrl)\(apiurl.rawValue)\(extraParam ?? "")")
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Utils.getUserDetail(.accessToken))", forHTTPHeaderField: "Authorization")
        request.httpMethod = methodType
        request.httpBody = try! JSONSerialization.data(withJSONObject: param, options: [])
        AF.request(request).responseData{ (response) in
            switch(response.result) {
                case .success(_):
                LoaderVC.hideLoader()
                        let jsonSerialized = try? JSONSerialization.jsonObject(with: response.data ?? Data(), options: []) as? [String : Any]
                        if let json = jsonSerialized{
                            Log.info("response json - \(json)")
                            if "\(json["status"] ?? "0")"  == "success"
                            {
                                completion(JSON(json), "1")
                            }
                            else{
                                if "\(json["code"] ?? "0")"  == errorCode {
                                    completion(JSON(json), errorCode)
                                }
                                else{
                                    completion(JSON(json), "\(json["message"] as? String ?? "")")
                                }
                            }
                        }
                    break
                case .failure(_):
                    if !Connectivity.isConnectedToInternet()
                    {

                        Utils.showToast(strMessage: messageKey.noInternet)
                    }
                    else{
                        Utils.showToast(strMessage: messageKey.somethingWrong)
                    }
                    break
            }
            LoaderVC.hideLoader()
        }
    }
    
    //MARK: - multipart/from-data request
    func uploadImageAndData(controller: UIViewController,apiurl:apiKey, param: [String : Any], image : UIImage, withCompletion completion:@escaping (_ responseJSON: (JSON), _ code:String)->()){
        LoaderVC.showLoader()
        let headers : HTTPHeaders = [ "Authorization" : "Bearer \(Utils.getUserDetail(.accessToken))"]
        Log.info("token  - \(Utils.getUserDetail(.accessToken))")
        let url = "\(appUrl)\(apiurl.rawValue)"
    
        AF.upload(multipartFormData: { multipartFormData in
               if let imageData = image.jpegData(compressionQuality: 0.6) {
                   multipartFormData.append(imageData, withName: "avatar", fileName: "avatar.png", mimeType: "image/png")
               }

           for (key, value) in param {
               multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
           }
        }, to: url, method: .post, headers: headers ).response(completionHandler: { (response:DataResponse)  in
            Log.info("response - \(response)")
            switch(response.result) {
                case .success(_):
                        let jsonSerialized = try? JSONSerialization.jsonObject(with: response.data ?? Data(), options: []) as? [String : Any]
                        LoaderVC.hideLoader()
                        if let json = jsonSerialized{
                            Log.info("response json - \(json)")
                            if "\(json["status"] ?? "0")"  == "success"
                            {
                                completion(JSON(json), "1")
                            }
                            else{
                                if "\(json["code"] ?? "0")"  == errorCode {
                                    completion(JSON(json), errorCode)
                                }
                                else{
                                    completion(JSON(json), "\(json["message"] as? String ?? "")")
                                }
                            }
                        }

                    break
                case .failure(_):
                    if !Connectivity.isConnectedToInternet()
                    {

                        Utils.showToast(strMessage: messageKey.noInternet)
                    }
                    else{
                        Utils.showToast(strMessage: messageKey.somethingWrong)
                    }
                    break
            }
            LoaderVC.hideLoader()
        })
        
    }
    
}
