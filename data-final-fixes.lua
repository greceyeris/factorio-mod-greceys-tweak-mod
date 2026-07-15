require("__greceys-library-mod__.load-data-functions")

-- 判断是否启用模组 space-age
if mod_enabled("space-age") then require("prototypes.data-final-fixes.space-age") end

-- 判断是否启用模组 quality
if mod_enabled("quality") then require("prototypes.data-final-fixes.quality") end

-- 判断是否启用模组 recycler
if mod_enabled("recycler") then require("prototypes.data-final-fixes.recycler") end

require("prototypes.data-final-fixes.basic-features")
