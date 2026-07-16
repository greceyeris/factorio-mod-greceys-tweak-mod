-- 开局时启用终为白日模式
if settings.startup["enable-always-day-mode-at-game-start"].value then
    -- 修复快捷方式的问题
    -- 注册快捷方式 toggle-always-day-mode
    data:extend({
        {
            type = "shortcut",
            name = "toggle-always-day-mode",
            order = "z[toggle-always-day-mode]",
            action = "lua",
            toggleable = true,
            icon = "__greceys-tweak-mod__/graphics/icons/shortcut/always-day.png",
            icon_size = 64,
            small_icon = "__greceys-tweak-mod__/graphics/icons/shortcut/always-day.png",
            small_icon_size = 64
        }
    })
end

--
--
--

-- 电力熔炉
if settings.startup["enable-electric-furnaces"].value then
    local electric_blue_tint = {r = 0.20, g = 0.65, b = 1.00, a = 0.35}

    -- 修复实体的问题
    -- 注册实体 electric_stone_furnace_entity
    if entity_exist("furnace", "stone-furnace") then
        local stone_furnace_entity = data.raw["furnace"]["stone-furnace"]
        local electric_stone_furnace_entity = table.deepcopy(
                                                  stone_furnace_entity)

        electric_stone_furnace_entity.name = "electric-stone-furnace"
        electric_stone_furnace_entity.energy_source = {
            type = "electric",
            usage_priority = "secondary-input"
        }
        electric_stone_furnace_entity.minable.result = "electric-stone-furnace"
        electric_stone_furnace_entity.minable.results = nil
        electric_stone_furnace_entity.next_upgrade = nil

        if stone_furnace_entity.energy_source.emissions_per_minute then
            electric_stone_furnace_entity.energy_source.emissions_per_minute =
                table.deepcopy(stone_furnace_entity.energy_source
                                   .emissions_per_minute)

            for pollutant, amount in pairs(
                                         electric_stone_furnace_entity.energy_source
                                             .emissions_per_minute) do
                electric_stone_furnace_entity.energy_source.emissions_per_minute[pollutant] =
                    amount * 0.5
            end
        end

        local energy_value, energy_unit =
            stone_furnace_entity.energy_usage:match("^([%d%.]+)([%a]+)$")

        electric_stone_furnace_entity.energy_usage = tostring(tonumber(
                                                                  energy_value) *
                                                                  2) ..
                                                         energy_unit

        if electric_stone_furnace_entity.graphics_set and
            electric_stone_furnace_entity.graphics_set.animation then
            local animation = electric_stone_furnace_entity.graphics_set
                                  .animation

            if animation.layers then
                local layer_count = #animation.layers

                for index = 1, layer_count do
                    local layer = animation.layers[index]

                    if not layer.draw_as_shadow then
                        local electric_blue_layer = table.deepcopy(layer)

                        electric_blue_layer.tint = electric_blue_tint

                        table.insert(animation.layers, electric_blue_layer)
                    end
                end
            else
                local electric_blue_layer = table.deepcopy(animation)

                electric_blue_layer.tint = electric_blue_tint
                electric_stone_furnace_entity.graphics_set.animation = {
                    layers = {animation, electric_blue_layer}
                }
            end
        end

        stone_furnace_entity.next_upgrade = "electric-stone-furnace"

        data:extend({electric_stone_furnace_entity})
    end

    -- 注册实体 electric_steel_furnace_entity
    if entity_exist("furnace", "steel-furnace") then
        local steel_furnace_entity = data.raw["furnace"]["steel-furnace"]
        local electric_steel_furnace_entity = table.deepcopy(
                                                  steel_furnace_entity)

        electric_steel_furnace_entity.name = "electric-steel-furnace"
        electric_steel_furnace_entity.energy_source = {
            type = "electric",
            usage_priority = "secondary-input"
        }
        electric_steel_furnace_entity.minable.result = "electric-steel-furnace"
        electric_steel_furnace_entity.minable.results = nil
        electric_steel_furnace_entity.next_upgrade = nil

        if steel_furnace_entity.energy_source.emissions_per_minute then
            electric_steel_furnace_entity.energy_source.emissions_per_minute =
                table.deepcopy(steel_furnace_entity.energy_source
                                   .emissions_per_minute)

            for pollutant, amount in pairs(
                                         electric_steel_furnace_entity.energy_source
                                             .emissions_per_minute) do
                electric_steel_furnace_entity.energy_source.emissions_per_minute[pollutant] =
                    amount * 0.5
            end
        end

        local energy_value, energy_unit =
            steel_furnace_entity.energy_usage:match("^([%d%.]+)([%a]+)$")

        electric_steel_furnace_entity.energy_usage = tostring(tonumber(
                                                                  energy_value) *
                                                                  2) ..
                                                         energy_unit

        if electric_steel_furnace_entity.graphics_set and
            electric_steel_furnace_entity.graphics_set.animation then
            local animation = electric_steel_furnace_entity.graphics_set
                                  .animation

            if animation.layers then
                local layer_count = #animation.layers

                for index = 1, layer_count do
                    local layer = animation.layers[index]

                    if not layer.draw_as_shadow then
                        local electric_blue_layer = table.deepcopy(layer)

                        electric_blue_layer.tint = electric_blue_tint

                        table.insert(animation.layers, electric_blue_layer)
                    end
                end
            else
                local electric_blue_layer = table.deepcopy(animation)

                electric_blue_layer.tint = electric_blue_tint

                electric_steel_furnace_entity.graphics_set.animation = {
                    layers = {animation, electric_blue_layer}
                }
            end
        end

        steel_furnace_entity.next_upgrade = "electric-steel-furnace"

        data:extend({electric_steel_furnace_entity})
    end

    -- 修复物品的问题
    -- 注册物品 electric_stone_furnace_item
    if item_exist("stone-furnace") then
        local stone_furnace_item = data.raw["item"]["stone-furnace"]
        local electric_stone_furnace_item = table.deepcopy(stone_furnace_item)

        electric_stone_furnace_item.name = "electric-stone-furnace"
        electric_stone_furnace_item.order =
            (stone_furnace_item.order or "stone-furnace") .. "-a[electric]"
        electric_stone_furnace_item.place_result = "electric-stone-furnace"

        if electric_stone_furnace_item.icons then
            local icon_count = #electric_stone_furnace_item.icons

            for index = 1, icon_count do
                local electric_blue_icon = table.deepcopy(
                                               electric_stone_furnace_item.icons[index])

                electric_blue_icon.tint = electric_blue_tint

                table.insert(electric_stone_furnace_item.icons,
                             electric_blue_icon)
            end
        else
            local stone_furnace_icon = {
                icon = electric_stone_furnace_item.icon,
                icon_size = electric_stone_furnace_item.icon_size or 64
            }
            local electric_blue_icon = table.deepcopy(stone_furnace_icon)

            electric_blue_icon.tint = electric_blue_tint

            electric_stone_furnace_item.icons = {
                stone_furnace_icon, electric_blue_icon
            }
            electric_stone_furnace_item.icon = nil
            electric_stone_furnace_item.icon_size = nil
        end

        add_electricity_icon(electric_stone_furnace_item)

        data:extend({electric_stone_furnace_item})
    end

    -- 注册物品 electric_steel_furnace_item
    if item_exist("steel-furnace") then
        local steel_furnace_item = data.raw["item"]["steel-furnace"]
        local electric_steel_furnace_item = table.deepcopy(steel_furnace_item)

        electric_steel_furnace_item.name = "electric-steel-furnace"
        electric_steel_furnace_item.order =
            (steel_furnace_item.order or "steel-furnace") .. "-a[electric]"
        electric_steel_furnace_item.place_result = "electric-steel-furnace"

        if electric_steel_furnace_item.icons then
            local icon_count = #electric_steel_furnace_item.icons

            for index = 1, icon_count do
                local electric_blue_icon = table.deepcopy(
                                               electric_steel_furnace_item.icons[index])

                electric_blue_icon.tint = electric_blue_tint

                table.insert(electric_steel_furnace_item.icons,
                             electric_blue_icon)
            end
        else
            local steel_furnace_icon = {
                icon = electric_steel_furnace_item.icon,
                icon_size = electric_steel_furnace_item.icon_size or 64
            }
            local electric_blue_icon = table.deepcopy(steel_furnace_icon)

            electric_blue_icon.tint = electric_blue_tint

            electric_steel_furnace_item.icons = {
                steel_furnace_icon, electric_blue_icon
            }
            electric_steel_furnace_item.icon = nil
            electric_steel_furnace_item.icon_size = nil
        end

        add_electricity_icon(electric_steel_furnace_item)

        data:extend({electric_steel_furnace_item})
    end

    -- 修复配方的问题
    -- 注册配方 electric_stone_furnace_recipe
    if item_exist("copper-cable") and item_exist("electronic-circuit") then
        local stone_furnace_recipe = data.raw["recipe"]["stone-furnace"]
        local electric_stone_furnace_recipe = table.deepcopy(
                                                  stone_furnace_recipe)

        electric_stone_furnace_recipe.name = "electric-stone-furnace"
        electric_stone_furnace_recipe.ingredients = {
            {type = "item", name = "stone-furnace", amount = 1},
            {type = "item", name = "copper-cable", amount = 5},
            {type = "item", name = "electronic-circuit", amount = 2}
        }
        electric_stone_furnace_recipe.results = {
            {type = "item", name = "electric-stone-furnace", amount = 1}
        }
        electric_stone_furnace_recipe.main_product = "electric-stone-furnace"

        data:extend({electric_stone_furnace_recipe})
    end

    -- 注册配方 electric_steel_furnace_recipe
    if item_exist("copper-cable") and item_exist("electronic-circuit") then
        local steel_furnace_recipe = data.raw["recipe"]["steel-furnace"]
        local electric_steel_furnace_recipe = table.deepcopy(
                                                  steel_furnace_recipe)

        electric_steel_furnace_recipe.name = "electric-steel-furnace"
        electric_steel_furnace_recipe.ingredients = {
            {type = "item", name = "steel-furnace", amount = 1},
            {type = "item", name = "copper-cable", amount = 5},
            {type = "item", name = "electronic-circuit", amount = 2}
        }
        electric_steel_furnace_recipe.results = {
            {type = "item", name = "electric-steel-furnace", amount = 1}
        }
        electric_steel_furnace_recipe.main_product = "electric-steel-furnace"

        data:extend({electric_steel_furnace_recipe})
    end
