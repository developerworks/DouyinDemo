import ObjectMapper

class Video: Aweme {
    // 动态封面数组
    var dynamic_cover: [String]!
    var cover: [String]!
    //    init() {}
    required init?(map: Map) {
        super.init(map: map)
    }
    override func mapping(map: Map) {
        super.mapping(map: map)
        dynamic_cover <- map["dynamic_cover.url_list"]
        cover <- map["cover.url_list"]
    }
}
class Aweme: VideoInfo {
    var video: Video!
    //    init() {}
    required init?(map: Map) {
        super.init(map: map)
    }
    override func mapping(map: Map) {
        super.mapping(map: map)
        video <- map["video"]
    }
}
class VideoInfo: Mappable {
    var aweme_list: [Aweme]!
    //    init() {}
    required init?(map: Map) {}
    func mapping(map: Map) {
        aweme_list <- map["aweme_list"]
    }
}
