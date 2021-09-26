local numPacks = settings.startup["steelaxe-subscience-new-pack-count"].value

for key, val in pairs(data.raw.lab) do
    if val.inputs ~= nil then
        lab_inputs = {}
        for _, lab_input in pairs(val.inputs) do
            lab_inputs[lab_input] = true
        end
        for i=1, numPacks do
            if not lab_inputs["subscience" .. i] then
                table.insert(data.raw.lab[key].inputs, "subscience" .. i)
                -- log("Added " .. SciencePackGalore.prefix("science-pack-" .. i) .. " to the lab " .. key .. ".")
            end
        end
    end
end

for i=1, numPacks do
  table.insert(data.raw.module["productivity-module"].limitation, "subscience" .. i)
end

-- if any other mods wanted these to be different: Sorry, I'm lazy - Bilka
data.raw.module["productivity-module-2"].limitation = table.deepcopy(data.raw.module["productivity-module"].limitation)
data.raw.module["productivity-module-3"].limitation = table.deepcopy(data.raw.module["productivity-module"].limitation)