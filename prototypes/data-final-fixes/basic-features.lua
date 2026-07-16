-- 修复设置的问题
-- 允许全部机器使用全部模块
if settings.startup["enable-allow-all-machines-use-all-modules"].value then
    local allowed_effects = {
        "consumption", "speed", "productivity", "pollution"
    }

    -- 修复模组的问题
    -- 修复模组 quality 的问题
    if mod_enabled("quality") then table.insert(allowed_effects, "quality") end

    -- 修复实体的问题
    -- 遍历全部 raw
    for _, prototypes in pairs(data.raw) do
        -- 遍历全部 prototype
        for _, prototype in pairs(prototypes) do
            if prototype.module_slots and prototype.module_slots > 0 then
                -- 允许插入全部模块类别
                prototype.allowed_module_categories = nil

                -- 允许使用全部模块效果
                prototype.allowed_effects = allowed_effects
            end
        end
    end
end

--
--
--

-- 允许全部配方使用全部模块
if settings.startup["enable-allow-all-recipes-use-all-modules"].value then
    -- 修复配方的问题
    -- 遍历全部配方
    for _, recipe in pairs(data.raw.recipe) do
        -- 允许使用全部模块类别
        recipe.allowed_module_categories = nil

        -- 允许能耗模块效果
        recipe.allow_consumption = true

        -- 允许污染模块效果
        recipe.allow_pollution = true

        -- 允许生产力模块效果
        recipe.allow_productivity = true

        -- 允许速度模块效果
        recipe.allow_speed = true
    end
end

--
--
--

-- 始终显示配方制造机器
if settings.startup["enable-always-show-recipe-made-in"].value then
    for _, recipe in pairs(data.raw.recipe) do
        recipe.always_show_made_in = true
    end
end

--
--
--

-- 禁用机械臂超限装填
if settings.startup["enable-disable-inserter-overload"].value then
    for _, recipe in pairs(data.raw["recipe"]) do
        recipe.allow_inserter_overload = false
    end
end

--
--
--

-- 显示并启用所有隐藏科技
if settings.startup["enable-display-all-hidden-technologies"].value then
    for technology_id, technology in pairs(data.raw["technology"]) do
        if technology.hidden == true or
            (technology.enabled == false and technology.visible_when_disabled ~=
                true) then
            log("Technology " .. technology_id .. " was originally hidden.")

            technology.hidden = false
            technology.enabled = true
            technology.visible_when_disabled = false
        end
    end
end

--
--
--

-- 电线杆照明模式
if settings.startup["enable-electric-pole-free-lighting-mode"].value then
    -- 修复实体的问题
    -- 修复实体 electric-pole 的问题
    if entity_exist("lamp", "small-lamp") then
        local small_lamp_entity = data.raw["lamp"]["small-lamp"]

        -- 遍历全部电线杆
        for _, electric_pole_entity in pairs(data.raw["electric-pole"]) do
            electric_pole_entity.light = table.deepcopy(small_lamp_entity.light)
        end
    end
end

--
--
--

-- 熔炉配方选择
if settings.startup["enable-furnace-recipe-selection"].value then
    for id, entity in pairs(data.raw["furnace"]) do
        if entity.source_inventory_size > 0 and entity.result_inventory_size > 0 then
            local furnace = table.deepcopy(entity)
            furnace.type = "assembling-machine"

            data.raw.furnace[id] = nil

            data:extend{furnace}
        end
    end
end

--
--
--

-- 无限资源
if settings.startup["enable-infinite-resources"].value then
    local mining_resources = {}
    local mining_resource_categories = {}

    if data.raw["mining-drill"] then
        for _, mining_drill in pairs(data.raw["mining-drill"]) do
            if mining_drill.resource_categories then
                for _, resource_category in pairs(
                                                mining_drill.resource_categories) do
                    if #mining_resource_categories == 0 then
                        table.insert(mining_resource_categories,
                                     resource_category)
                    else
                        local mining_resource_exist = false

                        for index, _ in ipairs(mining_resource_categories) do
                            if resource_category ==
                                mining_resource_categories[index] then
                                mining_resource_exist = true

                                break
                            end
                        end

                        if not mining_resource_exist then
                            table.insert(mining_resource_categories,
                                         resource_category)
                        end
                    end
                end
            end
        end
    end

    if data.raw["resource"] then
        for _, mining_resource in pairs(data.raw.resource) do
            for _, mining_resource_category in
                ipairs(mining_resource_categories) do
                if (mining_resource.category == nil and mining_resource_category ==
                    "basic-solid") or mining_resource.category ==
                    mining_resource_category then
                    table.insert(mining_resources, mining_resource.name)

                    break
                end
            end
        end
    end

    for _, mining_resource in ipairs(mining_resources) do
        local mining_resource = data.raw["resource"][mining_resource]

        mining_resource.infinite = true
        mining_resource.minimum = 1
        mining_resource.normal = 1
    end
