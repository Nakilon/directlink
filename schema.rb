Schema = {
  vk_url: /\Ahttps:\/\/sun(1|9-(east|west|north|\d+))\.userapi\.com\/[^?.\s#]/
}
vk = { hash: {
  "width" => Integer,
  "height" => Integer,
  "url" => Schema[:vk_url],
  "type" => /\A[m-z]\z/,
} }
imgur = /\A[a-zA-Z0-9]{5}(?:[a-zA-Z0-9]{2})?\z/
Schema.merge!( {
  flickr: { hash: {
    "stat" => "ok",
    "sizes" => { hash_req: {
      "size" => { size: 11..15, each: { hash_req: {
        "width" => Integer,
        "height" => Integer,
        "source" => /\Ahttps:\/\/live\.staticflickr\.com\/\d+\/\d+_[a-z0-9_]+(_[a-z])?\.jpg\z/,
      } } }
    } }
  } },
  flickr_not_found: { hash: {
    "stat" => "fail",
    "code" => 1..1,
    "message" => "Photo not found",
  } },
  vk_wall: { hash: {
    "response" => [[ { hash_req: {
      "attachments" => [[ { hash: {
        "type" => "photo",
        "photo" => { hash_req: {
          "sizes" => {size: 9..10, each: vk}
        } }
      } } ]]
    } } ]]
  } },
  vk_photos: { hash: {
    "response" => [[ { hash_req: {
      "sizes" => {size: 3..10, each: vk}
    } } ]]
  } },
  vk_not_found: { hash: {
    "error" => { hash: {
      "error_code" => 200..200,
      "error_msg" => "Access denied",
      "request_params" => { size: 4..4, each: { hash: {
        "key" => /\S/,
        "value" => /\S/,
      } } }
    } }
  } },
  imgur_empty: { hash_req: {
    "data" => { hash_req: {
      "images" => [[]],
    } },
  } }
} )