end

--
--
--

-- 水资源
if settings.startup["enable-mineable-ground-water-resource"].value then
    -- 修复资源的问题
    -- 注册资源和自动放置控制
    if resource_exist("crude-oil") then
        local resource_autoplace = require("resource-autoplace")
        local water_blue_tint = {r = 0.15, g = 0.60, b = 1.00, a = 0.70}

        -- 注册资源 ground_water_resource
        local crude_oil_resource = data.raw["resource"]["crude-oil"]
        local ground_water_resource = table.deepcopy(crude_oil_resource)

        ground_water_resource.name = "ground-water"
        ground_water_resource.minable.results[1].name = "water"
        ground_water_resource.icons = {
            {
                icon = ground_water_resource.icon,
                icon_size = ground_water_resource.icon_size or 64,
                tint = water_blue_tint
            }
        }
        ground_water_resource.map_color = water_blue_tint
        ground_water_resource.stages.sheet.tint = water_blue_tint
        ground_water_resource.stages.sheet.tint_as_overlay = true

        for visualisation_index = #(ground_water_resource.stateless_visualisation or
            {}), 1, -1 do
            local visualisation =
                ground_water_resource.stateless_visualisation[visualisation_index]

            if visualisation.render_layer == "smoke" then
                table.remove(ground_water_resource.stateless_visualisation,
                             visualisation_index)
            elseif visualisation.animation then
                visualisation.animation.tint = water_blue_tint
                visualisation.animation.tint_as_overlay = true
            end
        end

        resource_autoplace.initialize_patch_set("ground-water", false)
        ground_water_resource.autoplace =
            resource_autoplace.resource_autoplace_settings({
                name = "ground-water",
                order = "c",
                base_density = 8.2,
                base_spots_per_km2 = 1.8,
                random_probability = 1 / 48,
                random_spot_size_minimum = 1,
                random_spot_size_maximum = 1,
                additional_richness = 220000,
                has_starting_area_placement = false,
                regular_rq_factor_multiplier = 1
            })

        -- 注册自动放置控制 ground_water_autoplace_control
        local crude_oil_autoplace_control =
            data.raw["autoplace-control"]["crude-oil"]
        local ground_water_autoplace_control = table.deepcopy(
                                                   crude_oil_autoplace_control)

        ground_water_autoplace_control.name = "ground-water"
        ground_water_autoplace_control.order = "a-e-1"
        ground_water_autoplace_control.localised_name = {
            "", "[entity=ground-water] ", {"entity-name.ground-water"}
        }

        data:extend({ground_water_resource, ground_water_autoplace_control})

        -- 允许在 nauvis 生成并显示其资源设置
        if data.raw["planet"]["nauvis"] then
            local nauvis = data.raw["planet"]["nauvis"]

            nauvis.map_gen_settings.autoplace_controls["ground-water"] = {}
            nauvis.map_gen_settings.autoplace_settings["entity"].settings["ground-water"] =
                {}
        end

        -- 修复模组的问题
        -- 修复模组 space-age 的问题
        if mod_enabled("space-age") then
            -- 修复资源放置控制的问题
            -- 允许在 aquilo 生成并显示其资源设置
            if data.raw["planet"]["aquilo"] then
                local aquilo = data.raw["planet"]["aquilo"]

                aquilo.map_gen_settings.autoplace_controls["ground-water"] = {}
                aquilo.map_gen_settings.autoplace_settings["entity"].settings["ground-water"] =
                    {}
            end
        end
    end
