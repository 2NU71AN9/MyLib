//
//  APIService.swift
//  RxSwiftDemo
//
//  Created by X.T.X on 2017/6/9.
//  Copyright © 2017年 shiliukeji. All rights reserved.
//

import Foundation
import Moya

public enum APIService {

    case login(phone: String, vCode: String, type: Int, sign: String) //登录
    case updateImage(image: UIImage)
}

extension APIService: TargetType {
    
    /// 请求头
    public var headers: [String : String]? {
        return [
            "Content-Type" : "application/x-www-form-urlencoded",
        ]
    }

    /// 域名
    public var baseURL: URL {
        return URL(string: isRelease ? releaseUrl : debugUrl)!
    }
    
    /// URL
    public var path: String {
        switch self {
        case .login:
            return "***"
        case .loadImage:
            return "***"
        default:
            return ""
        }
    }
    
    /// 请求方式
    public var method: Moya.Method {
        return .post
    }
    
    ///
    public var parameterEncoding: ParameterEncoding { return URLEncoding.default }
    
    /// 单元测试用
    public var sampleData: Data { return "".data(using: .utf8)! }
    
    /// 网络请求时是否显示loading...
    public var showStats: Bool { return true }
    
    ///
    public var task: Task {
        switch self {
        case .updateImage(let image):
            let data = UIImageJPEGRepresentation(image, 0.7)
            let img = MultipartFormData(provider: .data(data!), name: "参数名", fileName: "名称随便写.jpg", mimeType: "image/jpeg")
            return .uploadMultipart([img])
            
        case .addTaxi(let userPhone, let token, let type, let memNo, let brandId, let provinceShort, let cityShort, let carPlateNum, let brandName, let seriesId, let seriesName, let modelsId, let modelsName, let carMileage, let insuranceDue, let insuranceCity, let provinceName, let provinceCode, let cityName, let cityCode, let regionName, let regionCode, let serPic, let carPic):
            
            let userPhoneFormData = MultipartFormData(provider: .data(userPhone.data(using: .utf8)!), name: "userPhone")
            let tokenFormData = MultipartFormData(provider: .data(token.data(using: .utf8)!), name: "token")
            let typeFormData = MultipartFormData(provider: .data(type.sl_ToString.data(using: .utf8)!), name: "type")
            let memNoFormData = MultipartFormData(provider: .data(memNo.data(using: .utf8)!), name: "memNo")
            let brandIdFormData = MultipartFormData(provider: .data(brandId.sl_ToString.data(using: .utf8)!), name: "brandId")
            let provinceShortFormData = MultipartFormData(provider: .data(provinceShort.data(using: .utf8)!), name: "provinceShort")
            let cityShortFormData = MultipartFormData(provider: .data(cityShort.data(using: .utf8)!), name: "cityShort")
            let carPlateNumFormData = MultipartFormData(provider: .data(carPlateNum.data(using: .utf8)!), name: "carPlateNum")
            let brandNameFormData = MultipartFormData(provider: .data(brandName.data(using: .utf8)!), name: "brandName")
            let seriesIdFormData = MultipartFormData(provider: .data(seriesId.sl_ToString.data(using: .utf8)!), name: "seriesId")
            let seriesNameFormData = MultipartFormData(provider: .data(seriesName.data(using: .utf8)!), name: "seriesName")
            let modelsIdFormData = MultipartFormData(provider: .data(modelsId.sl_ToString.data(using: .utf8)!), name: "modelsId")
            let modelsNameFormData = MultipartFormData(provider: .data(modelsName.data(using: .utf8)!), name: "modelsName")
            let carMileageFormData = MultipartFormData(provider: .data(carMileage.sl_ToString.data(using: .utf8)!), name: "carMileage")
            let insuranceDueFormData = MultipartFormData(provider: .data(insuranceDue.data(using: .utf8)!), name: "insuranceDue")
            let insuranceCityFormData = MultipartFormData(provider: .data(insuranceCity.data(using: .utf8)!), name: "insuranceCity")
            let provinceNameFormData = MultipartFormData(provider: .data(provinceName.data(using: .utf8)!), name: "provinceName")
            let provinceCodeFormData = MultipartFormData(provider: .data(provinceCode.data(using: .utf8)!), name: "provinceCode")
            let cityNameFormData = MultipartFormData(provider: .data(cityName.data(using: .utf8)!), name: "cityName")
            let cityCodeFormData = MultipartFormData(provider: .data(cityCode.data(using: .utf8)!), name: "cityCode")
            let regionNameFormData = MultipartFormData(provider: .data(regionName.data(using: .utf8)!), name: "regionName")
            let regionCodeFormData = MultipartFormData(provider: .data(regionCode.data(using: .utf8)!), name: "regionCode")
            let data1 = UIImageJPEGRepresentation(serPic, 1)
            let data2 = UIImageJPEGRepresentation(carPic, 1)
            let img1 = MultipartFormData(provider: .data(data1!), name: "serPic", fileName: "serPic.png", mimeType: "image/jpg/png/jpeg")
            let img2 = MultipartFormData(provider: .data(data2!), name: "carPic", fileName: "carPic.png", mimeType: "image/jpg/png/jpeg")

            return .uploadMultipart([userPhoneFormData, tokenFormData, typeFormData, memNoFormData, brandIdFormData, provinceShortFormData, cityShortFormData, carPlateNumFormData, brandNameFormData, seriesIdFormData, seriesNameFormData, modelsIdFormData, modelsNameFormData, carMileageFormData, insuranceDueFormData, insuranceCityFormData, provinceNameFormData, provinceCodeFormData, cityNameFormData, cityCodeFormData, regionNameFormData, regionCodeFormData, img1, img2])
        default:
            return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        }
    }
    
    /// 传递的参数
    public var parameters: [String: Any] {
        switch self {
        case .login(let phone, let vCode, let type, let sign):
            return [:]
        case .updateImage:
            // 返回除图片之外的所有参数
            return [:]
        }
    }
}
