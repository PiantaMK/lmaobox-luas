-- original made by trophy: https://lmaobox.net/forum/v/profile/34535682/IamTheTrophy
-- available at: https://lmaobox.net/forum/v/discussion/21738
-- archive: https://pastebin.com/raw/2fuFsVx8

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


local MODUL_COLOR2 = 1
local MODUL_PHONGTINT = 2
local MODUL_ENVMAPTINT = 4
local MODUL_SELFILLUMTINT = 8
local MODUL_IGNOREZ = 16
local MODUL_WIREFRAME = 32

local function getMaterial(material, color, colorModules)
    if color then
        local colorString = ""
        if colorModules & MODUL_COLOR2 ~= 0 then
            colorString = colorString .. string.format([[
    $color2 "[%f %f %f]"
]], color[1], color[2], color[3])
        end
        if colorModules & MODUL_PHONGTINT ~= 0 then
            colorString = colorString .. string.format([[
    $phongtint "[%f %f %f]"
]], color[1], color[2], color[3])
        end
        if colorModules & MODUL_ENVMAPTINT ~= 0 then
            colorString = colorString .. string.format([[
    $envmaptint "[%f %f %f]"
]], color[1], color[2], color[3])
        end
        if colorModules & MODUL_SELFILLUMTINT ~= 0 then
            colorString = colorString .. string.format([[
    $selfillumtint "[%f %f %f]"
]], color[1], color[2], color[3])
        end
        if colorModules & MODUL_IGNOREZ ~= 0 then
            colorString = colorString .. string.format([[
    $ignorez "1"
]])
        end
        if colorModules & MODUL_WIREFRAME ~= 0 then
            colorString = colorString .. string.format([[
    $wireframe "1"
]])
        end
        material = material:gsub("}\n?$", colorString .. "\n}")
    end
    return material
end


local enemyMaterial = materials.Create("enemyMaterial", getMaterial(shaded, {0, 1, 0}, MODUL_COLOR2 | MODUL_IGNOREZ))
local teamMaterial = materials.Create("teamMaterial", getMaterial(fresnel, {1, 1, 1}, MODUL_ENVMAPTINT | MODUL_PHONGTINT | MODUL_WIREFRAME))
local localPlayerMaterial = materials.Create("localPlayerMaterial", getMaterial(fresnel, {0, 1, 1}, MODUL_ENVMAPTINT | MODUL_PHONGTINT))

local function onDrawModel(drawModelContext)
    local entity = drawModelContext:GetEntity()
    if not (entity and entity:IsValid() and entity:IsAlive() and entity:GetClass() == "CTFPlayer") then
        return
    end
    
    local localPlayer = entities.GetLocalPlayer()
    if not localPlayer then return end
    
    local entityTeam = entity:GetTeamNumber()
    local localPlayerTeam = localPlayer:GetTeamNumber()
    if entity == localPlayer then
        drawModelContext:ForcedMaterialOverride(localPlayerMaterial)
    elseif entityTeam == localPlayerTeam then
        drawModelContext:ForcedMaterialOverride(teamMaterial)
    else
        drawModelContext:ForcedMaterialOverride(enemyMaterial)
    end
end

-- Register callback for drawing models
callbacks.Register("DrawModel", "hook123", onDrawModel)
