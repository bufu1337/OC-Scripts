local sides = require("sides")
local prox = {}
local function Proxies(name)
    local pr = {
        minecraft={home={proxy="bb705998-ea01-43da-a771-df74cd53cadf", tocraft=sides.west, toroute=sides.east}, craft={proxy="59c6cb63-3294-43b9-a36d-eb65669477ee", tohome=sides.south, toroute=sides.east}, route={proxy="b6f438be-9e4e-43f9-840e-bbec27971a09", home=sides.east, route=sides.west}},
        chimneys={home={proxy="88f3f731-d4cc-468a-9bde-efe17fb89f33", tocraft=sides.west, toroute=sides.east}, craft={proxy="f520f06f-2ca5-4443-bf59-4198a4499520", tohome=sides.south, toroute=sides.east}, route={proxy="3c20d393-1595-4324-aabf-1bdc141bbcb5", home=sides.east, route=sides.west}},
        others={home={proxy="8ba270f8-408d-49dc-b50a-e6354d5235ee", tocraft=sides.west, toroute=sides.east}, craft={proxy="e2275cb7-5417-40fd-8b6d-fd201f6dd7d5", tohome=sides.south, toroute=sides.east}, route={proxy="4aef5bec-42d5-44a9-bd92-068bfcb00511", home=sides.east, route=sides.west}},
        draconic={home={proxy="544ad8b1-ee26-4b34-b832-45ffa193a615", tocraft=sides.west, toroute=sides.east}, craft={proxy="1fe6244f-d827-454c-8b55-04f0bbeb479b", tohome=sides.south, toroute=sides.east}, route={proxy="e333b629-221a-4575-ad8b-1ed72fad8943", home=sides.east, route=sides.west}},
        conquest={home={proxy="283f524e-21d8-417a-b58a-c6fe2affeb95", tocraft=sides.west, toroute=sides.east}, craft={proxy="edc2605c-75fa-4575-92cc-eb1e47d74765", tohome=sides.south, toroute=sides.east}, route={proxy="3b9a461b-5fa1-49a0-8f78-c1da0b615d30", home=sides.east, route=sides.west}},
        pillar={home={proxy="85db3f15-d705-4329-b71c-cba80ebc02f5", tocraft=sides.west, toroute=sides.east}, craft={proxy="2e465f86-5da6-4b53-8b0a-154cd92828d3", tohome=sides.south, toroute=sides.east}, route={proxy="15a1cec9-bd70-45e3-9c5e-8764805b5194", home=sides.east, route=sides.west}},
        utilities={home={proxy="fa2fb100-e43c-4bfb-b116-53e0b764f0f0", tocraft=sides.west, toroute=sides.east}, craft={proxy="7adafc97-4380-4994-801d-942fc3a1784f", tohome=sides.south, toroute=sides.east}, route={proxy="7849e03e-8029-4215-bee3-ef75fe8a1cb4", home=sides.east, route=sides.west}},
        environ={home={proxy="77d5666f-733c-4c41-8a82-1e73af1186cd", tocraft=sides.west, toroute=sides.east}, craft={proxy="490da3ac-e650-41bd-9697-250dbdf25309", tohome=sides.south, toroute=sides.east}, route={proxy="fa216edb-38d4-4bdf-93ac-4e3809af8f38", home=sides.east, route=sides.west}},
        flat={home={proxy="219c377c-58ff-45c5-aa4a-a61c6a1dca7f", tocraft=sides.east, toroute=sides.west}, craft={proxy="469e7dc4-5a30-4774-acc5-5cee47f152f8", tohome=sides.south, toroute=sides.west}, route={proxy="92daa3ee-da9d-4b9d-bad8-d54391389a0b", home=sides.west, route=sides.east}},
        fiifex={home={proxy="7595f7c0-b1ad-48b7-ba14-c0d0e022daa6", tocraft=sides.east, toroute=sides.west}, craft={proxy="21446d84-62e0-432d-b2f4-3dd06626155f", tohome=sides.south, toroute=sides.west}, route={proxy="adf0f536-2c04-4378-b6bf-b915ee167fa5", home=sides.west, route=sides.east}},
        forestry={home={proxy="792c250c-4626-47b9-a884-1f6885cc95e2", tocraft=sides.east, toroute=sides.west}, craft={proxy="3de55085-01cd-4b8d-8a14-51bbfa6a168f", tohome=sides.south, toroute=sides.west}, route={proxy="10e5b513-d84e-400b-b149-ea54d0a832f8", home=sides.west, route=sides.east}},
        future={home={proxy="af0d3d9c-2557-48b0-824a-f3253129328a", tocraft=sides.east, toroute=sides.west}, craft={proxy="b6df51db-8219-4b7c-9a6d-c33083290ed7", tohome=sides.south, toroute=sides.west}, route={proxy="0ec2e8d3-cf5e-472f-9302-7407565ea7b3", home=sides.west, route=sides.east}},
        food={home={proxy="50575962-3565-4365-8c0c-8e520efa2970", tocraft=sides.east, toroute=sides.west}, craft={proxy="9f9368ac-7a54-47e0-88dc-a3e4892bba1b", tohome=sides.south, toroute=sides.west}, route={proxy="1a64b305-ed4a-4fa8-9d5b-2c9dad9e2657", home=sides.west, route=sides.east}},
        industrial={home={proxy="95db9eec-3ade-4c06-8c71-1478c3d7e3de", tocraft=sides.east, toroute=sides.west}, craft={proxy="65ff3831-68a9-4012-a32e-faaac07f7a7d", tohome=sides.south, toroute=sides.west}, route={proxy="a4b3febc-e30c-4710-941e-f2522a847854", home=sides.west, route=sides.east}},
        immersive={home={proxy="3a309850-e908-4919-a639-63ebfd84174f", tocraft=sides.east, toroute=sides.west}, craft={proxy="36e15dab-c9f1-4621-b8b2-cbc2c4218f4c", tohome=sides.south, toroute=sides.west}, route={proxy="e55640ae-7d70-4160-9039-9766ef49267a", home=sides.west, route=sides.east}},
        railroad={home={proxy="5df25b59-cf9b-409a-8644-e59fb7521947", tocraft=sides.east, toroute=sides.west}, craft={proxy="995eaa09-68bb-4e0e-8b31-8b8e9a3a2ef4", tohome=sides.south, toroute=sides.west}, route={proxy="7cd74f03-06e0-4731-aebe-943e7f3a05bf", home=sides.west, route=sides.east}},
        mekanism={home={proxy="c0726f3a-3661-4d2e-a67e-4b9398cf38a8", tocraft=sides.west, toroute=sides.east}, craft={proxy="3cde4183-f0b0-4eb7-a879-f06082d151d9", tohome=sides.south, toroute=sides.east}, route={proxy="fd750485-8eb6-4f34-8fdd-9d57b9cba002", home=sides.east, route=sides.west}},
        minewatch={home={proxy="65e660e4-fe07-4b2f-96a2-530cda054e4e", tocraft=sides.west, toroute=sides.east}, craft={proxy="e844d25f-037b-4d9f-a6f5-758f848e11b3", tohome=sides.south, toroute=sides.east}, route={proxy="266a26bd-f121-4f66-84e6-498684a67083", home=sides.east, route=sides.west}},
        more={home={proxy="4ea11d9e-3ea5-4f58-9fea-49ff8464092e", tocraft=sides.west, toroute=sides.east}, craft={proxy="abf79c82-b00b-4cee-829c-ad6d36dab51e", tohome=sides.south, toroute=sides.east}, route={proxy="bb86e549-295e-4c80-938e-022eae961a2c", home=sides.east, route=sides.west}},
        mystical={home={proxy="3e6052fe-8363-4ba6-aa3c-bd9427cda488", tocraft=sides.west, toroute=sides.east}, craft={proxy="c249bcf1-946f-43c4-bfce-f30e5c1640b2", tohome=sides.south, toroute=sides.east}, route={proxy="97c75567-0587-484a-a913-5d8c5bd5b673", home=sides.east, route=sides.west}},
        modern={home={proxy="9ba9f521-5355-44f6-86d0-b69a3ffe458b", tocraft=sides.west, toroute=sides.east}, craft={proxy="d4f7b874-ccb7-4e7f-9996-dca91b9b36ef", tohome=sides.south, toroute=sides.east}, route={proxy="8d1a00a7-1de1-4eb0-aca7-21bb173c8b92", home=sides.east, route=sides.west}},
        nuclear={home={proxy="dbdd4e24-1123-49b1-ac17-fb802379bd6e", tocraft=sides.west, toroute=sides.east}, craft={proxy="65049d55-13c8-4039-81b5-7238fb3edb4a", tohome=sides.south, toroute=sides.east}, route={proxy="25c51d88-501e-4bf1-8761-0a5334b38029", home=sides.east, route=sides.west}},
        storage={home={proxy="dc099cb8-99a4-4389-8f6e-651836e989c6", tocraft=sides.west, toroute=sides.east}, craft={proxy="79b21d3b-8899-469a-b9c7-ef4be8803ee7", tohome=sides.south, toroute=sides.east}, route={proxy="45925852-26f5-4a51-9195-e05da2f0e4d3", home=sides.east, route=sides.west}},
        deco={home={proxy="c8a11d9a-72d7-4be9-9116-5b39d4c61e1c", tocraft=sides.west, toroute=sides.east}, craft={proxy="6767c3c9-efdc-48b1-b57b-814c9ed0cceb", tohome=sides.south, toroute=sides.east}, route={proxy="971975a3-0581-4edf-b260-6a17aeb2cdee", home=sides.east, route=sides.west}},
        rftools={home={proxy="7067ba9c-a046-4639-ad78-5446ccff3bc3", tocraft=sides.east, toroute=sides.west}, craft={proxy="0a4a7858-7ff2-4c67-aac0-9a744e2827e2", tohome=sides.south, toroute=sides.west}, route={proxy="2da61edf-e8c9-401f-8937-b5cd14efb538", home=sides.west, route=sides.east}},
        plants={home={proxy="d9191998-b161-4273-b366-607171df1135", tocraft=sides.east, toroute=sides.west}, craft={proxy="fb268d86-34ec-42ce-906f-770bcc24cc95", tohome=sides.south, toroute=sides.west}, route={proxy="7f41bc23-af37-4f81-b967-30925ec6c88f", home=sides.west, route=sides.east}},
        tinkers={home={proxy="27736f6c-c19c-4152-ae68-b28282b7efea", tocraft=sides.east, toroute=sides.west}, craft={proxy="31e5e559-b686-4b28-9e94-27d37739cac1", tohome=sides.south, toroute=sides.west}, route={proxy="462756b6-62bb-4858-87f5-e17a9b638476", home=sides.west, route=sides.east}},
        treborn={home={proxy="d475544f-84e2-4cb5-998c-98cd165ff08a", tocraft=sides.east, toroute=sides.west}, craft={proxy="0ac405b1-8ada-4451-80ba-e2fbfca962f5", tohome=sides.south, toroute=sides.west}, route={proxy="7e483a5e-d03c-4768-8c3d-68a809499a49", home=sides.west, route=sides.east}},
        terra={home={proxy="ac1c60cc-0d7e-4a68-8560-bcf456aa5c83", tocraft=sides.east, toroute=sides.west}, craft={proxy="4a67d33e-56d1-4ba0-8757-85ad455cd551", tohome=sides.south, toroute=sides.west}, route={proxy="d89c9188-652b-45ae-9f03-29e743872f43", home=sides.west, route=sides.east}},
        thermal={home={proxy="6eb97680-f6fb-431b-8da7-b346cbc494f4", tocraft=sides.east, toroute=sides.west}, craft={proxy="5d1dc33e-8a41-4b9d-adaf-c7f2c7674ba1", tohome=sides.south, toroute=sides.west}, route={proxy="4f5e4ffb-8654-4f21-9007-46032725d0d1", home=sides.west, route=sides.east}},
        reliq={home={proxy="f389cc63-0760-480c-9cec-06e2e86279c8", tocraft=sides.east, toroute=sides.west}, craft={proxy="ff27a073-4312-4211-8bd7-0e718184ca8d", tohome=sides.south, toroute=sides.west}, route={proxy="9b31f0f2-e523-4f48-aec0-4c2445e86b2d", home=sides.west, route=sides.east}},
        appen={home={proxy="968b99b3-c4f6-4ed0-b8bd-51e2700441aa", tocraft=sides.east, toroute=sides.west}, craft={proxy="997da8b5-0332-4277-98c6-6561326a4baa", tohome=sides.south, toroute=sides.west}, route={proxy="dce29bd7-9246-42d2-b76b-2d4556bb1b53", home=sides.west, route=sides.east}},
        atl={home={proxy="1863a856-c6e0-4b52-8b7c-dad99e897b92", tocraft=sides.west, toroute=sides.east}, craft={proxy="1d7a3a17-32e5-4132-9713-d3b87e4b574e", tohome=sides.south, toroute=sides.east}, route={proxy="f2a57f54-7215-4d02-8bec-bb34486d901b", home=sides.east, route=sides.west}},
        actadd={home={proxy="cbda7117-5552-463b-a34c-3745a42dd4ac", tocraft=sides.west, toroute=sides.east}, craft={proxy="0784113f-f715-4dba-9632-5411b0283caa", tohome=sides.south, toroute=sides.east}, route={proxy="aedd78a2-5667-4001-a2dd-353c951f9e40", home=sides.east, route=sides.west}},
        rocketry={home={proxy="46374d56-e755-40ec-a652-e8d5a9a5ecc6", tocraft=sides.west, toroute=sides.east}, craft={proxy="c4b48dec-c96c-4c8f-94c6-8d23cfae1c1e", tohome=sides.south, toroute=sides.east}, route={proxy="ef77717a-67fe-46e6-8499-4d86f45c8006", home=sides.east, route=sides.west}},
        aether={home={proxy="ce671fc9-aed7-4e34-bd24-6cbe541f471a", tocraft=sides.west, toroute=sides.east}, craft={proxy="b12314bd-e0fa-42b9-b52d-05963a906337", tohome=sides.south, toroute=sides.east}, route={proxy="a1d8209c-0382-42a6-a84f-dc6d5596c320", home=sides.east, route=sides.west}},
        metals={home={proxy="2b870753-2a07-4754-abcc-8a44fa3b3094", tocraft=sides.west, toroute=sides.east}, craft={proxy="a32f09d1-a89f-4e2f-a1ef-2728d7428c57", tohome=sides.south, toroute=sides.east}, route={proxy="ee605d63-ff10-41c8-86f3-ebb636649aa0", home=sides.east, route=sides.west}},
        biblio={home={proxy="a8e3332c-bfc9-4135-addb-1afcb94e5f86", tocraft=sides.west, toroute=sides.east}, craft={proxy="81f36aa4-2323-4050-b77c-90e9d74cf67d", tohome=sides.south, toroute=sides.east}, route={proxy="de9b249e-c4a9-497e-b904-2a90a0730631", home=sides.east, route=sides.west}},
        btrees={home={proxy="55476aaa-27a0-49f8-94f3-a520bb4ff3ba", tocraft=sides.west, toroute=sides.east}, craft={proxy="c7682b9b-5ac7-4cc7-bfab-0f222564c130", tohome=sides.south, toroute=sides.east}, route={proxy="88ba0e80-cd07-4381-9504-c64e38450da6", home=sides.east, route=sides.west}},
        binnie={home={proxy="7a9a06eb-d075-4f51-ad4d-106e29d88bb5", tocraft=sides.west, toroute=sides.east}, craft={proxy="d147b09b-bbde-49e0-abd5-2137c25e4e1e", tohome=sides.south, toroute=sides.east}, route={proxy="f86f491f-6292-422f-affe-67185c4b1f31", home=sides.east, route=sides.west}},
        biomes={home={proxy="715a4784-9e1f-405d-b083-0d87e158287d", tocraft=sides.east, toroute=sides.west}, craft={proxy="83a3d2fd-a74d-4f82-a1ba-34a794ddf53e", tohome=sides.south, toroute=sides.west}, route={proxy="3bfa3e23-4def-440b-8d5a-4fa527b2045d", home=sides.west, route=sides.east}},
        botania={home={proxy="f888a5f4-bc38-4a86-9db0-abdbe0dc65cf", tocraft=sides.east, toroute=sides.west}, craft={proxy="2e42d3f1-0d96-4eb8-a424-9ab3c552d95d", tohome=sides.south, toroute=sides.west}, route={proxy="c0c8aa54-a717-4317-b754-1bda93e55123", home=sides.west, route=sides.east}},
        ceramics={home={proxy="227a77dd-1d55-45a7-a6ef-f907991a7563", tocraft=sides.east, toroute=sides.west}, craft={proxy="aa761218-b6f2-4938-a196-122ff93accd4", tohome=sides.south, toroute=sides.west}, route={proxy="e473e01b-8517-4a0b-ba8e-4884ebf96e00", home=sides.west, route=sides.east}},
        chisel={home={proxy="f5a121fe-ac8b-4cae-9e9e-50c39108cd39", tocraft=sides.east, toroute=sides.west}, craft={proxy="87f6d3a4-4994-4562-b527-2d144959ff41", tohome=sides.south, toroute=sides.west}, route={proxy="8096f96b-b601-4e69-936b-2850393accf1", home=sides.west, route=sides.east}},
        bits={home={proxy="07d15bf4-11af-4dc8-9f7f-9239c14d56ac", tocraft=sides.east, toroute=sides.west}, craft={proxy="c8d71eda-e38e-44c6-be5b-339488e664b3", tohome=sides.south, toroute=sides.west}, route={proxy="cdbe9f2c-005a-4783-a4e2-b72b69052fa7", home=sides.west, route=sides.east}},
        cyclic={home={proxy="b07569c8-597b-4a19-acd0-91650f8bcb1d", tocraft=sides.east, toroute=sides.west}, craft={proxy="3a6ede2a-ee15-4b2e-991b-36b0e7903c12", tohome=sides.south, toroute=sides.west}, route={proxy="524b9600-1d8d-485b-af10-54427c11c2b1", home=sides.west, route=sides.east}},
        diy={home={proxy="7540d1a6-9197-46dd-a5a0-730a458d7f4f", tocraft=sides.east, toroute=sides.west}, craft={proxy="58dfc65f-01f1-4f36-b17e-bf6b96b35947", tohome=sides.south, toroute=sides.west}, route={proxy="19c2f913-f8f4-4be3-b3ce-a748a8f8a9d3", home=sides.west, route=sides.east}},
        extra{home={proxy="deeecb32-1d42-4bd3-8a80-53f6a442cef1", tocraft=sides.east, toroute=sides.west}, craft={proxy="52f4efa4-e178-4775-971e-cdfbd29ad9de", tohome=sides.south, toroute=sides.west}, route={proxy="1d59159c-08cd-4a7a-b022-24a6402e9ff2", home=sides.west, route=sides.east}}
    }
    return pr[name]
