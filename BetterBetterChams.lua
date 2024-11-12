-- original made by trophy: https://lmaobox.net/forum/v/profile/34535682/IamTheTrophy
-- original topic: https://lmaobox.net/forum/v/discussion/21738
-- original version archive: https://pastebin.com/raw/2fuFsVx8

local shadedButWorse = [["VertexLitGeneric"
{
     $basetexture "vgui/white_additive"
     $bumpmap "vgui/white_additive"
     $envmap "cubemaps/cubemap_sheen001"
     $phong "1"
     $selfillum "1"
     $selfillumfresnel "1"
     $selfillumfresnelminmaxexp "[-0.25 1 1]"
}
]]

local flat = [["UnlitGeneric"
{
    $basetexture "vgui/white_additive"
}
]]

local none = [["UnlitGeneric"
{
    $color2 "[0 0 0]"
    $additive "1"
}
]]

local shaded = [["VertexLitGeneric"
{
    $basetexture "vgui/white_additive"
}
]]

local missing = [["UnlitGeneric"
{
    $basetexture "debug/debugempty"
}
]]

local fresnel = [["VertexLitGeneric"
{
    $basetexture "vgui/white_additive"
    $bumpmap "models/player/shared/shared_normal"
    $envmap "skybox/sky_dustbowl_01"
    $envmapfresnel "1"
    $phong "1"
    $phongfresnelranges "[0 0.05 0.1]"
    $selfillum "1"
    $selfillumfresnel "1"
    $selfillumfresnelminmaxexp "[0.5 0.5 0]"
    $selfillumtint "[0 0 0]"
}
]]

-- breaks and color modulation doesnt work
local shine = [["VertexLitGeneric"
{
    $additive "1"
    $envmap "cubemaps/cubemap_sheen002.hdr"
    $envmaptint "[1 1 1]"
}
]]

-- color modulation looks weird
local tint = [["VertexLitGeneric"
{
    $basetexture "models/player/shared/ice_player"
    $bumpmap "models/player/shared/shared_normal"
    $additive "1"
    $phong "1"
    $phongfresnelranges "[0 0.001 0.001]"
    $envmap "skybox/sky_dustbowl_01"
    $envmapfresnel "1"
    $selfillum "1"
    $selfillumtint "[0 0 0]"
}
]]

local plastic = [["VertexLitGeneric"
{
    $basetexture "models/player/shared/ice_player"
    $bumpmap "models/player/shared/shared_normal"
    $phong "1"
    $phongexponent "10"
    $phongboost "1"
    $phongfresnelranges "[0 0 0]"
    $basemapalphaphongmask "1"
    $phongwarptexture "models/player/shared/ice_player_warp"

}
]]


local function bitflags(n)
    local result = {}
    for i = 0, n - 1 do
        table.insert(result, 2 ^ i)
    end
    return table.unpack(result)
end

local MODUL_COLOR2, MODUL_PHONGTINT, MODUL_ENVMAPTINT, MODUL_SELFILLUMTINT, MODUL_IGNOREZ, MODUL_WIREFRAME = bitflags(6)

local function getMaterial(material, color, colorModules)
    if color then
        local colorString = ""
        local function modulFlag(module, formatString)
            if colorModules & module ~= 0 then
                colorString = colorString .. string.format(formatString, color[1], color[2], color[3])
            end
        end

        modulFlag(MODUL_COLOR2, [[
    $color2 "[%f %f %f]"
]])
        modulFlag(MODUL_PHONGTINT, [[
    $phongtint "[%f %f %f]"
]])
        modulFlag(MODUL_ENVMAPTINT, [[
    $envmaptint "[%f %f %f]"
]])
        modulFlag(MODUL_SELFILLUMTINT, [[
    $selfillumtint "[%f %f %f]"
]])
        modulFlag(MODUL_IGNOREZ, [[
    $ignorez "1"
]])
        modulFlag(MODUL_WIREFRAME, [[
    $wireframe "1"
]])
        material = material:gsub("}\n?$", colorString .. "\n}")
    end
    return material
end


local enemyMaterial = materials.Create(
    "enemyMaterial", 
    getMaterial(shaded, {0, 1, 0}, MODUL_COLOR2 | MODUL_IGNOREZ)
)

local teamMaterial = materials.Create(
    "teamMaterial", 
    getMaterial(fresnel, {1, 1, 1}, MODUL_ENVMAPTINT | MODUL_PHONGTINT | MODUL_WIREFRAME)
)

local localPlayerMaterial = materials.Create(
    "localPlayerMaterial", 
    getMaterial(fresnel, {0, 1, 1}, MODUL_ENVMAPTINT | MODUL_PHONGTINT)
)

-- local viewModelMaterial = materials.Create(
--     "viewModelMaterial", 
--     getMaterial(fresnel, {1, 0, 1}, MODUL_ENVMAPTINT | MODUL_PHONGTINT)
-- )

local function modelOverride(ctx)
    local entity = ctx:GetEntity()
    if entity and entity:IsValid() then
        if entity:GetClass() == "CTFPlayer" and entity:IsAlive() then
            local localPlayer = entities.GetLocalPlayer()
            if not localPlayer then return end
            
            local entityTeam = entity:GetTeamNumber()
            local localPlayerTeam = localPlayer:GetTeamNumber()

            if entity == localPlayer then
                ctx:ForcedMaterialOverride(localPlayerMaterial)
            elseif entityTeam == localPlayerTeam then
                ctx:ForcedMaterialOverride(teamMaterial)
            else
                ctx:ForcedMaterialOverride(enemyMaterial)
            end
        --elseif entity:GetClass() == "CTFViewModel" then
        --    ctx:ForcedMaterialOverride(viewModelMaterial)
        end
    end
end

callbacks.Unregister("DrawModel", "modelOverride")
callbacks.Register("DrawModel", "modelOverride", modelOverride)