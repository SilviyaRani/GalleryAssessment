//
//  PlacesAPI.swift
//  GalleryApp
//
//  Created by admin on 05/08/20.
//  Copyright © 2020 deemsys. All rights reserved.
//

import Foundation


struct MainData:Codable {
    let title:String
    let rows:[Rows]
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case rows = "rows"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.rows = try container.decode([Rows].self, forKey: .rows)
    }
    
    func encode(to encoder: Encoder) throws {
     var container = encoder.container(keyedBy: CodingKeys.self)
     try container.encode(self.title, forKey: .title)
     try container.encode(self.rows, forKey: .rows)
    }

}

struct Rows:Codable {
    let placeName:String?
    let placeDescription:String?
    let imageURL:String?
    
    enum CodingKeys: String, CodingKey {
        case placeName = "title"
        case placeDescription = "description"
        case imageURL = "imageHref"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.placeName = try container.decode(String?.self, forKey: .placeName)
        self.placeDescription = try container.decode(String?.self, forKey: .placeDescription)
        self.imageURL = try container.decode(String?.self, forKey: .imageURL)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.placeName, forKey: .placeName)
        try container.encode(self.placeDescription, forKey: .placeDescription)
        try container.encode(self.imageURL, forKey: .imageURL)
    }
}

class PlacesAPI{

public func loadJson(fromURLString urlString: String,
                      completion: @escaping (Result<Data, Error>) -> Void) {
    if let url = URL(string: urlString) {
        let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                
                completion(.success(data))
            }
        }
        
        urlSession.resume()
    }
}

public func parse(jsonData: Data) -> (String, [Places]) {
    do {
        let dataString = String(decoding: jsonData, as: UTF8.self)
        let decodedData = try JSONDecoder().decode(MainData.self,from: dataString.data(using: .utf8)!)
        
//        print("Title: ", decodedData.title)
//        print("Description: ", decodedData.rows)
//        print("===================================")
        var resultData:[Places] = []
        for x in decodedData.rows{
            if let _ = x.placeName
            {
                resultData.append(Places(placeName: x.placeName, placeDescription: x.placeDescription, imageURL: x.imageURL))
            }
        }
        return (decodedData.title, resultData )
    }
    catch {
        print("decode error")
        print(error)
        return ("Error",[])
    }
//    catch let DecodingError.dataCorrupted(context) {
//        print(context)
//    } catch let DecodingError.keyNotFound(key, context) {
//        print("Key '\(key)' not found:", context.debugDescription)
//        print("codingPath:", context.codingPath)
//    } catch let DecodingError.valueNotFound(value, context) {
//        print("Value '\(value)' not found:", context.debugDescription)
//        print("codingPath:", context.codingPath)
//    } catch let DecodingError.typeMismatch(type, context)  {
//        print("Type '\(type)' mismatch:", context.debugDescription)
//        print("codingPath:", context.codingPath)
//    } catch {
//        print("error: ", error)
//    }
}


}
