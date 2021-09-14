data:extend({
  {
    type = "int-setting",
    minimum_value = "1",
    maximum_value = "1000",
    default_value = "1000",
    name = "steelaxe-subscience-new-pack-count",
    setting_type = "startup",
    localised_name = "New science pack count",
    localised_description = "Number of new science packs to generate. Integer between 1 and 1000."
  },
  {
    type = "int-setting",
    minimum_value = "0",
    maximum_value = "4294967295",
    default_value = "0",
    name = "steelaxe-subscience-random-seed",
    setting_type = "startup",
    localised_name = "Recipe random seed",
    localised_description = "Seed for recipe randomization. Integer between 0 and 4294967295."
  }
})