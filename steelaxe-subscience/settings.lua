data:extend({
  {
    type = "int-setting",
    minimum_value = "1",
    maximum_value = "1000",
    default_value = "500",
    name = "steelaxe-subscience-new-pack-count",
    setting_type = "startup",
    localised_name = "New science pack count",
    localised_description = "Number of new science packs to generate. Integer between 1 and 1000.",
    order = "1"
  },
  {
    type = "int-setting",
    minimum_value = "1",
    maximum_value = "1000",
    default_value = "25",
    name = "steelaxe-subscience-first-medium",
    setting_type = "startup",
    localised_name = "First medium science pack",
    localised_description = "Medium science packs have 2 low avg qty ingredients and 2 high avg qty ingredients. Ingredient challenge ranges from easy to medium.",
    order = "2"
  },
  {
    type = "int-setting",
    minimum_value = "1",
    maximum_value = "1000",
    default_value = "50",
    name = "steelaxe-subscience-first-hard",
    setting_type = "startup",
    localised_name = "First hard science pack",
    localised_description = "Hard science packs have 2 low avg qty ingredients and 2 high avg qty ingredients. Ingredient challenge ranges from easy to hard.",
    order = "3"
  },
  {
    type = "int-setting",
    minimum_value = "0",
    maximum_value = "4294967295",
    default_value = "0",
    name = "steelaxe-subscience-random-seed",
    setting_type = "startup",
    localised_name = "Recipe random seed",
    localised_description = "Seed for recipe randomization. Integer between 0 and 4294967295.",
    order = "4"
  },
  {
    type = "int-setting",
    minimum_value = "1",
    maximum_value = "10",
    default_value = "5",
    name = "steelaxe-subscience-subspertech",
    setting_type = "startup",
    localised_name = "Subs per tech",
    localised_description = "For every X subs, Anti must unlock a new science pack via research. " .. 
      "This setting only affects the flavor text of science techs which indicate the point at which each tech should be researched.",
    order = "5"
  }
})
