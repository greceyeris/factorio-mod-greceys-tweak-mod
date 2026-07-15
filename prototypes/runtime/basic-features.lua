-- 定义函数运行时清空全部虚空箱的库存
local function runtime_clear_all_void_chests_inventory()
    -- 遍历全部地表
    for _, surface in pairs(game.surfaces) do
        -- 遍历全部虚空箱
        for _, void_chest in pairs(surface.find_entities_filtered({
            name = "void-chest"
        })) do
            -- 清空全部虚空箱的库存
            void_chest.get_inventory(defines.inventory.chest).clear()
        end
    end
end

--
--
--

-- 定义函数运行时清空全部虚空管的流体
local function runtime_clear_all_void_pipes_fluid()
    -- 遍历全部地表
    for _, surface in pairs(game.surfaces) do
        -- 遍历全部虚空管
        for _, void_pipe in pairs(surface.find_entities_filtered({
            name = "void-pipe"
        })) do
            -- 清空全部虚空管的流体
            void_pipe.clear_fluid(1)
        end
    end
end

--
--
--

-- 定义函数运行时设置全部资源产量为 1
local function runtime_set_all_resource_amount_to_one()
    -- 遍历全部地表
    for _, surface in pairs(game.surfaces) do
        -- 遍历全部资源
        for _, resource in pairs(surface.find_entities_filtered({
            type = "resource"
        })) do resource.amount = 1 end
    end
end

--
--
--

-- 初始化时触发
script.on_init(function()
    -- 开局时移除坠机现场
    if settings.startup["enable-remove-crash-site-at-game-start"].value then
        local freeplay = remote.interfaces["freeplay"]

        if freeplay then
            -- 开局时移除坠机现场
            if freeplay.set_disable_crashsite then
                remote.call("freeplay", "set_disable_crashsite", true)
            end

            -- 清空创建角色时给予的物品
            if freeplay.set_created_items then
                remote.call("freeplay", "set_created_items", {})
            end

            -- 清空坠机碎片中的物品
            if freeplay.set_debris_items then
                remote.call("freeplay", "set_debris_items", {})
            end
        end
    end

    -- 无限资源
    if settings.startup["enable-infinite-resources"].value then
        -- 运行时设置全部资源产量为 1
        runtime_set_all_resource_amount_to_one()
    end
end)

--
--
--

-- 配置变化时触发
script.on_configuration_changed(function()
    -- 无限资源
    if settings.startup["enable-infinite-resources"].value then
        -- 运行时设置全部资源产量为 1
        runtime_set_all_resource_amount_to_one()
    end
end)

--
--
--

-- 区块生成时触发
script.on_event(defines.events.on_chunk_generated, function(event)
    -- 清理地面装饰物
    if settings.global["enable-remove-decorations"].value then
        event.surface.destroy_decoratives {area = event.area}
    end

    -- 无限资源
    if settings.startup["enable-infinite-resources"].value then
        for _, resource in pairs(event.surface.find_entities_filtered({
            area = event.area,
            type = "resource"
        })) do resource.amount = 1 end
    end
end)

--
--
--

-- 定义函数运行时设置终为白日模式的值
local function runtime_set_always_day_mode_value(always_day_state)
    local always_day_shortcut = "toggle-always-day-mode"

    -- 切换全部地表的终为白日
    for _, surface in pairs(game.surfaces) do
        surface.always_day = always_day_state
    end

    -- 同步全部玩家的快捷方式 always_day_shortcut 的状态
    for _, current_player in pairs(game.players) do
        current_player.set_shortcut_toggled(always_day_shortcut,
                                            always_day_state)
    end
end

--
--
--

-- 按下快捷方式时触发
script.on_event(defines.events.on_lua_shortcut, function(event)
    -- 判断是否启用开局时启用终为白日模式以及是否按下快捷方式 toggle-always-day-mode
    if settings.startup["enable-always-day-mode-at-game-start"].value and
        event.prototype_name == "toggle-always-day-mode" then
        -- 运行时获取当前玩家
        local player = runtime_get_current_player(event)

        -- 获取切换后的终为白日模式的状态
        local always_day_state = not player.surface.always_day

        -- 运行时设置终为白日模式的值
        runtime_set_always_day_mode_value(always_day_state)
    end
end)

--
--
--

-- 每 tick 触发
script.on_event(defines.events.on_tick, function()
    -- 运行时清空全部虚空箱的库存
    runtime_clear_all_void_chests_inventory()

    -- 运行时清空全部虚空管的流体
    runtime_clear_all_void_pipes_fluid()
end)

--
--
--