end

--
--
--

-- 采矿机物品过滤
if settings.startup["enable-mining-drill-item-filter-mode"].value then
    -- 遍历全部采矿机
    for _, mining_drill in pairs(data.raw["mining-drill"]) do
        if not mining_drill.filter_count then
            mining_drill.filter_count = 5
        end
    end
end

--
--
--

-- 修改全部装备大小为 1x1
if settings.startup["enable-modify-all-equipment-grid-occupancy-sizes-to-one"]
    .value then
    -- 遍历 raw
    for _, prototypes in pairs(data.raw) do
        -- 遍历 prototype
        for _, prototype in pairs(prototypes) do
            if prototype.shape then
                prototype.shape = {width = 1, height = 1, type = "full"}
            end
        end
    end
end

--
--
--

-- 优化科技树
-- 定义函数 has_prerequisite
local function has_prerequisite(technology_id, prerequisite_id,
                                current_technology_id, visited)
    if technology_id == current_technology_id then return false end
    if visited[technology_id] then return false end

    visited[technology_id] = true

    local technology = data.raw["technology"][technology_id]

    if technology == nil or technology.prerequisites == nil then return false end

    for _, prerequisite in ipairs(technology.prerequisites) do
        if prerequisite ~= current_technology_id then
            if prerequisite == prerequisite_id or
                has_prerequisite(prerequisite, prerequisite_id,
                                 current_technology_id, visited) then
                return true
            end
        end
    end

    return false
end

if settings.startup["enable-optimize-technology-tree"].value then
    -- 删除递归前置科技
    for technology_id, technology in pairs(data.raw["technology"]) do
        local prerequisites = technology.prerequisites

        if prerequisites and #prerequisites > 1 then
            local optimized_prerequisites = {}

            for _, prerequisite in ipairs(prerequisites) do
                local redundant = false

                for _, other_prerequisite in ipairs(prerequisites) do
                    if prerequisite ~= other_prerequisite and
                        has_prerequisite(other_prerequisite, prerequisite,
                                         technology_id, {}) then
                        redundant = true
                        break
                    end
                end

                if not redundant then
                    table.insert(optimized_prerequisites, prerequisite)
                end
            end

            technology.prerequisites = optimized_prerequisites
        end
    end

    -- 输出被不同科技重复解锁的配方
    local recipe_unlock_technologies = {}

    for technology_id, technology in pairs(data.raw["technology"]) do
        if technology.effects then
            for _, effect in ipairs(technology.effects) do
                if effect.type == "unlock-recipe" and effect.recipe then
                    recipe_unlock_technologies[effect.recipe] =
                        recipe_unlock_technologies[effect.recipe] or {}

                    recipe_unlock_technologies[effect.recipe][technology_id] =
                        true
                end
            end
        end
    end

    for recipe_id, technology_set in pairs(recipe_unlock_technologies) do
        local technology_ids = {}

        for technology_id in pairs(technology_set) do
            table.insert(technology_ids, technology_id)
        end

        if #technology_ids > 1 then
            log("Recipe " .. recipe_id .. " is unlocked by technologies: " ..
                    table.concat(technology_ids, ", "))
        end
    end

    -- 输出效果为空的科技
    for technology_id, technology in pairs(data.raw["technology"]) do
        if technology.effects == nil or next(technology.effects) == nil then
            log("Technology " .. technology_id .. " has no effects.")
        end
    end
end

-- 随地放置抽水泵
if settings.startup["enable-place-offshore-pumps-anywhere"].value then
    -- 修复地块的问题
    -- 遍历所有地块
    for _, tile in pairs(data.raw["tile"]) do
        -- 给没有流体属性的地块添加流体水
        if tile.fluid == nil then tile.fluid = "water" end
    end

    -- 修复实体的问题
    -- 修复实体 offshore-pump 的问题
    if entity_exist("offshore-pump", "offshore-pump") then
        table.remove(data.raw["offshore-pump"]["offshore-pump"]
                         .tile_buildability_rules, 2)
    end
end

--
--
--

-- 移除成就限制
if settings.startup["enable-remove-achievement-restrictions"].value then
    for _, prototypes in pairs(data.raw) do
        for _, prototype in pairs(prototypes) do
            if prototype.allowed_without_fight == false then
                prototype.allowed_without_fight = true
            end
        end
    end
end

--
--
--

