# SteelaxeSUBtemberScience
Steelaxe SUBtember Science mod for AntiElitz Sub Event Sept 2021

* Code hosted at https://github.com/PumpkinVision/SteelaxeSUBtemberScience
* Primary code is in science.lua.
* Ingredient list is in ingredients.lua.

* Mod settings accessible from Factorio
  * New science pack count - the number of science packs to generate. This must be an integer between 1 and 1000.
  * First medium science pack - the first science pack randomized using the medium recipe.
  * First hard science pack - the first science pack randomized using the hard recipe.
  * Recipe random seed - the random seed for recipe randomization. This must be an integer between 1 and 4294967295.

This Factorio mod defines up to 1000 new science packs. The research unlock for each science pack is 100 of the previous sciences, including all vanilla sciences. For example, to unlock the first new science, we feed the following to the labs:
* 100 red
* 100 green
* 100 blue
* 100 yellow
* 100 purple
* 100 military
* 100 space

  * The second new science pack will require all of that science plus 100 of the first new science.
  * The third new science pack will require all of the vanilla science, 100 of the first science, and 100 of the second science.

The production recipe for each new science is random. The rest of the game is vanilla. The new sciences are introduced only to provide large, random production goals. They do not unlock new technologies apart from additional science. The player selects how many science packs to generate in mod settings.

## Recipe randomization plan
### Overview
* The recipes are random, but the randomization is controlled.
* The first set of science packs encountered have an "easy" difficulty. The next, "medium", and the final, "hard". (Note that the earlier sciences have to be run again and again to research later sciences. If a recipe is going to be hard, we do not want it to be an early recipe.)
* The player chooses how many science packs to generate.
* The player chooses when the sequence of recipes transitions from easy to medium and from medium to hard.
  * In settings, they choose the first science pack that will be medium and the first science pack that will be hard. These settings default to the values 25 and 50.
* The player chooses the seed used by the randomizer.

### Templates
All recipes are built according to templates.

* The templates make use of two 'types' of ingredients.
  * "low average qty" ingredients have a 90% chance of having a qty between 1 and 5 and a 10% chance of having a qty between 6 and 8.
  * "high average qty" ingredients have an even chance of having a qty between 5 and 20.

Note that a "low" average qty ingredient can reach as high as 8 and a "high" average ingredient can reach as low as 5. So higher average qty ingredients aren't guaranteed to be higher; they are just higher on average, and they have a higher ceiling.

Recipes are also managed by restricting the ingredients that may be randomly selected. First, ingredients were eyeballed to exclude some as too easy or too hard. These ingredients (iron ore, copper cable, nuclear reactors, silos, etc.) are excluded from all recipes. Ranges were then established for "easy", "medium", and "hard", also based on the eyeball method.

### Recipe difficulty levels
* easy recipe
  * individual ingredient challenge - easy range
  * 2 low avg qty ingredients
  * 1 high avg qty ingredient
* med recipe (first used per user setting and then used until user setting for first hard recipe)
  * individual ingredient challenge - easy or med range
  * 2 low avg qty ingredients
  * 2 high avg qty ingredients
* hard recipe (first used per user setting)
  * individual ingredient challenge - easy, med, or hard range
  * 2 low avg qty ingredients
  * 2 high avg qty ingredients
  * (Although the hard recipe ingredient pattern is the same as medium, the addition of hard ingredients, together with the fact that we still have to make all previous science packs for each round of research, should make hard recipes feel significantly harder.)

When selecting ingredients for each recipe slot, no attempt is made to avoid selecting an already selected ingredient. If this happens, the two slots are combined and the qtys summed. This means that some recipes can have fewer than the initially planned number of ingredients, although the qtys will, on average, be higher than if no consolidation had occurred.

Note that a hard recipe may select from the easy, medium, or hard ranges. It is not guaranteed to select from the hard range. Likewise, a medium recipe may choose from easy or medium ingredients. It does not exclude easy ingredients, nor are medium ingredients weighted over easy. Simply based on counts, there is a bias towards easy ingredients. Perhaps a future version of this mod will address this by introducing a countering bias (to some degree) towards harder ingredients.

