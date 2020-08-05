//
//  PlacesAPI.swift
//  GalleryApp
//
//  Created by admin on 05/08/20.
//  Copyright © 2020 deemsys. All rights reserved.
//

import Foundation


struct Data:Codable {
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
/*
private func readLocalFile(forName name: String) -> Data? {
    do {
        if let bundlePath = Bundle.main.path(forResource: name,
                                             ofType: "json"),
            let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
            return jsonData
        }
    } catch {
        print(error)
    }
    
    return nil
}

private func parse(jsonData: Data) {
    do {
        let decodedData = try JSONDecoder().decode(PlacesData.self,from: jsonData)
        
        print("Title: ", decodedData.title)
        print("Description: ", decodedData.rows)
        print("===================================")
    }
//    catch {
//        print("decode error")
//        print(error)
//    }
    catch let DecodingError.dataCorrupted(context) {
        print(context)
    } catch let DecodingError.keyNotFound(key, context) {
        print("Key '\(key)' not found:", context.debugDescription)
        print("codingPath:", context.codingPath)
    } catch let DecodingError.valueNotFound(value, context) {
        print("Value '\(value)' not found:", context.debugDescription)
        print("codingPath:", context.codingPath)
    } catch let DecodingError.typeMismatch(type, context)  {
        print("Type '\(type)' mismatch:", context.debugDescription)
        print("codingPath:", context.codingPath)
    } catch {
        print("error: ", error)
    }
}
func getPlaces(){
    if let localData = readLocalFile(forName: "facts") {
        parse(jsonData: localData)
    }
}
*/
}