-- 移除管网规模上限
if settings.startup["enable-remove-pipeline-extent-limit"].value then
    local function remove_pipeline_extent(current_table)
        for key, value in pairs(current_table) do
            if key == "max_pipeline_extent" then
                current_table[key] = nil
            elseif type(value) == "table" then
                remove_pipeline_extent(value)
            end
        end
    end

    remove_pipeline_extent(data.raw)
end

--
--
--

-- 显示最远距离位置
if settings.startup["enable-show-farthest-distance-position"].value then
    local farthest_distance_position_sprite =
        "__greceys-tweak-mod__/graphics/visualisation/farthest-distance-position.png"

    -- 地下传送带
    if data.raw["underground-belt"] then
        for _, entity in pairs(data.raw["underground-belt"]) do
            local max_distance = entity.max_distance + 1

            entity.radius_visualisation_specification = {
                sprite = {
                    filename = farthest_distance_position_sprite,
                    width = 64,
                    height = 64
                },
                distance = 0.5,
                offset = {0, -max_distance},
                draw_in_cursor = true,
                draw_on_selection = true
            }
        end
    end

    -- 地下管道
    if data.raw["pipe-to-ground"] then
        for _, entity in pairs(data.raw["pipe-to-ground"]) do
            local max_distance

            for _, connection in pairs(entity.fluid_box.pipe_connections) do
                if connection.max_underground_distance then
                    max_distance = connection.max_underground_distance + 1
                    break
                end
            end

            if max_distance then
                entity.radius_visualisation_specification = {
                    sprite = {
                        filename = farthest_distance_position_sprite,
                        width = 64,
                        height = 64
                    },
                    distance = 0.5,
                    offset = {0, -max_distance},
                    draw_in_cursor = true,
                    draw_on_selection = true
                }
            end
        end
    end
end

--
--
--

-- 虚空箱和虚空管
if settings.startup["enable-void-chest-and-void-pipe"].value then
    -- 修复实体的问题
    -- 修复实体 void_pipe_entity 的问题
    if entity_exist("pipe", "pipe") then
        local pipe_entity = data.raw["pipe"]["pipe"]
        local void_pipe_entity = data.raw["pipe"]["void-pipe"]

        if pipe_entity and void_pipe_entity then
            void_pipe_entity.fluid_box.pipe_connections = table.deepcopy(
                                                              pipe_entity.fluid_box
                                                                  .pipe_connections)
        end
    end
end

--
--
--

-- 调整角色制造速度乘数
local max_character_crafting_speed = 2 ^ 32 - 1
local character_crafting_speed_multiplier =
    settings.startup["adjust-character-crafting-speed-multiplier"].value

if character_crafting_speed_multiplier ~= 1 then
    for _, character in pairs(data.raw.character) do
        if character.crafting_speed then
            character.crafting_speed = math.min(
                                           character.crafting_speed *
                                               character_crafting_speed_multiplier,
                                           max_character_crafting_speed)
        end
    end
end

--
--
--

-- 调整角色自动恢复生命速度乘数
local max_character_healing_per_tick = 2 ^ 32 - 1
local character_healing_per_tick_multiplier =
    settings.startup["adjust-character-healing-per-tick-multiplier"].value

if character_healing_per_tick_multiplier ~= 1 then
    for _, character in pairs(data.raw.character) do
        if character.healing_per_tick then
            character.healing_per_tick = math.min(
                                             character.healing_per_tick *
                                                 character_healing_per_tick_multiplier,
                                             max_character_healing_per_tick)
        end
    end
end

--
--
--

-- 调整角色交互距离乘数
local max_character_interaction_distance = 2 ^ 32 - 1
local character_interaction_distance_multiplier =
    settings.startup["adjust-character-interaction-distance-multiplier"].value

if character_interaction_distance_multiplier ~= 1 then
    for _, character in pairs(data.raw.character) do
        -- 调整角色建造距离
        if character.build_distance then
            character.build_distance = math.min(
                                           character.build_distance *
                                               character_interaction_distance_multiplier,
                                           max_character_interaction_distance)
        end

        -- 调整角色交互距离
        if character.reach_distance then
            character.reach_distance = math.min(
                                           character.reach_distance *
                                               character_interaction_distance_multiplier,
                                           max_character_interaction_distance)
        end

        -- -- 调整角色资源交互距离
        if character.reach_resource_distance then
            character.reach_resource_distance = math.min(
                                                    character.reach_resource_distance *
                                                        character_interaction_distance_multiplier,
                                                    max_character_interaction_distance)
        end
    end
end

--
--
--

-- 调整角色最大生命值乘数
local max_character_health = 2 ^ 32 - 1
local character_health_multiplier =
    settings.startup["adjust-character-max-health-multiplier"].value

