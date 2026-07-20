-- 修复模组的问题
-- 修复模组 space-age 的问题
if mod_enabled("space-age") then
    -- 修复设置的问题
    -- 移除物品变质
    if settings.startup["enable-remove-item-spoilage"] and
        settings.startup["enable-remove-item-spoilage"].value then
        -- 遍历 raw
        for _, prototypes in pairs(data.raw) do
            -- 遍历 prototype
            for _, prototype in pairs(prototypes) do
                if prototype.spoil_ticks ~= nil then
                    prototype.spoil_ticks = nil
                end
            end
        end
    end

    -- 移除机器冻结
    if settings.startup["enable-remove-machine-freezing"] and
        settings.startup["enable-remove-machine-freezing"].value then
        -- 遍历 raw
        for _, prototypes in pairs(data.raw) do
            -- 遍历 prototype
            for _, prototype in pairs(prototypes) do
                if prototype.heating_energy ~= nil then
                    prototype.heating_energy = nil
                end
            end
        end
    end
end
