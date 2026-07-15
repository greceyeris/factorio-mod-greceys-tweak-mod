-- a[enable]
-- b[adjust]
-- -- a[map-preset]
-- -- b[world]
-- -- c[resource]
-- -- d[character]
-- -- e[entity]
-- -- f[item]
-- -- g[equipment]
-- -- h[recipe]
-- -- i[technology]
-- -- j[achievement]
-- -- k[shortcut]
-- -- z[utility]
-- startup-settings
data:extend{
    -- a[enable]-b[world]
    {
        type = "bool-setting",
        name = "enable-always-day-mode-at-game-start",
        setting_type = "startup",
        default_value = false,
        order = "a[enable]-b[world]"
    }, {
        type = "bool-setting",
        name = "enable-remove-crash-site-at-game-start",
        setting_type = "startup",
        default_value = false,
        order = "a[enable]-b[world]"
    }, -- a[enable]-c[resource]
    {
        type = "bool-setting",
        name = "enable-infinite-resources",
        setting_type = "startup",
        default_value = false,
        order = "a[enable]-c[resource]"
    }, -- a[enable]-d[character]
    {
        type = "bool-setting",
        name = "enable-clear-all-at-game-start",
        setting_type = "startup",
        default_value = false,
        order = "a[enable]-d[character]"
    }, {
        type = "bool-setting",
        name = "enable-give-burner-mining-drill-at-game-start",
        setting_type = "startup",
        default_value = false,
        order = "a[enable]-d[character]"
    }, {
        type = "bool-setting",
        name = "enable-give-construction-kit-at-game-start",
        setting_type = "startup",
        default_value = false,
        order = "a[enable]-d[character]"
    }, {
        type = "bool-setting",
        name = "enable-give-weapon-at-game-start",
        setting_type = "startup",
        default_value = false,
        order = "a[enable]-d[character]"
    }, -- a[enable]-e[entity]
    {
        type = "bool-setting",
        name = "enable-allow-all-machines-use-all-modules",
        setting_type = "startup",
        default_value = false,
        order = "a[enable]-e[entity]"
    }, {
        type = "bool-setting",
        name = "enable-disable-inserter-overload",
        setting_type = "startup",
        default_value = false,
        order = "a[enable]-e[entity]"
    }, {
        type = "bool-setting",
        name = "enable-electric-furnaces",
        setting_type = "startup",
        default_value = false,
        order = "a[enable]-e[entity]"
    }, {
        type = "bool-setting",
        name = "enable-electric-pole-free-lighting-mode",
        setting_type = "startup",
        default_value = false,
        order = "a[enable]-e[entity]"
    }, {
        type = "bool-setting",
        name = "enable-furnace-recipe-selection",
        setting_type = "startup",
        default_value = false,
        order = "a[enable]-e[entity]"
    }, {
        type = "bool-setting",
        name = "enable-mining-drill-item-filter-mode",
        setting_type = "startup",
        default_value = false,
        order = "a[enable]-e[entity]"
    }, {
        type = "bool-setting",
        name = "enable-place-offshore-pumps-anywhere",
        setting_type = "startup",
        default_value = false,
        order = "a[enable]-e[entity]"
    }, {
        type = "bool-setting",
        name = "enable-remove-pipeline-extent-limit",
        setting_type = "startup",
        default_value = false,
        order = "a[enable]-e[entity]"
    }, {
        type = "bool-setting",
        name = "enable-void-chest-and-void-pipe",
        setting_type = "startup",
        default_value = false,
        order = "a[enable]-e[entity]"
    }, -- a[enable]-f[item]
    {
        type = "bool-setting",
        name = "enable-waterfill",
        setting_type = "startup",
        default_value = false,
        order = "a[enable]-f[item]"
    }, -- a[enable]-g[equipment]
    {
        type = "bool-setting",
        name = "enable-modify-all-equipment-grid-occupancy-sizes-to-one",
        setting_type = "startup",
        default_value = false,
        order = "a[enable]-g[equipment]"
    }, -- a[enable]-h[recipe]
    {
        type = "bool-setting",
        name = "enable-allow-all-recipes-use-all-modules",
        setting_type = "startup",
        default_value = false,
        order = "a[enable]-h[recipe]"
    }, {
        type = "bool-setting",
        name = "enable-allow-select-quality-for-all-recipes",
        setting_type = "startup",
        default_value = false,
        order = "a[enable]-h[recipe]"
    }, {
        type = "bool-setting",
        name = "enable-always-show-recipe-made-in",
        setting_type = "startup",
        default_value = false,
        order = "a[enable]-h[recipe]"
    }, -- a[enable]-i[technology]
    {
        type = "bool-setting",
        name = "enable-automatically-researches-worker-robots-speed-at-game-start",
        setting_type = "startup",
        default_value = false,
        order = "a[enable]-i[technology]"
    }, {
        type = "bool-setting",
        name = "enable-display-all-hidden-technologies",
        setting_type = "startup",
        default_value = false,
        order = "a[enable]-i[technology]"
    }, {
        type = "bool-setting",
        name = "enable-optimize-technology-tree",
        setting_type = "startup",
        default_value = false,
        order = "a[enable]-i[technology]"
    }, -- a[enable]-j[achievement]
    {
        type = "bool-setting",
        name = "enable-remove-achievement-restrictions",
        setting_type = "startup",
        default_value = false,
        order = "a[enable]-j[achievement]"
    }, -- a[enable]-z[utility]
    {
        type = "bool-setting",
        name = "enable-show-farthest-distance-position",
        setting_type = "startup",
        default_value = false,
        order = "a[enable]-z[utility]"
    }, -- b[adjust]-d[character]
    {
        type = "double-setting",
        name = "adjust-character-crafting-speed-multiplier",
        setting_type = "startup",
        minimum_value = 1,
        maximum_value = 2 ^ 32 - 1,
        default_value = 1,
        order = "b[adjust]-d[character]"
    }, {
        type = "double-setting",
        name = "adjust-character-healing-per-tick-multiplier",
        setting_type = "startup",
        minimum_value = 1,
        maximum_value = 2 ^ 32 - 1,
        default_value = 1,
        order = "b[adjust]-d[character]"
    }, {
        type = "double-setting",
        name = "adjust-character-interaction-distance-multiplier",
        setting_type = "startup",
        minimum_value = 1,
        maximum_value = 2 ^ 32 - 1,
        default_value = 1,
        order = "b[adjust]-d[character]"
    }, {
        type = "double-setting",
        name = "adjust-character-max-health-multiplier",
        setting_type = "startup",
        minimum_value = 1,
        maximum_value = 2 ^ 32 - 1,
        default_value = 1,
        order = "b[adjust]-d[character]"
    }, {
        type = "double-setting",
        name = "adjust-character-mining-speed-multiplier",
        setting_type = "startup",
        minimum_value = 1,
        maximum_value = 2 ^ 32 - 1,
        default_value = 1,
        order = "b[adjust]-d[character]"
    }, {
        type = "double-setting",
        name = "adjust-character-respawn-time-multiplier",
        setting_type = "startup",
        minimum_value = 1,
        maximum_value = 2 ^ 32 - 1,
        default_value = 1,
        order = "b[adjust]-d[character]"
    }, {
        type = "double-setting",
        name = "adjust-character-running-speed-multiplier",
        setting_type = "startup",
        minimum_value = 1,
        maximum_value = 2 ^ 32 - 1,
        default_value = 1,
        order = "b[adjust]-d[character]"
    }, -- b[adjust]-e[entity]
    {
        type = "double-setting",
        name = "adjust-inserter-speed-multiplier",
        setting_type = "startup",
        minimum_value = 1,
        maximum_value = 2 ^ 32 - 1,
        default_value = 1,
        order = "b[adjust]-e[entity]"
    }, {
        type = "double-setting",
        name = "adjust-robot-speed-multiplier",
        setting_type = "startup",
        minimum_value = 1,
        maximum_value = 2 ^ 32 - 1,
        default_value = 1,
        order = "b[adjust]-e[entity]"
    }, {
        type = "double-setting",
        name = "adjust-transport-belt-speed-multiplier",
        setting_type = "startup",
        minimum_value = 1,
        maximum_value = 2 ^ 32 - 1,
        default_value = 1,
        order = "b[adjust]-e[entity]"
    }, -- b[adjust]-f[item]
    {
        type = "double-setting",
        name = "adjust-item-stack-size-multiplier",
        setting_type = "startup",
        minimum_value = 1,
        maximum_value = 2 ^ 32 - 1,
        default_value = 1,
        order = "b[adjust]-f[item]"
    }
}

