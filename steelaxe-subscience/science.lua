data:extend({
  {
      type = "item-subgroup",
      name = "steelaxe-subscience-pack",
      group = "intermediate-products",
      order = "zz"
  }
})

local numPacks = settings.startup["steelaxe-subscience-new-pack-count"].value
if numPacks < 1 then
  numPacks = 1
end

local medDiffThresh = 3
local hardDiffThresh = 3

if (numPacks >= 3) then
  medDiffThresh = math.floor(numPacks/3)
  hardDiffThresh = 2 * medDiffThresh
end

local diff = "easy"

for i = 1, numPacks
do
  if (i >= hardDiffThresh) then
    diff = "hard"
  elseif (i >= medDiffThresh) then
    diff = "med"
  end
  local item = table.deepcopy(data.raw["tool"]["automation-science-pack"])
  item.name = "subscience" .. i
  item.localised_name = "Sub Science " .. i
  item.order = "z[" .. string.format("%3d", i) .. "]"
  item.subgroup = "steelaxe-subscience-pack"

  local recipe = table.deepcopy(data.raw["recipe"]["automation-science-pack"])
  recipe.name = "subscience" .. i
  recipe.result = item.name
  recipe.result_count = 3
  -- recipe.ingredients, recipe.energy_required = randomRecipe(diff)
  recipe.ingredients = {{"iron-plate", 10}}
  recipe.enabled = false

  local tech = {
    effects = {
      {
        recipe = recipe.name,
        type = "unlock-recipe"
      }
    },
    icon = "__base__/graphics/technology/automation-science-pack.png",
    icon_mipmaps = 4,
    icon_size = 256,
    name = item.name,
    localised_name = item.localised_name,
    localised_description = string.format("Add to goals after reaching %d subscribers.", i * 5),
    order = "z[" .. string.format("%3d", i) .. "]",
    type = "technology",
    unit = {
      count = 100,
      ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"military-science-pack", 1},
        {"chemical-science-pack", 1},
        {"production-science-pack", 1},
        {"utility-science-pack", 1},
        {"space-science-pack", 1},
      },
      time = 30
    }
  }

  if (i == 1) then
    tech.prerequisites = {
      "space-science-pack"
    }
  else
    tech.prerequisites = {
      "subscience" .. i - 1
    }
  end

  for j = 1,i-1
  do
    local prevSci = {"subscience" .. j, 1}
    table.insert(tech.unit.ingredients, prevSci)
  end

  data:extend({item, recipe, tech})
end