end
local function ModToPName(mod)
    local mtpn = {
        actuallyadditions = "actadd",
        actuallycomputers = "actadd",
        adchimneys = "chimneys",
        adhooks = "others",
        advancedrocketry = "rocketry",
        ae2stuff = "appen",
        aether_legacy = "aether",
        animania = "aether",
        aperture = "",
        appliedenergistics2 = "appen",
        aquamunda = "others",
        arcticmobs = "cyclic",
        as_extraresources = "chimneys",
        astikoor = "others",
        atlcraft = "atl",
        autoreglib = "",
        basemetals = "metals",
        baubles = "others",
        betterquesting = "others",
        bibliocraft = "biblio",
        bigreactors = "others",
        binniecore = "btrees",
        binniedesign = "binnie",
        biomebundle = "biomes",
        biomesoplenty = "biomes",
        blockpalette = "",
        bookshelf = "",
        botania = "botania",
        botany = "binnie",
        bq_standard = "others",
        buildcraftbuilders = "rocketry",
        buildcraftcore = "rocketry",
        buildcraftenergy = "rocketry",
        buildcraftfactory = "rocketry",
        buildcraftlib = "rocketry",
        buildcraftrobotics = "rocketry",
        buildcraftsilicon = "rocketry",
        buildcrafttransport = "rocketry",
        bushmastercore = "",
        car = "draconic",
        carryon = "others",
        carz = "others",
        cdm = "draconic",
        ceramics = "ceramics",
        cfm = "draconic",
        chisel = "chisel",
        chiselsandbits = "bits",
        chunkpregenerator = "",
        codechickenlib = "",
        cofhcore = "",
        cofhworld = "",
        compactmachines3 = "others",
        compot = "",
        connect = "",
        conquest = "conquest",
        cookingforblockheads = "others",
        corail_pillar = "pillar",
        corail_pillar_extension_biomesoplenty = "pillar",
        corail_pillar_extension_chisel = "pillar",
        corail_pillar_extension_forestry = "pillar",
        coralreef = "others",
        craftstudioapi = "",
        crafttweaker = "",
        crafttweakerjei = "",
        ctgui = "",
        ctm = "",
        cucumber = "",
        customnpcs = "others",
        cyclicmagic = "cyclic",
        darkutils = "utilities",
        davincisvessels = "others",
        ddb = "diy",
        deepresonance = "others",
        defiledlands = "utilities",
        demonmobs = "cyclic",
        desertmobs = "cyclic",
        draconicevolution = "draconic",
        dynamiclights = "",
        dynamiclights_creepers = "",
        dynamiclights_dropitems = "",
        dynamiclights_entityclasses = "",
        dynamiclights_flamearrows = "",
        dynamiclights_floodlights = "",
        dynamiclights_mobequipment = "",
        dynamiclights_onfire = "",
        dynamiclights_otherplayers = "",
        dynamiclights_theplayer = "",
        eleccore = "",
        electrostatics = "others",
        elementalmobs = "cyclic",
        energyconverters = "others",
        environmentalmaterials = "environ",
        environmentaltech = "environ",
        etlunar = "environ",
        extrabees = "binnie",
        extrabitmanipulation = "others",
        extratrees = "btrees",
        extrautils2 = "utilities",
        fairylights = "flat",
        farmory = "fiifex",
        fcl = "fiifex",
        fdecostuff = "fiifex",
        ffactory = "fiifex",
        ffoods = "fiifex",
        flatcoloredblocks = "flat",
        floricraft = "flat",
        fmagic = "fiifex",
        FML = "",
        forestmobs = "cyclic",
        forestry = "forestry",
        forge = "minecraft",
        forgeendertech = "",
        forgelin = "",
        fp = "future",
        fpapi = "future",
        fpfa = "future",
        freshwatermobs = "cyclic",
        fresource = "fiifex",
        frsm = "fiifex",
        fvtm = "fiifex",
        gemmary = "others",
        gendustry = "binnie",
        genetics = "binnie",
        gravestone = "others",
        gravitygun = "others",
        harvestcraft = "food",
        hud = "",
        ic2 = "industrial",
        ichunutil = "others",
        immcraft = "immersive",
        immersiveengineering = "immersive",
        immersivehempcraft = "immersive",
        immersiverailroading = "railroad",
        immersivetech = "immersive",
        industrialforegoing = "fiifex",
        infernomobs = "cyclic",
        infinitycraft = "fiifex",
        inventorytweaks = "",
        itorch = "others",
        jehc = "",
        jei = "",
        jeibees = "",
        jeiintegration = "",
        jeresources = "",
        junglemobs = "cyclic",
        libvulpes = "rocketry",
        lycanitesmobs = "cyclic",
        magicbees = "binnie",
        malisisadvert = "others",
        malisisblocks = "others",
        malisiscore = "others",
        malisisdoors = "others",
        malisisswitches = "others",
        mantle = "",
        mcjtylib_ng = "",
        mcp = "",
        mekanism = "mekanism",
        mekanismgenerators = "mekanism",
        mekanismtools = "mekanism",
        minecraft = "minecraft",
        minewatch = "minewatch",
        moarfood = "food",
        moartinkers = "tinkers",
        mobends = "",
        modcurrency = "others",
        modernmetals = "modern",
        morebeautifulbuttons = "more",
        morebeautifulplates = "more",
        mores = "minewatch",
        mountainmobs = "cyclic",
        movingworld = "",
        mxtune = "others",
        mysticalagradditions = "mystical",
        mysticalagriculture = "mystical",
        neid = "",
        nethermetals = "cyclic",
        netherportalfix = "",
        nuclearcraft = "nuclear",
        ocjs = "",
        ocsensors = "storage",
        ocxnetdriver = "storage",
        opencomputers = "storage",
        opencomputerscore = "storage",
        openglider = "others",
        openterraingenerator = "",
        orespawn = "",
        otgcore = "",
        persistentbits = "others",
        personalcars = "draconic",
        placeableitems = "others",
        plainsmobs = "cyclic",
        plants2 = "plants",
        platforms = "others",
        props = "deco",
        psi = "others",
        ptrmodellib = "",
        quantumstorage = "storage",
        questbook = "",
        radixcore = "",
        rafradek_tf2_weapons = "minewatch",
        rangedpumps = "others",
        reborncore = "storage",
        rebornstorage = "storage",
        redstonearsenal = "others",
        redstoneflux = "",
        redstonepaste = "others",
        refinedstorage = "storage",
        rftools = "rftools",
        rftoolscontrol = "rftools",
        rftoolsdim = "rftools",
        runecraft = "others",
        rustic = "plants",
        saltmod = "others",
        saltwatermobs = "cyclic",
        shadowmobs = "cyclic",
        shetiphiancore = "",
        signpost = "others",
        simpledimensions = "others",
        simplytea = "others",
        swampmobs = "cyclic",
        tconstruct = "tinkers",
        techreborn = "treborn",
        terraqueous = "terra",
        tesla = "terra",
        teslacorelib = "terra",
        teslacorelib_registries = "terra",
        teslathingies = "terra",
        theoneprobe = "others",
        thermalcultivation = "thermal",
        thermaldynamics = "thermal",
        thermalexpansion = "thermal",
        thermalfoundation = "thermal",
        tinkersoc = "tinkers",
        tinkertoolleveling = "tinkers",
        torcharrowsmod = "others",
        trackapi = "railroad",
        twilightforest = "plants",
        uniquecrops = "plants",
        unlimitedchiselworks = "chisel",
        unlimitedchiselworks_botany = "chisel",
        valkyrielib = "others",
        vc = "draconic",
        xnet = "others",
        xreliquary = "reliq",
        zerocore = "others",
    }
    return mtpn[mod]
