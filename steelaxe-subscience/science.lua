-- add subgroup so science recipes start on new row in crafting menu
data:extend({
  {
      type = "item-subgroup",
      name = "steelaxe-subscience-pack",
      group = "intermediate-products",
      order = "zz"
  }
})

local easyMaxIndex = 94
local medMaxIndex = 140
local hardMaxIndex = 162

-- define recipe templates for each level of difficulty
local diff_master = 
{
  easy = {
    maxIngIndex = easyMaxIndex,
    ings = {
      "A", "A", "B"
    },
  },
  med = {
    maxIngIndex = medMaxIndex,
    ings = {
      "A", "A", "B", "B"
    }
  },
  hard = {
    maxIngIndex = hardMaxIndex,
    ings = {
      "A", "A", "B", "B"
    }
  }
}

-- get list of ingredients
-- these are most items in the game, but some very expensive items (such as the rocket silo and spidertron) have been excluded
-- some very cheap items such as iron ore and copper cable have also been excluded
-- the items are ordered into easy, medium, and hard segments
local ingredient_list = require("ingredients")

-- get seed value
-- max seed value 4,294,967,295
local seed = settings.startup["steelaxe-subscience-random-seed"].value
math.randomseed(seed)

-- function to return a random ingredient given a specified max index in the ingredient list and the ingredient type (A or B)
function randomIng(maxIndex, ingType)
  local ingName = ingredient_list[math.random(maxIndex)]
  local qty

  local probRangeRoll = math.random()
  
  if (ingType == "A") then
    if (probRangeRoll < .9) then -- range 1 - 4
      qty = math.random(1, 4)
    else -- range 5 - 8
      qty = math.random(5, 8)
    end
  else -- range uniform dist between 5 and 20
    qty = math.random(5, 20)
  end

  local retIng = { ingName, qty }
  return retIng
end

-- list of fluids; a fluid recipe and its fluid ingredient(s) are built differently than non-fluid receipes and ingredients
local fluidList = 
{
["heavy-oil"] = true,
["light-oil"] = true,
["lubricant"] = true,
["petroleum-gas"] = true,
["sulfuric-acid"] = true,
["water"] = true,
["steam"] = true
}

-- list of never stackable ingredients
local nonstackable =
{
  ["modular-armor"] = true,
  ["spidertron-remote"] = true
}

function hueToRGB(hue)
  local hue_sector = math.floor(hue / 60)
  local hue_sector_offset = (hue / 60) - hue_sector

  local value = 1
  local p = 0
  local q = 1 - hue_sector_offset
  local t = hue_sector_offset

  if hue_sector == 0 then
    return {value, t, p}
  elseif hue_sector == 1 then
    return {q, value, p}
  elseif hue_sector == 2 then
    return {p, value, t}
  elseif hue_sector == 3 then
    return {p, q, value}
  elseif hue_sector == 4 then
    return {t, p, value}
  elseif hue_sector == 5 then
  	return {value, p, q}
  end
end

-- build a recipe for a specified difficulty threshold (easy, medium, or hard)
function randomRecipe(diff)
  local ingList = {}
  local diffPattern = diff_master[diff]
  for _, ingType in ipairs(diffPattern.ings) do
    ingList[#ingList + 1] = randomIng(diffPattern.maxIngIndex, ingType)
  end

  local dedupeIngList = {}
  for _, v in ipairs(ingList) do
    local name = v[1]
    local qty = v[2]
    dedupeIngList[name] = (dedupeIngList[name] or 0) + qty
  end

  local finalRet = {}
  local recipeCategory = "crafting"
  local amount_of_fluid_ingreds = 0
  for k, v in pairs(dedupeIngList) do
    local ing
    if (fluidList[k]) then
      amount_of_fluid_ingreds = amount_of_fluid_ingreds + 1
      ing = { amount = v, name = k, type = "fluid" }
    else
      if (nonstackable[k]) then
        ing = { k, 1 }
      else
        ing = { k, v }
      end
    end
    finalRet[#finalRet + 1] = ing
  end

  if amount_of_fluid_ingreds == 1 then
    recipeCategory = "crafting-with-fluid"
  elseif amount_of_fluid_ingreds == 2 then
    recipeCategory = "chemistry"
  elseif amount_of_fluid_ingreds > 2 then
    error("Sorry but recipes with more than 2 fluid ingredients aren't supported yet.")
  end

  return finalRet, recipeCategory
end

-- get the number of subscribers per tech goal for tech flavor text
local subsPerTech = settings.startup["steelaxe-subscience-subspertech"].value

-- get the number of packs to produce
local numPacks = settings.startup["steelaxe-subscience-new-pack-count"].value

-- define default thresholds
local medDiffThresh = settings.startup["steelaxe-subscience-first-medium"].value
local hardDiffThresh = settings.startup["steelaxe-subscience-first-hard"].value

-- initial difficulty is easy
local diff = "easy"

for i = 1, numPacks
do
  -- set difficulty based on thresholds passed
  if (i >= hardDiffThresh) then
    diff = "hard"
  elseif (i >= medDiffThresh) then
    diff = "med"
  end

  -- build item
  local item = table.deepcopy(data.raw["tool"]["automation-science-pack"])
  item.name = "subscience" .. i
  item.localised_name = "Sub Science " .. i
  item.order = "z[" .. string.format("%4d", i) .. "]"
  item.subgroup = "steelaxe-subscience-pack"
  item.icon = nil
  item.icons = { {icon = "__steelaxe-subscience__/graphics/icons/sub-science-pack64x64_" .. i .. ".png", tint = hueToRGB((i * 2) % 360)} }

  -- build recipe to build item
  local recipe = table.deepcopy(data.raw["recipe"]["automation-science-pack"])
  recipe.name = "subscience" .. i
  recipe.result = item.name
  recipe.result_count = 3
  recipe.energy_required = math.random(13, 25)
  recipe.ingredients, recipe.category = randomRecipe(diff)
  recipe.enabled = false

  -- build technology to unlock recipe
  local tech = {
    effects = {
      {
        recipe = recipe.name,
        type = "unlock-recipe"
      }
    },
    icons = { {icon = "__steelaxe-subscience__/graphics/icons/sub-science-pack64x64_" .. i .. ".png", tint = hueToRGB((i * 2) % 360)} },
    icon_size = 64,
    name = item.name,
    localised_name = item.localised_name,
    localised_description = string.format("Add to goals at %d subscribers.", i * subsPerTech),
    order = "z[" .. string.format("%4d", i) .. "]",
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

  -- set technology prerequisite
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

  -- add item, recipe, tech to data
  data:extend({item, recipe, tech})
end
