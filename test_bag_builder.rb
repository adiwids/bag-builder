require './bag_builder'

base = "https://s3.amazonaws.com/CustomBags/app/public/spree/products/321/original/base.png?1417607269"
parts = [
  [1, "https://s3.amazonaws.com/CustomBags/app/public/spree/products/375/original/body.png?1417607442"],
  [2, "https://s3.amazonaws.com/CustomBags/app/public/spree/products/550/original/short-strap.png?1418106447"],
  [3, "https://s3.amazonaws.com/CustomBags/app/public/spree/products/569/original/hardware.png?1417608404"],
  [4, "https://s3.amazonaws.com/CustomBags/app/public/spree/products/424/original/gusset.png?1417607650"],
  [5, "https://s3.amazonaws.com/CustomBags/app/public/spree/products/467/original/piping.png?1417607851"]
]

builder = BagBuilder.new(base, parts)
builder.build
puts builder.output_image_path