end
local function GetRoute(mod, typ, destinationmod, schalter)
    local typ2 = ""
    if(typ == "craft")then
        typ2 = "home"
    else
        typ2 = "craft"
    end
    local pro = {}
    local ro = {}
    if schalter == 1 then
        pro = GetProxByName(mod, typ2)
        ro = GetProx(destinationmod, "route")
    elseif schalter == 2 then
        pro = GetProx(mod, typ2)
        ro = GetProxByName(destinationmod, "route")
    else
        pro = GetProx(mod, typ2)
        ro = GetProx(destinationmod, "route")
    end
    if((mod == destinationmod) or (destinationmod == nil))then
        return {{proxy = pro.proxy, side=pro[("to" .. typ)]}}
    else
        return {{proxy = pro.proxy, side=pro.toroute}; {proxy = ro.proxy, side=ro[typ]}}
    end
end
local function GetProx(mod, typ)
    local pname = ModToPName(mod)
    print("Mod: " .. mod .. " pname: " .. pname)
    local proxy = Proxies(pname)
    if (proxy[typ] == nil) then
        print("proxy not found for typ: " .. typ)
        return nil
    else
        print("proxy not for typ: " .. typ)
        return proxy[typ]
    end
end
local function GetProxByName(name, typ)
    local proxy = Proxies(name)
    if (proxy == nil) then
        return nil
    else
        if (proxy[typ] == nil) then
            return nil
        else
            return proxy[typ]
        end
    end
