local sides = require("sides")
local prox = {}
local function Proxies()
    return {
        actuallycomputers = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--ActuallyComputers 02.01.2000
        adchimneys = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Advanced Chimneys 1.12.1-3.2.1.0
        aperture = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Aperture 01. Jan
        arcticmobs = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Lycanites Arctic Mobs 1.20.3.0
        as_extraresources = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Extra Resources Add-on 1.0.7
        autoreglib = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--AutoRegLib 01.03.2015
        baubles = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Baubles 01.05.2002
        bdlib = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--BD Lib 1.14.3.11
        bigreactors = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Extreme Reactors 1.12.2-0.4.5.45
        biomebundle = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Biome Bundle 05. Jan
        blockpalette = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--BlockPalette 01.05.2000
        bookshelf = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Bookshelf 2.3.552
        bq_standard = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Standard Expansion 2.4.134
        brandonscore = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Brandon's Core 02.04.2000 
        bushmastercore = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Bush Master Core 1.0.2 
        car = {home={proxy="dd", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Car Mod 01.02.2010 
        carryon = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Carry On 01. Jul 
        carz = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Carz Proof of Concept 2.1 (BTM Version) 
        cdm = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--MrCrayfish's Device Mod 0.2.0-pre6
        ceramics = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Ceramics 1.12-1.3.3b
        cfm = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--MrCrayfish's Furniture Mod 04.01.2005 
        chisel = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Chisel MC1.12.2-0.2.0.31 
        chiselsandbits = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Chisels & Bits 14.23 
        chunkpregenerator = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Chunk Pregenerator 01.06.2001 
        codechickenlib = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--CodeChicken Lib 3.1.5.331 
        cofhcore = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--CoFH Core 04.03.2009 
        cofhworld = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--CoFH World 01.01.2001 
        compactmachines3 = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Compact Machines 3 3.0.12 
        compot = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Combined Potions 01. Jan 
        connect = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Connect 1.0.3-mc1.12.2-SNAPSHOT 
        conquest = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Conquest Reforged 3.0.2 
        cookingforblockheads = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Cooking for Blockheads 06.03.2017 
        corail_pillar = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Corail Pillar 4.0.0 
        corail_pillar_extension_biomesoplenty = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Corail Pillar Biomes O'Plenty Extension
        corail_pillar_extension_chisel = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Corail Pillar Chisel Extension
        corail_pillar_extension_forestry = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Corail Pillar Forestry Extension
        coralreef = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Coralreef 2.0
        craftstudioapi = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--CraftStudio API 1.0.0
        crafttweaker = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--CraftTweaker2 04.01.2009
        crafttweakerjei = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--CraftTweaker JEI Support 2.0.2
        ctgui = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--CT-GUI 1.0.0
        ctm = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--CTM MC1.12-0.2.3.9
        cucumber = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Cucumber 1.0.3
        customnpcs = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--CustomNPCs 01. Dez
        cyclicmagic = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Cyclic 01.10.2010
        darkutils = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Dark Utilities 1.8.207
        davincisvessels = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Davinci's Vessels @DVESSELSVER@ 
        ddb = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--DIY Decorative Blocks ${version} 
        deepresonance = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--DeepResonance 01.06.2000 
        defiledlands = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Defiled Lands 01.02.2000 
        demonmobs = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Lycanites Demon Mobs 1.20.3.0 
        desertmobs = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Lycanites Desert Mobs 1.20.3.0 
        draconicevolution = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Draconic Evolution 02.03.2010 
        dynamiclights = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Dynamic Lights 01.04.2006 
        dynamiclights_creepers = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Dynamic Lights on Creepers 1.0.6 
        dynamiclights_dropitems = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Dynamic Lights on ItemEntities 01.01.2000 
        dynamiclights_entityclasses = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Dynamic Lights on specified Entities 1.0.1 
        dynamiclights_flamearrows = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Dynamic Lights on Flame enchanted Arrows 1.0.1 
        dynamiclights_floodlights = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Dynamic Lights Flood Light 1.0.3 
        dynamiclights_mobequipment = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Dynamic Lights on Mob Equipment 01.01.2000 
        dynamiclights_onfire = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Dynamic Lights on burning 1.0.7 
        dynamiclights_otherplayers = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Dynamic Lights Other Player Light 1.0.9 
        dynamiclights_theplayer = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Dynamic Lights Player Light 01.01.2003 
        eleccore = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--ElecCore 1.8.434 
        electrostatics = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Electrostatics 1.0.0 
        elementalmobs = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Lycanites Elemental Mobs 1.20.3.0 
        energyconverters = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Energy Converters 1.0.1.2 
        environmentalmaterials = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Environmental Materials @EM_VERSION@ 
        environmentaltech = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Environmental Tech 1.12.2-2.0.8a 
        etlunar = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--ET Lunar 1.12.2-2.0.8a 
        extrabitmanipulation = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Extra Bit Manipulation 1.12-3.2.1 
        extrautils2 = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Extra Utilities 2 1.0 
        fairylights = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Fairy Lights 02.01.2002 
        farmory = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Forge Your World Armory 01.03.2001 
        fcl = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Fexcraft Common Library XII.40 
        fdecostuff = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Forge Your World Decoration And Stuff 01.03.2001 
        ffactory = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Forge Your World Factory 01.03.2001 
        ffoods = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Forge Your World Foods 01.03.2001 
        flatcoloredblocks = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Flat Colored Blocks mc1.12-6.6 
        floricraft = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Floricraft 04.04.2001 
        fmagic = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Forge Your World Mystical 01.03.2001 
        FML = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Forge Mod Loader 8.0.99.99 
        forestmobs = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Lycanites Forest Mobs 1.20.3.0 
        forestry = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Forestry 5.7.0.219 
        forge = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Minecraft Forge 14.23.3.2676 
        forgeendertech = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Forge Endertech 1.12.1-4.3.0.0 
        forgelin = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Shadowfacts' Forgelin 01.06.2000
        fp = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Futurepack 26.3.210
        fpapi = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Futurepack API 01.01.2000
        fpfa = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Futurepack Forestry Addon 01.01.2002
        freshwatermobs = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Lycanites Freshwater Mobs 1.20.3.0
        fresource = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Forge Your World Resource / Core 01.03.2001
        frsm = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Fex's Random Stuff Mod 4.0.27 
        fvtm = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Fex's Vehicle and Transportation Mod 2.6.b29
        gemmary = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Gemmary 1.0.0.0
        gendustry = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--GenDustry 1.6.5.8
        gravestone = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Gravestone Mod 01.10.2001
        gravitygun = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--GravityGun 7.0.0
        harvestcraft = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Pam's HarvestCraft 1.12.2c 
        hud = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Better HUD 01.03.2009 
        ic2 = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--IndustrialCraft 2 2.8.73-ex112 
        ichunutil = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--iChunUtil 07.01.2004 
        immcraft = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Immersive Craft 01.04.2000 
        immersiveengineering = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Immersive Engineering 0.12-80 
        immersivehempcraft = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Immersive HempCraft 1.12-0.0.4.0 
        immersiverailroading = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Immersive Railroading 1.0.1 
        immersivetech = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Immersive Tech 01.03.2007 
        industrialforegoing = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Industrial Foregoing 1.12.2-1.12.2 
        infernomobs = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Lycanites Inferno Mobs 1.20.3.0 
        infinitycraft = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--InfinityCraft 1.12.2-r1 
        inventorytweaks = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Inventory Tweaks 1.63+release.109.220f184 
        itorch = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--iTorch 01.02.2000 
        jehc = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Just Enough HarvestCraft 01.03.2001 
        jei = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Just Enough Items 4.8.5.138 
        jeibees = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--JEI Bees 0.9.0.5 
        jeiintegration = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--JEI Integration 1.5.1.36 
        jeresources = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Just Enough Resources 0.8.7.41 
        junglemobs = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Lycanites Jungle Mobs 1.20.3.0 
        lycanitesmobs = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Lycanites Mobs 1.20.3.0 
        magicbees = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--MagicBees 1.0 
        malisisadvert = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Malisis Advert 1.12-6.0.0 
        malisisblocks = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Malisis Blocks 1.12.2-6.0.3 
        malisiscore = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--MalisisCore 1.12.2-6.3.0 
        malisisdoors = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--MalisisDoors 1.12.2-7.2.2 
        malisisswitches = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Malisis Switches 1.12-5.0.0 
        mantle = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Mantle 1.12-1.3.1.21 
        mcjtylib_ng = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--McJtyLib 02.06.2007 
        mcp = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Minecraft Coder Pack Sep 42 
        mekanism = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Mekanism 1.12.2-9.4.10.345 
        mekanismgenerators = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--MekanismGenerators 09.04.2010 
        mekanismtools = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--MekanismTools 09.04.2010 
        minewatch = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Minewatch Mrz 13 
        moarfood = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--MoarFood 01.01.2002 
        moartinkers = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Moar Tinkers 0.5.4 
        mobends = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Mo' Bends 0.24
        modcurrency = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Good Ol' Currency Mod 1.12-1.2.6 
        modernmetals = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Modern Metals 2.5.0-beta3 
        morebeautifulbuttons = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--More Beautiful Buttons 1.12.2-1.6.0.14 
        morebeautifulplates = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--More Beautiful Plates 1.12.2-1.0.3 
        mores = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Mores 01. Feb 
        mountainmobs = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Lycanites Mountain Mobs 1.20.3.0 
        movingworld = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Moving World 1.12-6.342 
        mxtune = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--mxTune 0.5.0-beta.2 
        mysticalagradditions = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Mystical Agradditions 01.02.2008 
        mysticalagriculture = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Mystical Agriculture 01.06.2007 
        neid = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--NotEnoughIDs 1.5.4.2 
        nethermetals = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Nether Metals 1.2.0-beta1 
        netherportalfix = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--NetherPortalFix 05.03.2013 
        nuclearcraft = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--NuclearCraft 2.9d 
        ocjs = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--OCJS 0.5.1 
        ocsensors = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--OpenComputers Sensors 1.0.4 
        ocxnetdriver = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--OpenComputers Xnet Driver 1.0 
        opencomputers = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--OpenComputers 1.7.2.104 
        opencomputerscore = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--OpenComputers (Core) 1.7.2.104 
        openglider = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Open Glider @VERSION@ 
        openterraingenerator = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Open Terrain Generator v6 
        orespawn = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--OreSpawn 03.02.2000 
        otgcore = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--OTG Core 01. Dez 
        persistentbits = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Persistent Bits 1.0.6a 
        personalcars = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Personal Cars 01. Apr 
        placeableitems = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Placeable Items Mod 03. Feb 
        plainsmobs = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Lycanites Plains Mobs 1.20.3.0 
        plants2 = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Plants 02.02.2002 
        platforms = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Platforms 01.04.2002 
        props = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Decocraft 02.06.2001 
        psi = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Psi r1.1-59 
        ptrmodellib = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--ptrmodellib 1.0.2 
        quantumstorage = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--QuantumStorage 04.04.2006 
        questbook = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Better Questing Quest Book 3.0.0-1.12.1 
        radixcore = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--RadixCore 1.12.x-2.2.1 
        rafradek_tf2_weapons = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--TF2 Stuff Mod 01.03.2005 
        rangedpumps = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Ranged Pumps 0.5 
        reborncore = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Reborn Core 3.6.1.183 
        rebornstorage = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--RebornStorage 1.0.0 
        redstonearsenal = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Redstone Arsenal 02.03.2009 
        redstoneflux = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Redstone Flux 2.0.2 
        redstonepaste = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Redstone Paste 01.07.2005 
        refinedstorage = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Refined Storage 01.05.1932 
        rftools = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--RFTools Jul 33 
        rftoolscontrol = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--RFTools Control 01.08.2001 
        rftoolsdim = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--RFTools Dimensions Mai 53 
        runecraft = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--ï¿½9RuneCraft 01.04.2002 
        rustic = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Rustic 0.4.5 
        saltmod = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Salty Mod 1.12_d 
        saltwatermobs = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Lycanites Saltwater Mobs 1.20.3.0 
        shadowmobs = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Lycanites Shadow Mobs 1.20.3.0 
        shetiphiancore = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--ShetiPhian-Core 03.05.2005 
        signpost = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Sign Post 01.06.2001 
        simpledimensions = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Simple Dimensions 01.03.2001 
        simplytea = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Simply Tea 01. Apr 
        swampmobs = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Lycanites Swamp Mobs 1.20.3.0 
        tconstruct = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Tinkers' Construct 1.12.2-2.9.1.65
        techreborn = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Tech Reborn 2.12.1.446
        terraqueous = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Terraqueous 01.04.2006
        tesla = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--TESLA 1.0.63
        teslacorelib = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Tesla Core Lib 1.0.12
        teslacorelib_registries = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Tesla Core Lib Registries 1.0.12
        teslathingies = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Tesla Powered Thingies 1.0.12
        theoneprobe = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--The One Probe 01.04.2019
        thermalcultivation = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Thermal Cultivation 0.1.4
        thermaldynamics = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Thermal Dynamics 02.03.2009
        thermalexpansion = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Thermal Expansion 05.03.2009
        thermalfoundation = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Thermal Foundation 02.03.2009
        tinkersoc = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Tinkers Construct OpenComputers Driver 0.1
        tinkertoolleveling = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Tinkers Tool Leveling 1.12-1.0.3.DEV.56fac4f
        torcharrowsmod = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--TorchArrows 1.12.1-3
        trackapi = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Track API 01. Jan
        twilightforest = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--The Twilight Forest 3.5.263
        uniquecrops = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Unique Crops 0.1.46
        unlimitedchiselworks = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Unlimited Chisel Works 0.2.0
        unlimitedchiselworks_botany = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Unlimited Chisel Works Botany Compat
        valkyrielib = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Valkyrie Lib 1.12.2-2.0.8a
        vc = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--ViesCraft 05.06.2000
        waddles = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Waddles 0.5.6
        worldutils = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--World Utils 0.4.2
        xnet = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--XNet 01.06.2007
        xray = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--XRay 01.04.2000
        xreliquary = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Reliquary 1.12.2-1.3.4.728
        zerocore = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Zero CORE 1.12-0.1.1.0
        actuallyadditions = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Actually Additions 1.12.2-r133
        adhooks = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Advanced Hook Launchers 1.12.1-3.1.2.0
        advancedrocketry = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Advanced Rocketry 1.4.0.-82
        ae2stuff = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--AE2 Stuff 0.7.0.4
        aether_legacy = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Aether Legacy 1.12.2-v1.0.1
        animania = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Animania 01.04.2003
        appliedenergistics2 = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Applied Energistics 2 rv5-stable-4
        aquamunda = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Aqua Munda 0.3.0beta
        astikoor = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Astikoor 1.0.0
        atlcraft = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--ATLCraft Candles Mod MC1.12-Ver1.9
        basemetals = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Base Metals 2.5.0-beta3
        betterquesting = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Better Questing 2.5.236
        bibliocraft = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--BiblioCraft 02.04.2003
        binniecore = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Binnie Core unspecified
        binniedesign = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Binnie's Design 1.0 
        biomesoplenty = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Biomes O' Plenty 7.0.1.2312
        botania = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Botania r1.10-353
        botany = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Binnie's Botany 2.5.0.110 
        buildcraftbuilders = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--BC Builders 7.99.13 
        buildcraftcore = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--BuildCraft 7.99.13 
        buildcraftenergy = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--BC Energy 7.99.13 
        buildcraftfactory = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--BC Factory 7.99.13 
        buildcraftlib = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--BuildCraft Lib 7.99.13 
        buildcraftrobotics = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--BC Robotics 7.99.13 
        buildcraftsilicon = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--BC Silicon 7.99.13 
        buildcrafttransport = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--BC Transport 7.99.13 
        extrabees = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Binnie's Extra Bees 2.5.0.110
        extratrees = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Binnie's Extra Trees 2.5.0.110 
        genetics = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Binnie's Genetics 2.5.0.110
        libvulpes = {home={proxy="", tocraft=sides.up, toroute=sides.up}, craft={proxy="", tohome=sides.up, toroute=sides.up}},--Vulpes library 0.2.8.-31
        minecraft = {home={proxy="064e979d-0a25-4324-bc61-dfa764487718", tocraft=sides.east, toroute=sides.west}, craft={proxy="e20cea58-f7ae-43f8-b531-b1b21c3765da", tohome=sides.north, toroute=sides.west}}--Minecraft 01.12.2002
    }
end
local function RouteSystem()
    return {
        actuallycomputers = {proxy="8b560e01-5b40-49e4-8e86-312f0514dade", home=sides.west, craft=sides.east},
        adchimneys = {proxy="", home=sides.up, craft=sides.up},
        aperture = {proxy="", home=sides.up, craft=sides.up},
        arcticmobs = {proxy="", home=sides.up, craft=sides.up},
        as_extraresources = {proxy="", home=sides.up, craft=sides.up},
        autoreglib = {proxy="", home=sides.up, craft=sides.up},
        baubles = {proxy="", home=sides.up, craft=sides.up},
        bdlib = {proxy="", home=sides.up, craft=sides.up},
        bigreactors = {proxy="", home=sides.up, craft=sides.up},
        biomebundle = {proxy="", home=sides.up, craft=sides.up},
        blockpalette = {proxy="", home=sides.up, craft=sides.up},
        bookshelf = {proxy="", home=sides.up, craft=sides.up},
        bq_standard = {proxy="", home=sides.up, craft=sides.up},
        brandonscore = {proxy="", home=sides.up, craft=sides.up},
        bushmastercore = {proxy="", home=sides.up, craft=sides.up},
        car = {proxy="", home=sides.up, craft=sides.up},
        carryon = {proxy="", home=sides.up, craft=sides.up},
        carz = {proxy="", home=sides.up, craft=sides.up},
        cdm = {proxy="", home=sides.up, craft=sides.up},
        ceramics = {proxy="", home=sides.up, craft=sides.up},
        cfm = {proxy="", home=sides.up, craft=sides.up},
        chisel = {proxy="", home=sides.up, craft=sides.up},
        chiselsandbits = {proxy="", home=sides.up, craft=sides.up},
        chunkpregenerator = {proxy="", home=sides.up, craft=sides.up},
        codechickenlib = {proxy="", home=sides.up, craft=sides.up},
        cofhcore = {proxy="", home=sides.up, craft=sides.up},
        cofhworld = {proxy="", home=sides.up, craft=sides.up},
        compactmachines3 = {proxy="", home=sides.up, craft=sides.up},
        compot = {proxy="", home=sides.up, craft=sides.up},
        connect = {proxy="", home=sides.up, craft=sides.up},
        conquest = {proxy="", home=sides.up, craft=sides.up},
        cookingforblockheads = {proxy="", home=sides.up, craft=sides.up},
        corail_pillar = {proxy="", home=sides.up, craft=sides.up},
        corail_pillar_extension_biomesoplenty = {proxy="", home=sides.up, craft=sides.up},
        corail_pillar_extension_chisel = {proxy="", home=sides.up, craft=sides.up},
        corail_pillar_extension_forestry = {proxy="", home=sides.up, craft=sides.up},
        coralreef = {proxy="", home=sides.up, craft=sides.up},
        craftstudioapi = {proxy="", home=sides.up, craft=sides.up},
        crafttweaker = {proxy="", home=sides.up, craft=sides.up},
        crafttweakerjei = {proxy="", home=sides.up, craft=sides.up},
        ctgui = {proxy="", home=sides.up, craft=sides.up},
        ctm = {proxy="", home=sides.up, craft=sides.up},
        cucumber = {proxy="", home=sides.up, craft=sides.up},
        customnpcs = {proxy="", home=sides.up, craft=sides.up},
        cyclicmagic = {proxy="", home=sides.up, craft=sides.up},
        darkutils = {proxy="", home=sides.up, craft=sides.up},
        davincisvessels = {proxy="", home=sides.up, craft=sides.up},
        ddb = {proxy="", home=sides.up, craft=sides.up},
        deepresonance = {proxy="", home=sides.up, craft=sides.up},
        defiledlands = {proxy="", home=sides.up, craft=sides.up},
        demonmobs = {proxy="", home=sides.up, craft=sides.up},
        desertmobs = {proxy="", home=sides.up, craft=sides.up},
        draconicevolution = {proxy="", home=sides.up, craft=sides.up},
        dynamiclights = {proxy="", home=sides.up, craft=sides.up},
        dynamiclights_creepers = {proxy="", home=sides.up, craft=sides.up},
        dynamiclights_dropitems = {proxy="", home=sides.up, craft=sides.up},
        dynamiclights_entityclasses = {proxy="", home=sides.up, craft=sides.up},
        dynamiclights_flamearrows = {proxy="", home=sides.up, craft=sides.up},
        dynamiclights_floodlights = {proxy="", home=sides.up, craft=sides.up},
        dynamiclights_mobequipment = {proxy="", home=sides.up, craft=sides.up},
        dynamiclights_onfire = {proxy="", home=sides.up, craft=sides.up},
        dynamiclights_otherplayers = {proxy="", home=sides.up, craft=sides.up},
        dynamiclights_theplayer = {proxy="", home=sides.up, craft=sides.up},
        eleccore = {proxy="", home=sides.up, craft=sides.up},
        electrostatics = {proxy="", home=sides.up, craft=sides.up},
        elementalmobs = {proxy="", home=sides.up, craft=sides.up},
        energyconverters = {proxy="", home=sides.up, craft=sides.up},
        environmentalmaterials = {proxy="", home=sides.up, craft=sides.up},
        environmentaltech = {proxy="", home=sides.up, craft=sides.up},
        etlunar = {proxy="", home=sides.up, craft=sides.up},
        extrabitmanipulation = {proxy="", home=sides.up, craft=sides.up},
        extrautils2 = {proxy="", home=sides.up, craft=sides.up},
        fairylights = {proxy="", home=sides.up, craft=sides.up},
        farmory = {proxy="", home=sides.up, craft=sides.up},
        fcl = {proxy="", home=sides.up, craft=sides.up},
        fdecostuff = {proxy="", home=sides.up, craft=sides.up},
        ffactory = {proxy="", home=sides.up, craft=sides.up},
        ffoods = {proxy="", home=sides.up, craft=sides.up},
        flatcoloredblocks = {proxy="", home=sides.up, craft=sides.up},
        floricraft = {proxy="", home=sides.up, craft=sides.up},
        fmagic = {proxy="", home=sides.up, craft=sides.up},
        FML = {proxy="", home=sides.up, craft=sides.up},
        forestmobs = {proxy="", home=sides.up, craft=sides.up},
        forestry = {proxy="", home=sides.up, craft=sides.up},
        forge = {proxy="", home=sides.up, craft=sides.up},
        forgeendertech = {proxy="", home=sides.up, craft=sides.up},
        forgelin = {proxy="", home=sides.up, craft=sides.up},
        fp = {proxy="", home=sides.up, craft=sides.up},
        fpapi = {proxy="", home=sides.up, craft=sides.up},
        fpfa = {proxy="", home=sides.up, craft=sides.up},
        freshwatermobs = {proxy="", home=sides.up, craft=sides.up},
        fresource = {proxy="", home=sides.up, craft=sides.up},
        frsm = {proxy="", home=sides.up, craft=sides.up},
        fvtm = {proxy="", home=sides.up, craft=sides.up},
        gemmary = {proxy="", home=sides.up, craft=sides.up},
        gendustry = {proxy="", home=sides.up, craft=sides.up},
        gravestone = {proxy="", home=sides.up, craft=sides.up},
        gravitygun = {proxy="", home=sides.up, craft=sides.up},
        harvestcraft = {proxy="", home=sides.up, craft=sides.up},
        hud = {proxy="", home=sides.up, craft=sides.up},
        ic2 = {proxy="", home=sides.up, craft=sides.up},
        ichunutil = {proxy="", home=sides.up, craft=sides.up},
        immcraft = {proxy="", home=sides.up, craft=sides.up},
        immersiveengineering = {proxy="", home=sides.up, craft=sides.up},
        immersivehempcraft = {proxy="", home=sides.up, craft=sides.up},
        immersiverailroading = {proxy="", home=sides.up, craft=sides.up},
        immersivetech = {proxy="", home=sides.up, craft=sides.up},
        industrialforegoing = {proxy="", home=sides.up, craft=sides.up},
        infernomobs = {proxy="", home=sides.up, craft=sides.up},
        infinitycraft = {proxy="", home=sides.up, craft=sides.up},
        inventorytweaks = {proxy="", home=sides.up, craft=sides.up},
        itorch = {proxy="", home=sides.up, craft=sides.up},
        jehc = {proxy="", home=sides.up, craft=sides.up},
        jei = {proxy="", home=sides.up, craft=sides.up},
        jeibees = {proxy="", home=sides.up, craft=sides.up},
        jeiintegration = {proxy="", home=sides.up, craft=sides.up},
        jeresources = {proxy="", home=sides.up, craft=sides.up},
        junglemobs = {proxy="", home=sides.up, craft=sides.up},
        lycanitesmobs = {proxy="", home=sides.up, craft=sides.up},
        magicbees = {proxy="", home=sides.up, craft=sides.up},
        malisisadvert = {proxy="", home=sides.up, craft=sides.up},
        malisisblocks = {proxy="", home=sides.up, craft=sides.up},
        malisiscore = {proxy="", home=sides.up, craft=sides.up},
        malisisdoors = {proxy="", home=sides.up, craft=sides.up},
        malisisswitches = {proxy="", home=sides.up, craft=sides.up},
        mantle = {proxy="", home=sides.up, craft=sides.up},
        mcjtylib_ng = {proxy="", home=sides.up, craft=sides.up},
        mcp = {proxy="", home=sides.up, craft=sides.up},
        mekanism = {proxy="", home=sides.up, craft=sides.up},
        mekanismgenerators = {proxy="", home=sides.up, craft=sides.up},
        mekanismtools = {proxy="", home=sides.up, craft=sides.up},
        minewatch = {proxy="", home=sides.up, craft=sides.up},
        moarfood = {proxy="", home=sides.up, craft=sides.up},
        moartinkers = {proxy="", home=sides.up, craft=sides.up},
        mobends = {proxy="", home=sides.up, craft=sides.up},
        modcurrency = {proxy="", home=sides.up, craft=sides.up},
        modernmetals = {proxy="", home=sides.up, craft=sides.up},
        morebeautifulbuttons = {proxy="", home=sides.up, craft=sides.up},
        morebeautifulplates = {proxy="", home=sides.up, craft=sides.up},
        mores = {proxy="", home=sides.up, craft=sides.up},
        mountainmobs = {proxy="", home=sides.up, craft=sides.up},
        movingworld = {proxy="", home=sides.up, craft=sides.up},
        mxtune = {proxy="", home=sides.up, craft=sides.up},
        mysticalagradditions = {proxy="", home=sides.up, craft=sides.up},
        mysticalagriculture = {proxy="", home=sides.up, craft=sides.up},
        neid = {proxy="", home=sides.up, craft=sides.up},
        nethermetals = {proxy="", home=sides.up, craft=sides.up},
        netherportalfix = {proxy="", home=sides.up, craft=sides.up},
        nuclearcraft = {proxy="", home=sides.up, craft=sides.up},
        ocjs = {proxy="", home=sides.up, craft=sides.up},
        ocsensors = {proxy="", home=sides.up, craft=sides.up},
        ocxnetdriver = {proxy="", home=sides.up, craft=sides.up},
        opencomputers = {proxy="", home=sides.up, craft=sides.up},
        opencomputerscore = {proxy="", home=sides.up, craft=sides.up},
        openglider = {proxy="", home=sides.up, craft=sides.up},
        openterraingenerator = {proxy="", home=sides.up, craft=sides.up},
        orespawn = {proxy="", home=sides.up, craft=sides.up},
        otgcore = {proxy="", home=sides.up, craft=sides.up},
        persistentbits = {proxy="", home=sides.up, craft=sides.up},
        personalcars = {proxy="", home=sides.up, craft=sides.up},
        placeableitems = {proxy="", home=sides.up, craft=sides.up},
        plainsmobs = {proxy="", home=sides.up, craft=sides.up},
        plants2 = {proxy="", home=sides.up, craft=sides.up},
        platforms = {proxy="", home=sides.up, craft=sides.up},
        props = {proxy="", home=sides.up, craft=sides.up},
        psi = {proxy="", home=sides.up, craft=sides.up},
        ptrmodellib = {proxy="", home=sides.up, craft=sides.up},
        quantumstorage = {proxy="", home=sides.up, craft=sides.up},
        questbook = {proxy="", home=sides.up, craft=sides.up},
        radixcore = {proxy="", home=sides.up, craft=sides.up},
        rafradek_tf2_weapons = {proxy="", home=sides.up, craft=sides.up},
        rangedpumps = {proxy="", home=sides.up, craft=sides.up},
        reborncore = {proxy="", home=sides.up, craft=sides.up},
        rebornstorage = {proxy="", home=sides.up, craft=sides.up},
        redstonearsenal = {proxy="", home=sides.up, craft=sides.up},
        redstoneflux = {proxy="", home=sides.up, craft=sides.up},
        redstonepaste = {proxy="", home=sides.up, craft=sides.up},
        refinedstorage = {proxy="", home=sides.up, craft=sides.up},
        rftools = {proxy="", home=sides.up, craft=sides.up},
        rftoolscontrol = {proxy="", home=sides.up, craft=sides.up},
        rftoolsdim = {proxy="", home=sides.up, craft=sides.up},
        runecraft = {proxy="", home=sides.up, craft=sides.up},
        rustic = {proxy="", home=sides.up, craft=sides.up},
        saltmod = {proxy="", home=sides.up, craft=sides.up},
        saltwatermobs = {proxy="", home=sides.up, craft=sides.up},
        shadowmobs = {proxy="", home=sides.up, craft=sides.up},
        shetiphiancore = {proxy="", home=sides.up, craft=sides.up},
        signpost = {proxy="", home=sides.up, craft=sides.up},
        simpledimensions = {proxy="", home=sides.up, craft=sides.up},
        simplytea = {proxy="", home=sides.up, craft=sides.up},
        swampmobs = {proxy="", home=sides.up, craft=sides.up},
        tconstruct = {proxy="", home=sides.up, craft=sides.up},
        techreborn = {proxy="", home=sides.up, craft=sides.up},
        terraqueous = {proxy="", home=sides.up, craft=sides.up},
        tesla = {proxy="", home=sides.up, craft=sides.up},
        teslacorelib = {proxy="", home=sides.up, craft=sides.up},
        teslacorelib_registries = {proxy="", home=sides.up, craft=sides.up},
        teslathingies = {proxy="", home=sides.up, craft=sides.up},
        theoneprobe = {proxy="", home=sides.up, craft=sides.up},
        thermalcultivation = {proxy="", home=sides.up, craft=sides.up},
        thermaldynamics = {proxy="", home=sides.up, craft=sides.up},
        thermalexpansion = {proxy="", home=sides.up, craft=sides.up},
        thermalfoundation = {proxy="", home=sides.up, craft=sides.up},
        tinkersoc = {proxy="", home=sides.up, craft=sides.up},
        tinkertoolleveling = {proxy="", home=sides.up, craft=sides.up},
        torcharrowsmod = {proxy="", home=sides.up, craft=sides.up},
        trackapi = {proxy="", home=sides.up, craft=sides.up},
        twilightforest = {proxy="", home=sides.up, craft=sides.up},
        uniquecrops = {proxy="", home=sides.up, craft=sides.up},
        unlimitedchiselworks = {proxy="", home=sides.up, craft=sides.up},
        unlimitedchiselworks_botany = {proxy="", home=sides.up, craft=sides.up},
        valkyrielib = {proxy="", home=sides.up, craft=sides.up},
        vc = {proxy="", home=sides.up, craft=sides.up},
        waddles = {proxy="", home=sides.up, craft=sides.up},
        worldutils = {proxy="", home=sides.up, craft=sides.up},
        xnet = {proxy="", home=sides.up, craft=sides.up},
        xray = {proxy="", home=sides.up, craft=sides.up},
        xreliquary = {proxy="", home=sides.up, craft=sides.up},
        zerocore = {proxy="", home=sides.up, craft=sides.up},
        actuallyadditions = {proxy="", home=sides.up, craft=sides.up},
        adhooks = {proxy="", home=sides.up, craft=sides.up},
        advancedrocketry = {proxy="", home=sides.up, craft=sides.up},
        ae2stuff = {proxy="", home=sides.up, craft=sides.up},
        aether_legacy = {proxy="", home=sides.up, craft=sides.up},
        animania = {proxy="", home=sides.up, craft=sides.up},
        appliedenergistics2 = {proxy="", home=sides.up, craft=sides.up},
        aquamunda = {proxy="", home=sides.up, craft=sides.up},
        astikoor = {proxy="", home=sides.up, craft=sides.up},
        atlcraft = {proxy="", home=sides.up, craft=sides.up},
        basemetals = {proxy="", home=sides.up, craft=sides.up},
        betterquesting = {proxy="", home=sides.up, craft=sides.up},
        bibliocraft = {proxy="", home=sides.up, craft=sides.up},
        binniecore = {proxy="", home=sides.up, craft=sides.up},
        binniedesign = {proxy="", home=sides.up, craft=sides.up},
        biomesoplenty = {proxy="", home=sides.up, craft=sides.up},
        botania = {proxy="", home=sides.up, craft=sides.up},
        botany = {proxy="", home=sides.up, craft=sides.up},
        buildcraftbuilders = {proxy="", home=sides.up, craft=sides.up},
        buildcraftcore = {proxy="", home=sides.up, craft=sides.up},
        buildcraftenergy = {proxy="", home=sides.up, craft=sides.up},
        buildcraftfactory = {proxy="", home=sides.up, craft=sides.up},
        buildcraftlib = {proxy="", home=sides.up, craft=sides.up},
        buildcraftrobotics = {proxy="", home=sides.up, craft=sides.up},
        buildcraftsilicon = {proxy="", home=sides.up, craft=sides.up},
        buildcrafttransport = {proxy="", home=sides.up, craft=sides.up},
        extrabees = {proxy="", home=sides.up, craft=sides.up},
        extratrees = {proxy="", home=sides.up, craft=sides.up},
        genetics = {proxy="", home=sides.up, craft=sides.up},
        libvulpes = {proxy="", home=sides.up, craft=sides.up},
        minecraft = {proxy="", home=sides.up, craft=sides.up}
    }
end
local function GetRoute(mod, typ, destinationmod)
    local typ2 = ""
    if(typ == "craft")then
        typ2 = "home"
    else
        typ2 = "craft"
    end 
    local proxy = Proxies()
    local routesystem = RouteSystem()
    if((mod == destinationmod) or (destinationmod == nil))then
        return {{proxy = proxy[mod][typ2].proxy, side=proxy[mod][typ2][("to" .. typ)]}}
    else
        return {{proxy = proxy[mod][typ2].proxy, side=proxy[mod][typ2].toroute}; {proxy = routesystem[destinationmod].proxy, side=routesystem[destinationmod][typ]}}
    end
end
local function GetProxy(mod, typ)
    if(mod == "routing")then
        return ""
    else
        local proxy = Proxies()
        return proxy[mod][typ].proxy
    end
end
local function GetProx(mod, typ)
    if(mod == "routing")then
        return ""
    else
        local proxy = Proxies()
        return proxy[mod][typ]
    end
end
prox.GetRoute = GetRoute
prox.GetProxy = GetProxy
prox.GetProx = GetProx

return prox