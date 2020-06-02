//
//  OverPass.swift
//  WaterMap
//
//  Created by 游宗諭 on 2019/12/8.
//  Copyright © 2019 游宗諭. All rights reserved.
//

import Foundation


import Foundation

// MARK: - Overpass
struct Overpass: Decodable {
    private static let url:URL = "https://overpass.nchc.org.tw/api/interpreter?data=[out:json];area(3600449220)-%3E.searchArea;(node[%22amenity%22=%22drinking_water%22](area.searchArea);node[%22drinking_water%22=%22yes%22](area.searchArea);way[%22amenity%22=%22drinking_water%22](area.searchArea);way[%22drinking_water%22=%22yes%22](area.searchArea);rel[%22amenity%22=%22drinking_water%22](area.searchArea);rel[%22drinking_water%22=%22yes%22](area.searchArea););out;"
    static var publisher = URLSession.shared.dataTaskPublisher(for: Self.url)
        .map(\.data)
        .decode(type: Overpass.self, decoder: JSONDecoder())
    let version: Double
    let generator: String
    let osm3S: Osm3S
    let elements: [Element] // 所有飲水機的資料
    /*
     function(data) {
     for(var i = 0; i < data.elements.length; i++) {
     var e = data.elements[i];
     
     if (e.id in this.instance._ids) return;
     this.instance._ids[e.id] = true;
     var pos = new L.LatLng(e.lat, e.lon);
     var popup = this.instance._poiInfo(e.tags,e.id);
     var circle = L.circle(pos, 50, {
     color: 'green',
     fillColor: '#3f0',
     fillOpacity: 0.5
     })
     .bindPopup(popup);
     this.instance.addLayer(circle);
     }
     }
     */
    enum CodingKeys: String, CodingKey {
        case version, generator
        case osm3S = "osm3s"
        case elements
    }
    /*
     function displayNote (feature) {
     var text = feature.properties.comments[0].text
     var v = {}
     text.split('\n')
     .filter(function (l) { return l.search('：') >= 0 })
     .map(function (l) { return l.split('：') })
     .forEach(function (x) {
     v[x[0]] = x[1]
     })
     return '<div>' +
     '<div class="unverified ui label"><i class="info icon"></i>未驗證</div>' +
     '<div><a href="https://www.openstreetmap.org/note/' + feature.properties.id + '" target="_blank">這個資訊正確嗎？</a></div>' +
     '<div class="name">' + (v['名稱'] || '') + '</div>' +
     (v['溫度'] ? (
     '<div class="water">' +
     (v['溫度'].search('iced_water') >= 0 ? '<img src="iced.png"/>' : '') +
     (v['溫度'].search('cold_water') >= 0 ? '<img src="cold.png"/>' : '') +
     (v['溫度'].search('warm_water') >= 0 ? '<img src="warm.png"/>' : '') +
     (v['溫度'].search('hot_water') >= 0  ? '<img src="hot.png"/>' : '') +
     '</div>') : '') +
     (v['說明'] ? '<div class="description">' + v['說明'] + '</div>' : '') +
     (v['樓層'] ? '<div class="level">' + (v['樓層'] < 0 ? '地下 ' + -v['樓層'] : v['樓層']) + ' 樓' + '</div>' : '') +
     (v['管理者'] ? '<div class="operator">管理者：' + v['管理者'].replace(/operator=/, '') + '</div>' : '') +
     (v['機型'] ? '<div class="brand">機型：' + v['機型'].replace(/brand=/, '') + '</div>' : '') +
     '</div>'
     }
     */
    
    struct Osm3S: Codable {
        let timestampOsmBase, timestampAreasBase: String
        let copyright: String
        
        enum CodingKeys: String, CodingKey {
            case timestampOsmBase = "timestamp_osm_base"
            case timestampAreasBase = "timestamp_areas_base"
            case copyright
        }
    }
}
struct Element: Decodable, Identifiable {
    let type: TypeEnum
    let id: Int
    let lat, lon: Double?
    let tags: [String: String]
    // MARK: - Osm3S
}

/**
 if (e.id in this.instance._ids) return
 e.tags.name = e.tags.name || '飲水機'
 e.tags.level = e.tags.level ? (+e.tags.level < 0 ? '地下 ' + -e.tags.level : e.tags.level) + ' 樓' : undefined
 this.instance._ids[e.id] = true
 '<div class="name">' + e.tags.name + '</div>' +
 '<div class="water">' +
 (e.tags['drinking_water:iced_water'] ? '<img src="iced.png"/>' : '') +
 (e.tags['drinking_water:cold_water'] ? '<img src="cold.png"/>' : '') +
 (e.tags['drinking_water:warm_water'] ? '<img src="warm.png"/>' : '') +
 (e.tags['drinking_water:hot_water'] ? '<img src="hot.png"/>' : '') +
 (e.tags.iced_water ? '<img src="iced.png"/>' : '') +
 (e.tags.cold_water ? '<img src="cold.png"/>' : '') +
 (e.tags.warm_water ? '<img src="warm.png"/>' : '') +
 (e.tags.hot_water ? '<img src="hot.png"/>' : '') +
 '</div>' +
 (e.tags.description ? '<div class="description">' + e.tags.description + '</div>' : '') +
 (e.tags.level ? '<div class="level">' + e.tags.level + '</div>' : '') +
 (e.tags.operator ? '<div class="operator">管理者：' + e.tags.operator + '</div>' : '') +
 (e.tags.brand ? '<div class="brand">機型：' + e.tags.brand + '</div>' : '') +
 '</div>'
 */

struct ViewInfo {
    static func get(by es: [Element]) -> [ViewInfo]{
        es.compactMap(ViewInfo.init)
    }
    init?(e:Element) {
        guard e.type == .node else {return nil}
        name = e.tags["name"] ?? "飲水機"
        description = e.tags["description"] ?? ""
        
        let levelstr = e.tags["level"] ?? ""
        
        if
            let level = Int(levelstr)  {
            levelString = (level < 0 ? "地下 " : " ") + "\(level)"  + " 樓"
        }
        else {levelString = ""}
        waterStatus = [
            e.tags["iced_water"].replace("iced"),
            e.tags["cold_water"].replace("cold"),
            e.tags["warm_water"].replace("warm"),
            e.tags["hot_water"].replace("hot")
            ].compactMap{$0}.joined(separator: ", ")
        `operator` =  e.tags["operator"].prefix("管理者： ") ?? ""
        brand =  e.tags["brand"].prefix("機型： ") ?? ""
        
        lat = e.lat!
        lon = e.lon!
    }
    
    let name,
    description,
    levelString,
    waterStatus,
    `operator`,
    brand
    
    :String
    let lat, lon:Double
}

enum TypeEnum: String, Codable {
    case node = "node"
    case way = "way"
}


fileprivate extension Optional where Wrapped == String {
    
    func replace(_ it:Wrapped)  -> Wrapped? {
        if self != nil {
            return it
        }
        return nil
    }
    func prefix(_ it: String) -> Wrapped? {
        if let self = self {
            return it + self
        }
        return nil
    }
}