end
local function GetProxy(mod, typ)
    local p = GetProx(mod, typ)
    if (p ~= nil) then
        return p.proxy
    else
        return ""
    end
end
local function GetProxByName(name, typ)
    local p = GetProxByName(name, typ)
    if (p ~= nil) then
        return p.proxy
    else
        return ""
    end
end
prox.GetRoute = GetRoute
prox.GetProx = GetProx
prox.GetProxy = GetProxy
prox.GetProxByName = GetProxByName
prox.GetProxyByName = GetProxyByName

return prox


--b6f438be-9e4e-43f9-840e-bbec27971a09

--59c6cb63-3294-43b9-a36d-eb65669477ee

--bb705998-ea01-43da-a771-df74cd53cadf


--3c20d393-1595-4324-aabf-1bdc141bbcb5

--f520f06f-2ca5-4443-bf59-4198a4499520

--88f3f731-d4cc-468a-9bde-efe17fb89f33


--4aef5bec-42d5-44a9-bd92-068bfcb00511

--e2275cb7-5417-40fd-8b6d-fd201f6dd7d5

--8ba270f8-408d-49dc-b50a-e6354d5235ee


--e333b629-221a-4575-ad8b-1ed72fad8943

--1fe6244f-d827-454c-8b55-04f0bbeb479b