### Ingredient challenge ranges
* easy ingredients
  * accumulator
  * arithmetic-combinator
  * assembling-machine-1
  * battery
  * big-electric-pole
  * boiler
  * cannon-shell
  * car
  * cargo-wagon
  * chemical-plant
  * coal
  * concrete
  * constant-combinator
  * construction-robot
  * copper-plate
  * decider-combinator
  * discharge-defense-remote
  * effectivity-module
  * electric-mining-drill
  * electronic-circuit
  * empty-barrel
  * engine-unit
  * explosive-cannon-shell
  * explosive-rocket
  * explosives
  * express-splitter
  * express-transport-belt
  * express-underground-belt
  * fast-inserter
  * fast-splitter
  * fast-transport-belt
  * fast-underground-belt
  * firearm-magazine
  * flamethrower
  * flamethrower-ammo
  * fluid-wagon
  * gate
  * grenade
  * hazard-concrete
  * heavy-oil
  * inserter
  * iron-chest
  * iron-plate
  * landfill
  * land-mine
  * light-oil
  * logistic-chest-active-provider
  * logistic-chest-buffer
  * logistic-chest-passive-provider
  * logistic-chest-requester
  * logistic-chest-storage
  * logistic-robot
  * long-handed-inserter
  * lubricant
  * medium-electric-pole
  * offshore-pump
  * petroleum-gas
  * piercing-rounds-magazine
  * piercing-shotgun-shell
  * pipe
  * pipe-to-ground
  * plastic-bar
  * poison-capsule
  * power-switch
  * productivity-module
  * programmable-speaker
  * pump
  * rail
  * rail-chain-signal
  * rail-signal
  * repair-pack
  * rocket
  * shotgun-shell
  * slowdown-capsule
  * small-lamp
  * speed-module
  * splitter
  * steam
  * steam-engine
  * steel-chest
  * steel-furnace
  * steel-plate
  * stone-brick
  * stone-furnace
  * stone-wall
  * storage-tank
  * sulfur
  * sulfuric-acid
  * train-stop
  * transport-belt
  * underground-belt
  * water
  * wood
  * wooden-chest
      
* medium ingredients
  * advanced-circuit
  * artillery-shell
  * artillery-targeting-remote
  * artillery-wagon
  * assembling-machine-2
  * battery-equipment
  * belt-immunity-equipment
  * cliff-explosives
  * cluster-grenade
  * combat-shotgun
  * effectivity-module-2
  * electric-engine-unit
  * electric-furnace
  * energy-shield-equipment
  * filter-inserter
  * flamethrower-turret
  * flying-robot-frame
  * gun-turret
  * heat-pipe
  * lab
  * laser-turret
  * light-armor
  * locomotive
  * low-density-structure
  * night-vision-equipment
  * oil-refinery
  * productivity-module-2
  * pumpjack
  * radar
  * refined-concrete
  * refined-hazard-concrete
  * roboport
  * rocket-control-unit
  * rocket-fuel
  * rocket-launcher
  * shotgun
  * solar-panel
  * solar-panel-equipment
  * solid-fuel
  * speed-module-2
  * spidertron-remote
  * stack-filter-inserter
  * stack-inserter
  * submachine-gun
  * substation
  * tank  

* hard ingredients
  * artillery-turret
  * assembling-machine-3
  * atomic-bomb
  * battery-mk2-equipment
  * beacon
  * defender-capsule
  * distractor-capsule
  * exoskeleton-equipment
  * explosive-uranium-cannon-shell
  * heat-exchanger
  * heavy-armor
  * modular-armor
  * nuclear-fuel
  * personal-roboport-equipment
  * processing-unit
  * steam-turbine
  * uranium-235
  * uranium-238
  * uranium-cannon-shell
  * uranium-fuel-cell
  * uranium-ore
  * uranium-rounds-magazine

* too easy ingredients (excluded as science pack ingredients)
  * burner-inserter
  * burner-mining-drill
  * copper-cable
  * copper-ore
  * crude-oil
  * green-wire
  * iron-gear-wheel
  * iron-ore
  * iron-stick
  * pistol
  * red-wire
  * small-electric-pole
  * stone

* too hard ingredients (excluded as science pack ingredients)
  * centrifuge
  * destroyer-capsule
  * discharge-defense-equipment
  * effectivity-module-3
  * energy-shield-mk2-equipment
  * fusion-reactor-equipment
  * nuclear-reactor
  * personal-laser-defense-equipment
  * personal-roboport-mk2-equipment
  * power-armor
  * power-armor-mk2
  * productivity-module-3
  * raw-fish (very dependent on coastline)
  * rocket-silo
  * satellite
  * speed-module-3
  * spidertron
  * used-up-uranium-fuel-cell
  