if character_health_multiplier ~= 1 then
    for _, character in pairs(data.raw.character) do
        if character.max_health then
            character.max_health = math.min(
                                       character.max_health *
                                           character_health_multiplier,
                                       max_character_health)
        end
    end
end

--
--
--

-- 调整角色采矿速度乘数
local max_character_mining_speed = 2 ^ 32 - 1
local character_mining_speed_multiplier =
    settings.startup["adjust-character-mining-speed-multiplier"].value

if character_mining_speed_multiplier ~= 1 then
    for _, character in pairs(data.raw.character) do
        if character.mining_speed then
            character.mining_speed = math.min(
                                         character.mining_speed *
                                             character_mining_speed_multiplier,
                                         max_character_mining_speed)
        end
    end
end

--
--
--

-- 调整角色重生时间乘数
local min_character_respawn_time = 0
local character_respawn_time_multiplier =
    settings.startup["adjust-character-respawn-time-multiplier"].value

if character_respawn_time_multiplier ~= 1 then
    for _, character in pairs(data.raw.character) do
        if character.respawn_time then
            character.respawn_time = math.max(
                                         character.respawn_time /
                                             character_respawn_time_multiplier,
                                         min_character_respawn_time)
        end
    end
end

--
--
--

-- 调整角色奔跑速度乘数
local max_character_running_speed = 2 ^ 32 - 1
local character_running_speed_multiplier =
    settings.startup["adjust-character-running-speed-multiplier"].value

if character_running_speed_multiplier ~= 1 then
    for _, character in pairs(data.raw.character) do
        if character.running_speed then
            character.running_speed = math.min(
                                          character.running_speed *
                                              character_running_speed_multiplier,
                                          max_character_running_speed)
        end
    end
end

--
--
--

-- 调整机械臂速度乘数
local max_inserter_speed = 2 ^ 32 - 1
local inserter_speed_multiplier =
    settings.startup["adjust-inserter-speed-multiplier"].value

if inserter_speed_multiplier ~= 1 then
    for _, inserter in pairs(data.raw["inserter"]) do
        -- 调整机械臂旋转速度
        if inserter.rotation_speed then
            inserter.rotation_speed = math.min(
                                          inserter.rotation_speed *
                                              inserter_speed_multiplier,
                                          max_inserter_speed)
        end

        -- 调整机械臂伸缩速度
        if inserter.extension_speed then
            inserter.extension_speed = math.min(
                                           inserter.extension_speed *
                                               inserter_speed_multiplier,
                                           max_inserter_speed)
        end
    end
end

--
--
--

-- 调整物品堆叠数量乘数
local max_item_stack_size = 2 ^ 32 - 1
local item_stack_size_multiplier =
    settings.startup["adjust-item-stack-size-multiplier"].value

if item_stack_size_multiplier ~= 1 then
    for _, prototypes in pairs(data.raw) do
        for _, item in pairs(prototypes) do
            if item.stack_size and item.stack_size > 1 then
                item.stack_size = math.min(
                                      math.floor(item.stack_size *
                                                     item_stack_size_multiplier),
                                      max_item_stack_size)
            end
        end
    end
end

--
--
--

-- 调整机器人速度乘数
local max_robot_speed = 2 ^ 32 - 1
local robot_speed_multiplier = settings.startup["adjust-robot-speed-multiplier"]
                                   .value

if robot_speed_multiplier ~= 1 then
    -- 调整物流机器人速度
    for _, robot in pairs(data.raw["logistic-robot"]) do
        if robot.speed then
            robot.speed = math.min(robot.speed * robot_speed_multiplier,
                                   max_robot_speed)
        end
    end

    -- 调整建设机器人速度
    for _, robot in pairs(data.raw["construction-robot"]) do
        if robot.speed then
            robot.speed = math.min(robot.speed * robot_speed_multiplier,
                                   max_robot_speed)
        end
    end
end

--
--
--

-- 调整传送带及其变种速度乘数
local max_transport_belt_speed = 2 ^ 32 - 1
local transport_belt_speed_multiplier =
    settings.startup["adjust-transport-belt-speed-multiplier"].value
local transport_belt_types = {
    "transport-belt", "underground-belt", "splitter", "loader", "loader-1x1",
    "linked-belt", "lane-splitter"
}

if transport_belt_speed_multiplier ~= 1 then
    for _, prototype_type in pairs(transport_belt_types) do
        for _, transport_belt in pairs(data.raw[prototype_type] or {}) do
            if transport_belt.speed then
                transport_belt.speed = math.min(
                                           transport_belt.speed *
                                               transport_belt_speed_multiplier,
                                           max_transport_belt_speed)
            end
        end
    end
end