--544ad8b1-ee26-4b34-b832-45ffa193a615


--3b9a461b-5fa1-49a0-8f78-c1da0b615d30

--edc2605c-75fa-4575-92cc-eb1e47d74765

--283f524e-21d8-417a-b58a-c6fe2affeb95


--15a1cec9-bd70-45e3-9c5e-8764805b5194

--2e465f86-5da6-4b53-8b0a-154cd92828d3

--85db3f15-d705-4329-b71c-cba80ebc02f5


--7849e03e-8029-4215-bee3-ef75fe8a1cb4

--7adafc97-4380-4994-801d-942fc3a1784f

--fa2fb100-e43c-4bfb-b116-53e0b764f0f0


--fa216edb-38d4-4bdf-93ac-4e3809af8f38

--490da3ac-e650-41bd-9697-250dbdf25309

--77d5666f-733c-4c41-8a82-1e73af1186cd


--92daa3ee-da9d-4b9d-bad8-d54391389a0b

--469e7dc4-5a30-4774-acc5-5cee47f152f8

--219c377c-58ff-45c5-aa4a-a61c6a1dca7f


--adf0f536-2c04-4378-b6bf-b915ee167fa5

--21446d84-62e0-432d-b2f4-3dd06626155f

--7595f7c0-b1ad-48b7-ba14-c0d0e022daa6


