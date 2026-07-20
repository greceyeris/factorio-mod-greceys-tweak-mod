-- 修复模组的问题
-- 修复模组 recycler 的问题
if mod_enabled("recycler") then
    -- 修复设置的问题
    -- 移除全部回收配方
    if settings.startup["enable-remove-recycling-recipes-whose-names-end-in-recycling"] and
        settings.startup["enable-remove-recycling-recipes-whose-names-end-in-recycling"].value then
        -- 修复配方的问题
        -- 遍历全部配方
        for recipe_name, recipe in pairs(data.raw["recipe"]) do
            -- 遍历配方分类
            for _, recipe_category in pairs(recipe.categories or {"crafting"}) do
                -- 移除全部回收配方
                if recipe_category_exist("recycling") and recipe_category ==
                    "recycling" and recipe_name:match("%-recycling$") then
                    data.raw["recipe"][recipe_name] = nil

                    -- 修复科技的问题
                    -- 遍历全部科技
                    for _, technology in pairs(data.raw["technology"]) do
                        -- 遍历科技效果
                        for effect_index = #(technology.effects or {}), 1, -1 do
                            -- 移除该配方的解锁效果
                            if technology.effects[effect_index].recipe ==
                                recipe_name then
                                table.remove(technology.effects, effect_index)
                            end
                        end
                    end

                    break
                end
            end
        end
    end
end
