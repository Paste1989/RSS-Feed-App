//
//  RSSParserService.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 12.03.2025..
//

import Foundation

protocol RSSParserServiceProtocol {
    func parseFeed(from data: Data) throws -> [RSSFeedItemModel]
    func parseChannel(from data: Data) throws -> (name: String, image: String?)
}

class RSSParserService: NSObject, XMLParserDelegate, RSSParserServiceProtocol {
    private enum Mode {
        case feed
        case channel
    }
    private var mode: Mode = .feed
    private var currentElement = ""
    private var currentTitle = ""
    private var currentLink = ""
    private var currentImage: String?
    private var currentDescription = ""
    private var currentCategories: [String] = []
    private var items: [RSSFeedItemModel] = []
    
    private var channelTitle: String = ""
    private var channelImage: String?
}

//MARK: - RSS Channel
extension RSSParserService {
    func parseChannel(from data: Data) throws -> (name: String, image: String?) {
        mode = .channel
        channelTitle = ""
        channelImage = nil
        
        let parser = XMLParser(data: data)
        parser.delegate = self
        guard parser.parse() else { throw URLError(.cannotParseResponse) }
        
        return (channelTitle, channelImage)
    }
}

//MARK: - RSS Feed
extension RSSParserService {
    func parseFeed(from data: Data) throws -> [RSSFeedItemModel] {
        mode = .feed
        items.removeAll()
        
        let parser = XMLParser(data: data)
        parser.delegate = self
        guard parser.parse() else { throw URLError(.cannotParseResponse) }
        
        return items
    }
}

// MARK: - XMLParserDelegate
extension RSSParserService {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if mode == .feed && elementName == "item" {
            currentTitle = ""
            currentLink = ""
            currentImage = ""
            currentDescription = ""
        }
        
        if mode == .channel, elementName == "image" || elementName == "media:content" || elementName == "enclosure" {
            channelImage = attributeDict["url"] ?? attributeDict["href"]
        }
        
//        if let imageURL = extractImageFromDescription(currentDescription) {
//            print("Extracted Image URL: \(imageURL)")
//        } else {
//            print("No image found in description.")
//        }
//        if mode == .feed, elementName == "media:content" || elementName == "media:thumbnail" {
//            print("AAAAAAAAAAAAAAA")
//            currentImage = attributeDict["url"]
//        }
    }
    
    func extractImageFromDescription(_ description: String) -> String? {
        let pattern = #"<img[^>]*src=\"([^\"]+)\""#  // Regex to capture the 'src' value in <img> tags
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        
        if let match = regex?.firstMatch(in: description, range: NSRange(description.startIndex..., in: description)),
           let range = Range(match.range(at: 1), in: description) {
            return String(description[range])
        }
        
        return nil
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if mode == .feed {
            switch currentElement {
            case "title":
                currentTitle += trimmedString
            case "link":
                currentLink += trimmedString
            case "image":
                print("aaaa: \(trimmedString)")
                currentImage = trimmedString
            case "description":
                currentDescription += trimmedString
            default: break
            }
            
            //print("aaaa: \(trimmedString) ------ \(currentImage)")
        }
        else if mode == .channel {
            if currentElement == "title", channelTitle.isEmpty {
                channelTitle += trimmedString
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if mode == .feed, elementName == "item" {
            let item = RSSFeedItemModel(id: UUID(), title: currentTitle, description: currentDescription, image: currentImage, link: currentLink)
            items.append(item)
        }
    }
}

