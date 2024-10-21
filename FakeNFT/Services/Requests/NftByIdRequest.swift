import Foundation

struct NFTRequest: NetworkRequest {
    let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
    var dto: Dto?
}

struct NftsRequest: NetworkRequest {
    let page: Int
    let size: Int
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft?page=\(page)&size=\(size)")
    }
    var dto: Dto?
}