end

--
--
--

-- 造水料
if settings.startup["enable-waterfill"].value then
    -- 修复物品的问题
    -- 注册物品 waterfill_item
    if item_exist("landfill") then
        local landfill_item = data.raw["item"]["landfill"]
        local waterfill_item = table.deepcopy(landfill_item)

        waterfill_item.name = "waterfill"
        waterfill_item.icon =
            "__base__/graphics/terrain/water-shallow/water-shallow-o.png"
        waterfill_item.icons = nil
        waterfill_item.order = (landfill_item.order or "a[landfill]") ..
                                   "-a[waterfill]"
        waterfill_item.place_as_tile = {
            result = "water",
            condition_size = 1,
            condition = {layers = {ground_tile = true}}
        }

        data:extend({waterfill_item})
    end

    -- 修复配方的问题
    -- 注册配方 waterfill
    data:extend({
        {
            type = "recipe",
            name = "waterfill",
            order = "a",
            categories = {"crafting-with-fluid"},
            ingredients = {{type = "fluid", name = "water", amount = 200}},
            results = {{type = "item", name = "waterfill", amount = 1}},
            main_product = "waterfill",
            enabled = false
        }
    })

    -- 修复科技的问题
    -- 注册科技 waterfill_technology
    if technology_exist("landfill") then
        local waterfill_technology = table.deepcopy(
                                         data.raw["technology"]["landfill"])

        waterfill_technology.name = "waterfill"
        waterfill_technology.icon =
            "__base__/graphics/terrain/water-shallow/water-shallow-o.png"
        waterfill_technology.icon_size = 64
        waterfill_technology.icons = nil
        waterfill_technology.effects = {
            {type = "unlock-recipe", recipe = "waterfill"}
        }

        waterfill_technology.prerequisites =
            waterfill_technology.prerequisites or {}

        data:extend({waterfill_technology})

        add_technology_prerequisite(waterfill_technology.name, "automation-2")
    end
