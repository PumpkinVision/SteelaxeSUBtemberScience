--[[
  Recipe randomization plan:
  Assuming we have at least 3 new packs, divide the pack sequence into thirds.
  Recipe randomization is used through, but for the first third of the sequence, the difficulty ceiling is low and the ingredient count is 3.
  For the second third of the sequence, the difficulty ceiling is raised and the ingrdient count is 4.
  For the final third of the sequence, the difficulty ceiling is raised further. The ingredient count remains 4.

  qty calculation

  two types of ingredients:
  A ingredient = 90% chance that qty will be between 1 and 4; 10% chance that qty will be between 5 and 8
  B ingredient = uniform probability distribution between 5 and 20
  The goal is to create recipes that resembles the recipe for purple science, which requires 1 electric furnace, 1 prod module, and 30 rail.
  
  There is nothing in the recipe generation process to guarantee that the higher qty ingredient will be easier than the lower qty ingredient.
  Ingredient difficulty is managed by having three tiers of ingredients: easy, medium, and hard. I have eyeballed the difficulty of different ingredients.
  I arranged the ingredients into a range from easy to hard. The random ingredient uses the random method to pick an index between 1 and a specified maximum value.
  If easy, our ingredient selector ranges from 1 to <max index for easy>. If medium, our ingredient selector ranges
  from 1 to <max index for medium>. And if hard, our ingredient selector ranges from 1 to <max index for hard>.

  recipe difficulty levels:
  easy (first third of the science packs)
    individual ingredient complexity - easy range
    2 A ingredients
    1 B ingredient
  med (second third of the science packs)
    individual ingredient complexity - easy or med range
    2 A ingredients
    2 B ingredients
  hard (final third of the science packs)
    individual ingredient complexity - easy, med, or hard range
    2 A ingredients
    2 B ingredients
    (Although the ingredient pattern is the same as medium, the addition of hard ingredients, together with the fact tha we still have to make
    all previous science packs for each round of research, should provide a significant, but hopefully sane, additional degree of difficulty.)
]]

-- add subgroup so science recipes start on new row in crafting menu
data:extend({
  {
      type = "item-subgroup",
      name = "steelaxe-subscience-pack",
      group = "intermediate-products",
      order = "zz"
  }
})

-- define recipe templates for each level of difficulty
local diff_master = 
{
  easy = {
    maxIngIndex = 106,
    ings = {
      "A", "A", "B"
    },
  },
  med = {
    maxIngIndex = 152,
    ings = {
      "A", "A", "B", "B"
    }
  },
  hard = {
    maxIngIndex = 174,
    ings = {
      "A", "A", "B", "B"
    }
  }
}

-- get list of ingredients
-- these are most items in the game, but some very expensive items (such as the rocket silo and spidertron) have been excluded
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
  for k, v in pairs(dedupeIngList) do
    local ing
    if (fluidList[k]) then
      recipeCategory = "crafting-with-fluid"
      ing = { amount = v, name = k, type = "fluid" }
    else
      ing = { k, v }
    end
    finalRet[#finalRet + 1] = ing
  end

  return finalRet, recipeCategory
end

-- get the number of packs to produce
local numPacks = settings.startup["steelaxe-subscience-new-pack-count"].value

-- define default thresholds
local medDiffThresh = 3
local hardDiffThresh = 3

-- if we have at least 3 packs, divide into thirds
if (numPacks >= 3) then
  medDiffThresh = math.floor(numPacks/3)
  hardDiffThresh = 2 * medDiffThresh
end

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
  item.icon = "__steelaxe-subscience__/graphics/icons/sub-science-pack64x64_" .. i .. ".png"
  item.icon_size = 64

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
    icon = "__steelaxe-subscience__/graphics/icons/sub-science-pack64x64_" .. i .. ".png",
    icon_size = 64,
    name = item.name,
    localised_name = item.localised_name,
    localised_description = string.format("Add to goals after reaching %d subscribers.", i * 5),
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