--
--
--

-- runtime-global-settings
data:extend{
    -- a[enable]-e[entity]
    {
        type = "bool-setting",
        name = "enable-remove-decorations",
        setting_type = "runtime-global",
        default_value = false,
        order = "a[enable]-e[entity]"
    }
}

--
--
--

-- runtime-per-user-settings
data:extend{
    -- a[enable]-k[shortcut]
    {
        type = "bool-setting",
        name = "enable-alt-mode-at-game-start",
        setting_type = "runtime-per-user",
        default_value = false,
        order = "a[enable]-k[shortcut]"
    }
}

-- 修复模组的问题
-- 修复模组 space-age 的问题
if mods["space-age"] then
    -- startup-settings
    data:extend{
        -- a[enable]-e[entity]
        {
            type = "bool-setting",
            name = "enable-remove-machine-freezing",
            setting_type = "startup",
            default_value = false,
            order = "a[enable]-e[entity]"
        }, -- a[enable]-f[item]
        {
            type = "bool-setting",
            name = "enable-remove-item-spoilage",
            setting_type = "startup",
            default_value = false,
            order = "a[enable]-f[item]"
        }
    }
end

-- 修复模组 quality 的问题
if mods["quality"] then
    -- startup-settings
    data:extend{
        -- a[enable]-h[recipe]
        {
            type = "bool-setting",
            name = "enable-allow-select-quality-for-all-recipes",
            setting_type = "startup",
            default_value = false,
            order = "a[enable]-h[recipe]"
        }
    }
end

-- 修复模组 recycler 的问题
if mods["recycler"] then
    -- startup-settings
    data:extend{
        -- a[enable]-h[recipe]
        {
            type = "bool-setting",
            name = "enable-remove-all-recycling-recipes",
            setting_type = "startup",
            default_value = false,
            order = "a[enable]-h[recipe]"
        }
    }
end
