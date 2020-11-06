//
//  main.swift
//  calendar
//
//  Created by Dustin Knopoff on 11/5/20.
//
// NOTE: Cannot be run inside Xcode
import Foundation
import EventKit

let store = EKEventStore()
store.requestAccess(to: .event) { (granted, error) in
	if let error = error {
		print("error: \(error.localizedDescription)")
	} else {
//		print("authorization granted!")
	}
}


let calendars = store.calendars(for: .event)

// Get the appropriate calendar.
var calendar = Calendar.current

// Create the start date components

let startOfDay = calendar.startOfDay(for: Date())

var endOfDay: Date {
	var components = DateComponents()
	components.day = 1
	components.second = -1
	return Calendar.current.date(byAdding: components, to: startOfDay)!
}

var startOfMonth: Date {
	let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
	return Calendar.current.date(from: components)!
}

var endOfMonth: Date {
	var components = DateComponents()
	components.month = 1
	components.second = -1
	return Calendar.current.date(byAdding: components, to: startOfMonth)!
}

func matches(for regex: String, in text: String) -> [String] {
	
	do {
		let regex = try NSRegularExpression(pattern: regex)
		let results = regex.matches(in: text,
									range: NSRange(text.startIndex..., in: text))
		return results.map {
			String(text[Range($0.range, in: text)!])
		}
	} catch let error {
		print("invalid regex: \(error.localizedDescription)")
		return []
	}
}

let predicate = store.predicateForEvents(withStart: startOfDay, end: endOfDay, calendars: calendars)
var events = store.events(matching: predicate)
for event in events {
	let title = event.title!
	guard let notes = event.notes else {
		continue
	}
	let zoomMatches = matches(for: "https://northeastern.zoom.us/j/\\d+(\\?pwd=\\w+)?", in: notes)
	if zoomMatches.isEmpty {
		continue
	}
	let link = zoomMatches[0]
	print("\(title), \(link)")
}
