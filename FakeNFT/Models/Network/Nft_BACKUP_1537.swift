import Foundation

struct Nft: Decodable {
    let id: String
<<<<<<< .merge_file_FyCGCl
    let name: String
    let images: [String]
    let rating: Int
    let price: Double
=======
    var name: String
    let images: [String]
    let rating: Int
    let price: Double
    let originalName: String
    
    //MARK: - Decodable инициализатор для декодирования из JSON
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.originalName = self.name // Сохраняем исходное имя при декодировании
        self.images = try container.decode([String].self, forKey: .images)
        self.rating = try container.decode(Int.self, forKey: .rating)
        self.price = try container.decode(Double.self, forKey: .price)
    }
    //MARK: - CodingKeys
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case images
        case rating
        case price
    }
>>>>>>> .merge_file_xCaBwH
}
