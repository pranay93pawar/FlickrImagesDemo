//
//  Router.swift
//  FlickrImagesDemo
//
//  Created by Mac-145-Pranay-Pawar on 04/12/21.
//

import Foundation

class Router<EndPoint: EndPointType>: NSObject, NetworkRouter, URLSessionDelegate {
    
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion:@escaping NetworkRouterCompletion) {
        
        //let session = URLSession.shared
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        do {
            
            let request = try self.buildRequest(from: route)
            //print(request.url ?? "")
            task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                completion(data, response, error)
            })
        } catch  {
           completion(nil, nil, error)
        }
        
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        
        
        request.httpMethod = route.httpMethod.rawValue
        
        do {
            
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            case .requestParameters(let bodyParameters,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let urlParameters,
                                              let additionalHeaders) :
                
                self.addAdditionalHeaders(additionalHeaders,
                                          request: &request)
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            
            return request
            
        } catch  {
            throw error
        }
        
        
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws {
        
        do {
            
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
            
        } catch  {
            throw error
        }
        
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders:HTTPHeaders?, request: inout URLRequest) {
        
        guard let headers = additionalHeaders else {
            return
        }
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
    }
    
    /*//SSL Pinning
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                
                let isServerTrusted = SecTrustEvaluateWithError(serverTrust, nil)
                
                if isServerTrusted {
                    let serverCertificateCount = SecTrustGetCertificateCount(serverTrust)
                    let leafCertIndex = 0
                    
                    if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, leafCertIndex) {
                        
                        let serverCertificateData = SecCertificateCopyData(serverCertificate)
                        let data =  CFDataGetBytePtr(serverCertificateData)
                        let size = CFDataGetLength(serverCertificateData)
                        let serverCertData = NSData(bytes: data, length: size)
                        if let filePath = Bundle.main.path(forResource: "Prod", ofType: "der"){
                            if let pinnedCertdata = NSData(contentsOfFile: filePath) {
                                if serverCertData.isEqual(to: pinnedCertdata as Data) {
                                    
                                    print("certs are equal")
                                    completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: serverTrust))
                                    return
                                    
                                }
                            }
                        }
                        
                    }
                    
                    
                }
                
            }
            
        }
        
        
        completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
    }*/
}