-- 定义函数运行时开局时启用 ALT 模式
local function runtime_enable_alt_mode_at_game_start(event)
    -- 运行时获取当前玩家
    local player = runtime_get_current_player(event)

    -- 运行时开局时启用 ALT 模式
    if player.mod_settings["enable-alt-mode-at-game-start"].value then
        player.game_view_settings.show_entity_info = true
    end
end

--
--
--

-- 定义函数运行时初始化当前角色初始套装
local function runtime_initial_current_character_starter_kit(event)
    -- 开局时清空全部库存与装备
    if settings.startup["enable-clear-all-at-game-start"].value then
        -- 运行时清空当前角色全部库存与装备
        runtime_clear_current_character_all(event)
    end

    -- 开局时给予热能采矿机
    if settings.startup["enable-give-burner-mining-drill-at-game-start"].value and
        not runtime_mod_enabled("greceys-sea-block-mod") then
        runtime_insert_item(event, "burner-mining-drill", 10)
    end

    -- 开局时给予建设套装
    if settings.startup["enable-give-construction-kit-at-game-start"].value then
        -- 运行时清空当前角色盔甲
        runtime_clear_current_character_armor(event)

        -- 插入指定数量的物品, 盔甲和装备到当前角色
        if runtime_mod_enabled("greceys-pyanodon-modpack") then
            runtime_insert_item(event, "py-construction-robot-mk04", 10)

            runtime_insert_armor(event, "light-armor")

            runtime_insert_equipment(event, "solar-panel-equipment", 16)
            runtime_insert_equipment(event, "night-vision-equipment", 1)
            runtime_insert_equipment(event, "personal-roboport-equipment", 1)
        else
            runtime_insert_item(event, "construction-robot", 10)

            runtime_insert_armor(event, "modular-armor")

            runtime_insert_equipment(event, "solar-panel-equipment", 15)
            runtime_insert_equipment(event, "night-vision-equipment", 1)
            runtime_insert_equipment(event, "battery-equipment", 1)
            runtime_insert_equipment(event, "personal-roboport-equipment", 1)
        end
    end

    -- 开局时给予武器
    if settings.startup["enable-give-weapon-at-game-start"].value then
        -- 运行时清空当前角色武器和弹药
        runtime_clear_current_character_weapon(event)

        -- 插入指定数量的武器和弹药到当前角色的库存
        runtime_insert_item(event, "pistol", 1)
        runtime_insert_item(event, "firearm-magazine", 5)
    end

    -- 开局自动研究机器人速度
    if settings.startup["enable-automatically-researches-worker-robots-speed-at-game-start"]
        .value then
        local force = runtime_get_current_player(event).force

        for i = 1, 5 do
            local technology = force.technologies["worker-robots-speed-" .. i]

            if technology then technology.researched = true end
        end
    end

    -- 判断是否启用模组 greceys-sea-block-mod
    if runtime_mod_enabled("greceys-sea-block-mod") then
        runtime_insert_item(event, "offshore-pump", 1)
        runtime_insert_item(event, "burner-centrifuge", 1)
        runtime_insert_item(event, "pipe", 10)
        runtime_insert_item(event, "landfill", 300)

        -- 判断是否启用模组 recycler
        if runtime_mod_enabled("recycler") then
            runtime_insert_item(event, "burner-recycler", 1)
        end

        -- 判断是否启用模组 greceys-pyanodon-modpack
        if runtime_mod_enabled("greceys-pyanodon-modpack") then
            runtime_insert_item(event, "hydroclassifier-mk00", 1)
        end

        -- 判断是否启用模组 aai-industry
        if runtime_mod_enabled("aai-industry") then
            runtime_insert_item(event, "processed-fuel", 3)
        else
            runtime_insert_item(event, "solid-fuel", 3)
        end
    end

    -- 运行时设置当前角色已添加过全部物品和装备的值为 true
    runtime_set_current_player_inserted_value(event)
end

--
--
--

-- 开局时移除坠机现场
if settings.startup["enable-remove-crash-site-at-game-start"].value then
    -- 角色创建时触发
    script.on_event(defines.events.on_player_created, function(event)
        -- 运行时初始化当前角色开局套件
        runtime_initial_current_character_starter_kit(event)

        -- 运行时开局时启用 ALT 模式
        runtime_enable_alt_mode_at_game_start(event)

        -- 运行时设置终为白日模式的值
        runtime_set_always_day_mode_value(true)
    end)
else
    -- 动画完成, 跳过时触发
    script.on_event({
        defines.events.on_cutscene_cancelled,
        defines.events.on_cutscene_finished
    }, function(event)
        -- 运行时初始化当前角色开局套件
        runtime_initial_current_character_starter_kit(event)

        -- 运行时开局时启用 ALT 模式
        runtime_enable_alt_mode_at_game_start(event)

        -- 运行时设置终为白日模式的值
        runtime_set_always_day_mode_value(true)
    end)
end
