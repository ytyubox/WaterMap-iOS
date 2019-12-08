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
struct Overpass: Codable {
	private static let url:URL = "https://overpass.nchc.org.tw/api/interpreter?data=[out:json];area(3600449220)-%3E.searchArea;(node[%22amenity%22=%22drinking_water%22](area.searchArea);node[%22drinking_water%22=%22yes%22](area.searchArea);way[%22amenity%22=%22drinking_water%22](area.searchArea);way[%22drinking_water%22=%22yes%22](area.searchArea);rel[%22amenity%22=%22drinking_water%22](area.searchArea);rel[%22drinking_water%22=%22yes%22](area.searchArea););out;"
	static var publisher = URLSession.shared.dataTaskPublisher(for: Self.url)
		.map(\.data)
		.decode(type: Overpass.self, decoder: JSONDecoder())
	let version: Double
	let generator: String
	let osm3S: Osm3S
	let elements: [Element]
	
	enum CodingKeys: String, CodingKey {
		case version, generator
		case osm3S = "osm3s"
		case elements
	}
	struct Element: Codable {
		let type: TypeEnum
		let id: Int
		let lat, lon: Double?
		//		let tags: [String: String]
		let amenity:String?//	2572
		let description:String?//	2005
		let opening_hours:String?//	1314
		let level:String?//	1102
		let hot_water:String?//	993
		let indoor:String?//	957
		let `operator`:String?//	956
		let warm_water:String?//	951
		let nodes: [Int]?
		enum TypeEnum: String, Codable {
			case node = "node"
			case way = "way"
		}
		
		// MARK: - Osm3S
	}
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

/* 20928
amenity	2572
description	2005
opening_hours	1314
level	1102
hot_water	993
indoor	957
operator	956
warm_water	951
iced_water	649
source	644
ref	590
source:devision	587
source:url	587
source:department	587
contact:phone	587
start_date	587
source:type	587
source:date	586
is_in:district	570
access	545
brand	470
cold_water	451
addr:street	281
bottle	233
addr:city	220
is_in	212
wheelchair	89
note	87
drinking_water:hot_water	72
drinking_water:warm_water	65
drinking_water	63
name	60
fixme	60
drinking_water:cold_water	55
website	50
addr:housenumber	46
addr:district	38
layer	32
addr:postcode	32
addr:country	31
drinking_water:iced_water	31
toilets:wheelchair	29
phone	21
addr:full	13
levels	12
location	11
name:zh	9
addr:floor	9
building	8
office	8
name:en	8
fee	8
wheelchair:description	7
ice_water	7
toilets	6
description:zh	6
internet_access	6
natural	5
shop	5
repeat_on	4
emergency	4
fax	4
official_name	4
tourism	4
wikidata	3
smoking	3
description:en	3
toilets:disposal	3
wikipedia	3
internet_access:fee	3
branch	2
cuisine	2
religion	2
contact:facebook	2
owner	2
alt_description	2
water_tank:volume	2
hand_wash	1
waste_basket:type	1
level_1	1
ice	1
opera	1
restaurant	1
opening_hours:url	1
atm	1
amenity_2	1
generator:output:cold_water	1
trash_can	1
healthcare:speciality	1
healthcare	1
descriptio	1
building:levels	1
addr:full:en	1
highway	1
outdoor_seating	1
takeaway	1
vending_machine	1
pitlatrine	1
addr:village	1
old_name	1
male	1
wikipedia:zh	1
amenity_1	1
denotation	1
cool_water	1
drive_through	1
payment:cash	1
generator:output:hot_water	1
opening_hours_1	1
waterway	1
network	1
drinking_water:type	1
supervised	1
addr:housename	1
surface	1
child	1
internet_access:ssid	1
leisure	1
operator:en	1
drinking_water:name	1
impromptu	1
female	1
amenity_3	1
floor	1
rss	1
parking	1
operater	1
email	1
aeroway	1
building:levels:underground	1
diaper	1
addr:street:en	1
oper	1
unisex	1
int_name	1
drinking_water:seasonal	1
description:ja	1
outdoors	1
description:zh_pinyin	1
time	1
removed:amenity	1

*/