end

--
--
--

-- 虚空箱和虚空管
if settings.startup["enable-void-chest-and-void-pipe"].value then
    local void_purple_tint = {r = 0.55, g = 0.10, b = 0.80, a = 0.40}

    -- 修复实体的问题
    -- 注册实体 void_chest_entity
    if entity_exist("container", "iron-chest") then
        local iron_chest_entity = data.raw["container"]["iron-chest"]
        local void_chest_entity = table.deepcopy(iron_chest_entity)

        void_chest_entity.name = "void-chest"
        void_chest_entity.minable.result = "void-chest"
        void_chest_entity.minable.results = nil
        void_chest_entity.next_upgrade = nil
        void_chest_entity.fast_replaceable_group = nil

        if void_chest_entity.picture then
            local picture = void_chest_entity.picture

            if picture.layers then
                local layer_count = #picture.layers

                for index = 1, layer_count do
                    local layer = picture.layers[index]

                    if not layer.draw_as_shadow then
                        local void_purple_layer = table.deepcopy(layer)

                        void_purple_layer.tint = void_purple_tint

                        table.insert(picture.layers, void_purple_layer)
                    end
                end
            else
                local void_purple_layer = table.deepcopy(picture)

                void_purple_layer.tint = void_purple_tint
                void_chest_entity.picture = {
                    layers = {picture, void_purple_layer}
                }
            end
        end

        data:extend({void_chest_entity})
    end

    -- 注册实体 void_pipe_entity
    if entity_exist("pipe", "pipe") then
        local pipe_entity = data.raw["pipe"]["pipe"]
        local void_pipe_entity = table.deepcopy(pipe_entity)

        void_pipe_entity.name = "void-pipe"
        void_pipe_entity.minable.result = "void-pipe"
        void_pipe_entity.minable.results = nil
        void_pipe_entity.next_upgrade = nil
        void_pipe_entity.fast_replaceable_group = nil

        for picture_id, picture in pairs(void_pipe_entity.pictures) do
            -- 排除流体显示, 连接显示, 背景图层
            if not string.find(picture_id, "visualization", 1, true) and
                not string.find(picture_id, "background", 1, true) and
                not string.find(picture_id, "flow", 1, true) then
                if picture.layers then
                    local layer_count = #picture.layers

                    for index = 1, layer_count do
                        local layer = picture.layers[index]

                        if not layer.draw_as_shadow then
                            local void_purple_layer = table.deepcopy(layer)

                            void_purple_layer.tint = void_purple_tint

                            table.insert(picture.layers, void_purple_layer)
                        end
                    end
                else
                    local void_purple_layer = table.deepcopy(picture)

                    void_purple_layer.tint = void_purple_tint
                    void_pipe_entity.pictures[picture_id] = {
                        layers = {picture, void_purple_layer}
                    }
                end
            end
        end

        data:extend({void_pipe_entity})
    end

    -- 修复物品的问题
    -- 注册物品 void_chest_item
    if item_exist("iron-chest") then
        local iron_chest_item = data.raw["item"]["iron-chest"]
        local void_chest_item = table.deepcopy(iron_chest_item)

        void_chest_item.name = "void-chest"
        void_chest_item.order = (iron_chest_item.order or "iron-chest") ..
                                    "-a[void]"
        void_chest_item.place_result = "void-chest"

        if void_chest_item.icons then
            local icon_count = #void_chest_item.icons

            for index = 1, icon_count do
                local void_purple_icon = table.deepcopy(
                                             void_chest_item.icons[index])

                void_purple_icon.tint = void_purple_tint

                table.insert(void_chest_item.icons, void_purple_icon)
            end
        else
            local iron_chest_icon = {
                icon = void_chest_item.icon,
                icon_size = void_chest_item.icon_size or 64
            }
            local void_purple_icon = table.deepcopy(iron_chest_icon)

            void_purple_icon.tint = void_purple_tint
            void_chest_item.icons = {iron_chest_icon, void_purple_icon}
            void_chest_item.icon = nil
            void_chest_item.icon_size = nil
        end

        data:extend({void_chest_item})
    end

    -- 注册物品 void_pipe_item
    if item_exist("pipe") then
        local pipe_item = data.raw["item"]["pipe"]
        local void_pipe_item = table.deepcopy(pipe_item)

        void_pipe_item.name = "void-pipe"
        void_pipe_item.order = (pipe_item.order or "pipe") .. "-a[void]"
        void_pipe_item.place_result = "void-pipe"

        if void_pipe_item.icons then
            local icon_count = #void_pipe_item.icons

            for index = 1, icon_count do
                local void_purple_icon = table.deepcopy(
                                             void_pipe_item.icons[index])

                void_purple_icon.tint = void_purple_tint

                table.insert(void_pipe_item.icons, void_purple_icon)
            end
        else
            local pipe_icon = {
                icon = void_pipe_item.icon,
                icon_size = void_pipe_item.icon_size or 64
            }
            local void_purple_icon = table.deepcopy(pipe_icon)

            void_purple_icon.tint = void_purple_tint
            void_pipe_item.icons = {pipe_icon, void_purple_icon}
            void_pipe_item.icon = nil
            void_pipe_item.icon_size = nil
        end

        data:extend({void_pipe_item})
    end

    -- 修复配方的问题
    -- 注册配方 void_chest_recipe, iron_chest_from_void_chest_recipe
    if recipe_exist("iron-chest") then
        -- 注册配方 void-chest
        local iron_chest_recipe = data.raw["recipe"]["iron-chest"]
        local void_chest_recipe = table.deepcopy(iron_chest_recipe)

        void_chest_recipe.name = "void-chest"
        void_chest_recipe.ingredients = {
            {type = "item", name = "iron-chest", amount = 1}
        }
        void_chest_recipe.results = {
            {type = "item", name = "void-chest", amount = 1}
        }
        void_chest_recipe.main_product = "void-chest"

        -- 注册配方 iron-chest-from-void-chest
        local iron_chest_recipe = data.raw["recipe"]["iron-chest"]
        local iron_chest_from_void_chest_recipe = table.deepcopy(
                                                      iron_chest_recipe)

        iron_chest_from_void_chest_recipe.name = "iron-chest-from-void-chest"
        iron_chest_from_void_chest_recipe.ingredients = {
            {type = "item", name = "void-chest", amount = 1}
        }
        iron_chest_from_void_chest_recipe.results = {
            {type = "item", name = "iron-chest", amount = 1}
        }
        iron_chest_from_void_chest_recipe.main_product = "iron-chest"

        data:extend({void_chest_recipe, iron_chest_from_void_chest_recipe})
    end

    -- 注册配方 void_pipe_recipe, pipe_from_void_pipe_recipe
    if recipe_exist("pipe") then
        -- 注册配方 void-pipe
        local pipe_recipe = data.raw["recipe"]["pipe"]
        local void_pipe_recipe = table.deepcopy(pipe_recipe)

        void_pipe_recipe.name = "void-pipe"
        void_pipe_recipe.ingredients = {
            {type = "item", name = "pipe", amount = 1}
        }
        void_pipe_recipe.results = {
            {type = "item", name = "void-pipe", amount = 1}
        }
        void_pipe_recipe.main_product = "void-pipe"

        -- 注册配方 pipe-from-void-pipe
        local pipe_recipe = data.raw["recipe"]["pipe"]
        local pipe_from_void_pipe_recipe = table.deepcopy(pipe_recipe)

        pipe_from_void_pipe_recipe.name = "pipe-from-void-pipe"
        pipe_from_void_pipe_recipe.ingredients = {
            {type = "item", name = "void-pipe", amount = 1}
        }
        pipe_from_void_pipe_recipe.results = {
            {type = "item", name = "pipe", amount = 1}
        }
        pipe_from_void_pipe_recipe.main_product = "pipe"

        data:extend({void_pipe_recipe, pipe_from_void_pipe_recipe})
    end
end