--10e5b513-d84e-400b-b149-ea54d0a832f8

--3de55085-01cd-4b8d-8a14-51bbfa6a168f

--792c250c-4626-47b9-a884-1f6885cc95e2


--0ec2e8d3-cf5e-472f-9302-7407565ea7b3

--b6df51db-8219-4b7c-9a6d-c33083290ed7

--af0d3d9c-2557-48b0-824a-f3253129328a


--1a64b305-ed4a-4fa8-9d5b-2c9dad9e2657

--9f9368ac-7a54-47e0-88dc-a3e4892bba1b

--50575962-3565-4365-8c0c-8e520efa2970


--a4b3febc-e30c-4710-941e-f2522a847854

--65ff3831-68a9-4012-a32e-faaac07f7a7d

--95db9eec-3ade-4c06-8c71-1478c3d7e3de


--e55640ae-7d70-4160-9039-9766ef49267a

--36e15dab-c9f1-4621-b8b2-cbc2c4218f4c

--3a309850-e908-4919-a639-63ebfd84174f


--7cd74f03-06e0-4731-aebe-943e7f3a05bf

--995eaa09-68bb-4e0e-8b31-8b8e9a3a2ef4

--5df25b59-cf9b-409a-8644-e59fb7521947


--fd750485-8eb6-4f34-8fdd-9d57b9cba002

