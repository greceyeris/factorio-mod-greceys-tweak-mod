-- 修复模组的问题
-- 修复模组 quality 的问题
if mod_enabled("quality") then
    -- 修复设置的问题
    -- 允许选择全部配方的品质
    if settings.startup["enable-allow-select-quality-for-all-recipes"] and
        settings.startup["enable-allow-select-quality-for-all-recipes"].value then
        -- 修复配方的问题
        -- 遍历全部配方
        for _, recipe in pairs(data.raw.recipe) do
            -- 允许品质模块效果
            recipe.can_set_quality = true
        end
    end
end
