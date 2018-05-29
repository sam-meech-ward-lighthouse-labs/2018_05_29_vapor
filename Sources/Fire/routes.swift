import Vapor

struct WordFilter: Content {
  var words: String?
  var times: Int?
}

struct Wood: Content {
  var name: String
  var hardness: Int
}

var database = [Wood]()

/// Register your application's routes here.
public func routes(_ router: Router) throws {
  
  router.get("hi") { req in
    return "🤗"
  }
  
  router.get("upcase") { req -> String in
    let filters = try req.query.decode(WordFilter.self)
    guard let words = filters.words else {
      return "Enter some words"
    }
    let times = filters.times ?? 1
    
    var output = ""
    
    for _ in 1...times {
      output += words.uppercased() + "\n"
    }
    
    return output
  }
  
  router.get("myupcase", String.parameter) { req -> String in
    let string: String = try req.parameters.next(String.self)
    return "\(string.uppercased())"
  }
  
  router.post("wood") { req -> Future<HTTPStatus> in
    return try req.content.decode(Wood.self).map(to: HTTPStatus.self) { wood in
//      print(wood.name)
//      print(wood.hardness)
      database.append(wood)
      return .ok
    }
  }
  
  router.get("wood") { req in
    return database
  }

}