--3cde4183-f0b0-4eb7-a879-f06082d151d9

--c0726f3a-3661-4d2e-a67e-4b9398cf38a8


--266a26bd-f121-4f66-84e6-498684a67083

--e844d25f-037b-4d9f-a6f5-758f848e11b3

--65e660e4-fe07-4b2f-96a2-530cda054e4e


--bb86e549-295e-4c80-938e-022eae961a2c

--abf79c82-b00b-4cee-829c-ad6d36dab51e

--4ea11d9e-3ea5-4f58-9fea-49ff8464092e


--97c75567-0587-484a-a913-5d8c5bd5b673

--c249bcf1-946f-43c4-bfce-f30e5c1640b2

--3e6052fe-8363-4ba6-aa3c-bd9427cda488


--8d1a00a7-1de1-4eb0-aca7-21bb173c8b92

--d4f7b874-ccb7-4e7f-9996-dca91b9b36ef

--9ba9f521-5355-44f6-86d0-b69a3ffe458b


--25c51d88-501e-4bf1-8761-0a5334b38029

--65049d55-13c8-4039-81b5-7238fb3edb4a

--dbdd4e24-1123-49b1-ac17-fb802379bd6e


--45925852-26f5-4a51-9195-e05da2f0e4d3

--79b21d3b-8899-469a-b9c7-ef4be8803ee7

--dc099cb8-99a4-4389-8f6e-651836e989c6


--971975a3-0581-4edf-b260-6a17aeb2cdee

--6767c3c9-efdc-48b1-b57b-814c9ed0cceb

--c8a11d9a-72d7-4be9-9116-5b39d4c61e1c


--2da61edf-e8c9-401f-8937-b5cd14efb538

--0a4a7858-7ff2-4c67-aac0-9a744e2827e2

--7067ba9c-a046-4639-ad78-5446ccff3bc3


--7f41bc23-af37-4f81-b967-30925ec6c88f

--fb268d86-34ec-42ce-906f-770bcc24cc95

--d9191998-b161-4273-b366-607171df1135


--462756b6-62bb-4858-87f5-e17a9b638476

--31e5e559-b686-4b28-9e94-27d37739cac1

--27736f6c-c19c-4152-ae68-b28282b7efea


--7e483a5e-d03c-4768-8c3d-68a809499a49

--0ac405b1-8ada-4451-80ba-e2fbfca962f5

--d475544f-84e2-4cb5-998c-98cd165ff08a


--d89c9188-652b-45ae-9f03-29e743872f43

--4a67d33e-56d1-4ba0-8757-85ad455cd551

--ac1c60cc-0d7e-4a68-8560-bcf456aa5c83


--4f5e4ffb-8654-4f21-9007-46032725d0d1

--5d1dc33e-8a41-4b9d-adaf-c7f2c7674ba1

--6eb97680-f6fb-431b-8da7-b346cbc494f4


--9b31f0f2-e523-4f48-aec0-4c2445e86b2d

--ff27a073-4312-4211-8bd7-0e718184ca8d

--f389cc63-0760-480c-9cec-06e2e86279c8


--dce29bd7-9246-42d2-b76b-2d4556bb1b53

--997da8b5-0332-4277-98c6-6561326a4baa

--968b99b3-c4f6-4ed0-b8bd-51e2700441aa
