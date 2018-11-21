local sides = require("sides")
local prox = {}
local function Proxies(name)
    local pr = {
            minecraft={home={proxy="97f620a4-9695-48f3-8ffb-08becd7a1ebd", tocraft=sides.west, toroute=sides.east}, craft={proxy="187ec7d2-0dc1-4ef1-b17e-bdef72caefc3", tohome=sides.south, toroute=sides.east}, route={proxy="f85d4491-60c7-4176-ba0f-fceb9944c7c4", home=sides.east, route=sides.west}},
            chimneys={home={proxy="be9c0857-a0d6-46b2-8c12-b1da84831100", tocraft=sides.west, toroute=sides.east}, craft={proxy="fc2af3a2-cc59-4af7-8107-a8a94a5d6a60", tohome=sides.south, toroute=sides.east}, route={proxy="97b84a66-7e2f-41c7-bbd6-41d7d597cd9d", home=sides.east, route=sides.west}},
            others={home={proxy="1088f55d-6046-4b42-b2fc-746d1e347208", tocraft=sides.west, toroute=sides.east}, craft={proxy="2223f1cf-3380-431a-ba77-d4e1d40ce126", tohome=sides.south, toroute=sides.east}, route={proxy="f804d922-193a-4c24-a0bd-274cdbf4632c", home=sides.east, route=sides.west}},
            draconic={home={proxy="158b83ef-e379-4c54-b64a-713197f26b31", tocraft=sides.west, toroute=sides.east}, craft={proxy="65c0626f-d374-4f6f-9cc5-922ee7c8a0e0", tohome=sides.south, toroute=sides.east}, route={proxy="c51a5326-12dd-45ae-832f-945ecca96ba8", home=sides.east, route=sides.west}},
            conquest={home={proxy="9897c71f-5771-4d08-b41c-6703a5abe250", tocraft=sides.west, toroute=sides.east}, craft={proxy="cc11859e-acd9-49b8-8f2f-80c90663dca9", tohome=sides.south, toroute=sides.east}, route={proxy="1a83d61e-d20e-49fd-8bee-598e829a98d9", home=sides.east, route=sides.west}},
            pillar={home={proxy="ca52d273-9f81-4bcf-97de-4c272a543f50", tocraft=sides.west, toroute=sides.east}, craft={proxy="173e4e9a-c2f7-4a39-a7b1-b7c40b0d391e", tohome=sides.south, toroute=sides.east}, route={proxy="95eca9bd-6709-4066-8452-0fc04ba7174a", home=sides.east, route=sides.west}},
            utilities={home={proxy="ee4f580c-781d-4a6f-89b5-cc73ed7c48b4", tocraft=sides.west, toroute=sides.east}, craft={proxy="a02580f7-e431-4677-a0ca-6ac632d80355", tohome=sides.south, toroute=sides.east}, route={proxy="9b653ed2-e90d-4c02-8505-145b1f64ddbf", home=sides.east, route=sides.west}},
            environ={home={proxy="b7d5900f-287b-4482-a608-980899b7f755", tocraft=sides.west, toroute=sides.east}, craft={proxy="6485be05-53d0-4473-aae8-02c7c0431cc9", tohome=sides.south, toroute=sides.east}, route={proxy="f5aec367-7096-4da1-b8ab-f8625851ab01", home=sides.east, route=sides.west}},
            fairy={home={proxy="b25af6e2-8cd0-48e2-ada7-0f67ba3e7093", tocraft=sides.east, toroute=sides.west}, craft={proxy="21c96f51-ebbf-4d54-a35b-494d366bc9e3", tohome=sides.south, toroute=sides.west}, route={proxy="ab66f881-a610-44f4-b9da-f027a3364e34", home=sides.west, route=sides.east}},
            flat={home={proxy="5debbb19-b43b-4310-ab1d-55efdc03613f", tocraft=sides.east, toroute=sides.west}, craft={proxy="73b384cb-d65d-415a-856a-8171f08244f5", tohome=sides.south, toroute=sides.west}, route={proxy="f3c77c1c-d084-4b5f-b313-86f71127b726", home=sides.west, route=sides.east}},
            fiifex={home={proxy="6c491c53-70b1-43ea-824f-9dbcdf033749", tocraft=sides.east, toroute=sides.west}, craft={proxy="0a64b241-a094-482a-a6fa-6f9b7a16403e", tohome=sides.south, toroute=sides.west}, route={proxy="2b78bc9c-9d50-418d-a6e1-39e3e0ebd47a", home=sides.west, route=sides.east}},
            forestry={home={proxy="5b0aac6f-95f0-4581-a564-61c0f273e5b0", tocraft=sides.east, toroute=sides.west}, craft={proxy="ba78b607-42fd-497e-abbf-6312fc78ada8", tohome=sides.south, toroute=sides.west}, route={proxy="428cdc4a-b470-4cb3-bfad-6792e0e0354e", home=sides.west, route=sides.east}},
            future={home={proxy="5922378b-4d08-4e00-b8da-6a90fe48334d", tocraft=sides.east, toroute=sides.west}, craft={proxy="1453ae97-10ab-46b9-840e-0fb129db6f4a", tohome=sides.south, toroute=sides.west}, route={proxy="a7ac1317-0155-4dd6-818d-eb40f1c7e606", home=sides.west, route=sides.east}},
            food={home={proxy="6d9f66e8-7851-4a4f-bd1a-480dfd5193d3", tocraft=sides.east, toroute=sides.west}, craft={proxy="8c8608e3-c6cc-428f-a4da-36bf3766487c", tohome=sides.south, toroute=sides.west}, route={proxy="390c2dc0-8774-4ac4-a380-ade974fa362d", home=sides.west, route=sides.east}},
            industrial={home={proxy="fc787ccd-cc1f-4475-854c-c7f6012fc560", tocraft=sides.east, toroute=sides.west}, craft={proxy="687873cd-57c7-4c93-bb8f-ca460b5beb13", tohome=sides.south, toroute=sides.west}, route={proxy="0eb9c54e-5121-4dd7-9b50-05b078022154", home=sides.west, route=sides.east}},
            immersive={home={proxy="665db44e-cea5-40de-b060-be640b0d5d27", tocraft=sides.east, toroute=sides.west}, craft={proxy="d1c1787e-26e0-43f9-be85-e73a861f586c", tohome=sides.south, toroute=sides.west}, route={proxy="ad8272d4-eb96-4f6d-9dd5-e3f817e58ada", home=sides.west, route=sides.east}},
            railroad={home={proxy="8dbb6913-40fa-49ae-a353-5f76e2df7ab0", tocraft=sides.east, toroute=sides.west}, craft={proxy="665db44e-cea5-40de-b060-be640b0d5d27", tohome=sides.south, toroute=sides.west}, route={proxy="5a93e3fb-c675-45cc-aa79-75bc60f43d06", home=sides.west, route=sides.east}},
            mekanism={home={proxy="82b77c23-820c-4ee7-b636-4c80be902748", tocraft=sides.west, toroute=sides.east}, craft={proxy="14d66bf4-1df0-4d84-a740-42a042af2f9c", tohome=sides.south, toroute=sides.east}, route={proxy="6ca19159-ccb2-4eee-b509-690fc6599d82", home=sides.east, route=sides.west}},
            minewatch={home={proxy="b240771c-5143-449c-8c6a-bcd1a3a1bad4", tocraft=sides.west, toroute=sides.east}, craft={proxy="e8ee4865-d144-4bf5-af87-fe65833a0832", tohome=sides.south, toroute=sides.east}, route={proxy="69884f44-084f-444c-9676-cb3a87632597", home=sides.east, route=sides.west}},
            more={home={proxy="afa51b94-ebb8-44bb-873e-c8729e9017cb", tocraft=sides.west, toroute=sides.east}, craft={proxy="6efffe7c-d075-4502-b41c-41a1687fcb4a", tohome=sides.south, toroute=sides.east}, route={proxy="5326d3d7-eaea-4b41-a3fc-194209eee4ec", home=sides.east, route=sides.west}},
            mystical={home={proxy="17cfc433-c665-4f2c-846e-1d78516e5ea9", tocraft=sides.west, toroute=sides.east}, craft={proxy="cc1f9a05-3545-4975-8c02-85e03dfd0cc5", tohome=sides.south, toroute=sides.east}, route={proxy="0ba495f9-f8bc-4449-9d8a-d0db387b4661", home=sides.east, route=sides.west}},
            modern={home={proxy="9914e3cc-3d6c-4776-9c6c-b2fb69d5ab43", tocraft=sides.west, toroute=sides.east}, craft={proxy="e2e84ddb-d28a-4fdd-9a5d-11301fc58e6c", tohome=sides.south, toroute=sides.east}, route={proxy="2eaa06bc-37d1-4011-baf6-6207d8c4a424", home=sides.east, route=sides.west}},
            nuclear={home={proxy="aa569122-bddb-4336-8130-3ebc8a8f8cca", tocraft=sides.west, toroute=sides.east}, craft={proxy="1e3f4869-733e-41c9-a1c4-2d144e76cdad", tohome=sides.south, toroute=sides.east}, route={proxy="7185304e-025f-46f2-8d48-73bca57e3087", home=sides.east, route=sides.west}},
            storage={home={proxy="cdf10cdc-8bec-4067-87d1-77a25241b562", tocraft=sides.west, toroute=sides.east}, craft={proxy="d86d42ae-881e-4129-953a-45e1627d484b", tohome=sides.south, toroute=sides.east}, route={proxy="5795e307-1ec9-4f67-8e2d-066db134052c", home=sides.east, route=sides.west}},
            deco={home={proxy="edeb6bf2-71d3-456e-8650-b7dd4abb6add", tocraft=sides.west, toroute=sides.east}, craft={proxy="94bbc979-96b2-4255-98b5-f4bf20c4b1a5", tohome=sides.south, toroute=sides.east}, route={proxy="883bcb8e-0bf4-4dd2-bbd9-6cf9f0ed4500", home=sides.east, route=sides.west}},
            rftools={home={proxy="fc422345-c9b3-4439-8c4c-328e8eca9dc6", tocraft=sides.east, toroute=sides.west}, craft={proxy="f5801229-9e2f-4cc5-ab58-934ccdf93626", tohome=sides.south, toroute=sides.west}, route={proxy="3e60e5b0-6585-4b61-842f-bde8156af13f", home=sides.west, route=sides.east}},
            plants={home={proxy="43873afa-7fdf-4a46-aac2-5fb576347ad1", tocraft=sides.east, toroute=sides.west}, craft={proxy="3aca8f4d-8642-489e-bd20-a72f2d910eff", tohome=sides.south, toroute=sides.west}, route={proxy="e1e562f1-22da-4c55-8cb9-501a0d815aa9", home=sides.west, route=sides.east}},
            tinkers={home={proxy="2ba89af1-335b-462e-9275-42f344c09754", tocraft=sides.east, toroute=sides.west}, craft={proxy="a45ef1ec-9772-4dc1-adc7-69d1a79be96d", tohome=sides.south, toroute=sides.west}, route={proxy="643b7dba-ed74-4072-82cf-c61e7d483310", home=sides.west, route=sides.east}},
            treborn={home={proxy="9178ad40-6310-43d9-9a27-b17e523b0084", tocraft=sides.east, toroute=sides.west}, craft={proxy="b22fe190-55e7-4e0c-a16d-4385f9b9d857", tohome=sides.south, toroute=sides.west}, route={proxy="c1c6f947-d449-465e-86bf-f2b6ff0d80f2", home=sides.west, route=sides.east}},
            terra={home={proxy="ac7bf9e2-ce91-4e82-b3a8-306bd2a37040", tocraft=sides.east, toroute=sides.west}, craft={proxy="bfad12df-bcfe-4d31-ae17-3540754f2e2a", tohome=sides.south, toroute=sides.west}, route={proxy="29e23c53-074d-4c67-8744-8cb423b34502", home=sides.west, route=sides.east}},
            thermal={home={proxy="c10c8835-a475-474a-8fad-97efdd930200", tocraft=sides.east, toroute=sides.west}, craft={proxy="2d45d8a2-1380-45bb-acf1-5fd14eb03d09", tohome=sides.south, toroute=sides.west}, route={proxy="b1816809-124f-4282-9a3d-17dfec69d80d", home=sides.west, route=sides.east}},
            reliq={home={proxy="a780c638-9f44-4122-ae42-fe6c0637e96f", tocraft=sides.east, toroute=sides.west}, craft={proxy="c299a0f8-56bc-4e74-a402-f25b280ba625", tohome=sides.south, toroute=sides.west}, route={proxy="5a0803ca-bcaf-432e-8291-e948d73c9966", home=sides.west, route=sides.east}},
            appen={home={proxy="c058195f-7814-4ba0-89f1-a435e1d7be91", tocraft=sides.east, toroute=sides.west}, craft={proxy="844a6519-af1e-43c9-92f8-a2e2d4e12c21", tohome=sides.south, toroute=sides.west}, route={proxy="c5792f6f-bdc4-4523-a915-9ab5eb4f0992", home=sides.west, route=sides.east}},
            atl={home={proxy="9ee8ee38-99d4-4cf1-b76d-383783f72123", tocraft=sides.west, toroute=sides.east}, craft={proxy="2825dbd8-f86e-4545-a54a-d18ab2232d69", tohome=sides.south, toroute=sides.east}, route={proxy="a565bb66-4aec-4638-8b64-1f506c23065f", home=sides.east, route=sides.west}},
            actadd={home={proxy="a8fb1ca6-150f-40ae-8356-eea203d0eaf4", tocraft=sides.west, toroute=sides.east}, craft={proxy="f0f60fd9-b43b-4ecb-acda-6eaccb32c4cd", tohome=sides.south, toroute=sides.east}, route={proxy="f4c35c14-5e50-41b7-b59a-358c930970f4", home=sides.east, route=sides.west}},
            rocketry={home={proxy="14de66ce-902c-4bcc-ab63-9af53cbf6986", tocraft=sides.west, toroute=sides.east}, craft={proxy="e198237c-04e8-41d6-a79f-3bf669db9d76", tohome=sides.south, toroute=sides.east}, route={proxy="ce5b8de8-19e4-483e-8878-51aaea121734", home=sides.east, route=sides.west}},
            aether={home={proxy="7844c2c5-306f-4005-9e7b-de41e5aa441e", tocraft=sides.west, toroute=sides.east}, craft={proxy="658a48f7-b153-42d7-b296-8952b5ade50f", tohome=sides.south, toroute=sides.east}, route={proxy="6c2e653c-2923-45dd-9116-1a74096d55a8", home=sides.east, route=sides.west}},
            metals={home={proxy="16b760d5-e924-4720-9679-b1e5ad71ad33", tocraft=sides.west, toroute=sides.east}, craft={proxy="f39692d9-ca01-46b2-834c-7439bf32b9b1", tohome=sides.south, toroute=sides.east}, route={proxy="d0e819a0-adfc-42d5-8b6d-7c4f6d4a4eae", home=sides.east, route=sides.west}},
            biblio={home={proxy="8e728e62-e325-4b29-87fb-1a218b85c91b", tocraft=sides.west, toroute=sides.east}, craft={proxy="8e728e62-e325-4b29-87fb-1a218b85c91b", tohome=sides.south, toroute=sides.east}, route={proxy="d7436691-5cd4-4b45-8efa-0a195f1db285", home=sides.east, route=sides.west}},
            btrees={home={proxy="2d989646-6fda-4216-b136-6deecf6fd492", tocraft=sides.west, toroute=sides.east}, craft={proxy="faa0ef96-6561-47aa-94e3-82ecc5fe5166", tohome=sides.south, toroute=sides.east}, route={proxy="bc64d5db-065b-45dd-a0bf-e0ca26f1e9d6", home=sides.east, route=sides.west}},
            binnie={home={proxy="20659e1b-dd53-4b4f-81d2-55bb7def7add", tocraft=sides.west, toroute=sides.east}, craft={proxy="e9b4e46e-9729-48b8-9675-3bedf31bd486", tohome=sides.south, toroute=sides.east}, route={proxy="56767eae-d515-4f5b-9801-9acd3422aff6", home=sides.east, route=sides.west}},
            biomes={home={proxy="0a729d27-869b-4b0d-a63e-160146668828", tocraft=sides.east, toroute=sides.west}, craft={proxy="c477965a-907e-42d3-b5f4-aacf4b135ed8", tohome=sides.south, toroute=sides.west}, route={proxy="5a95035f-f16a-4765-8d51-245aaccd8417", home=sides.west, route=sides.east}},
            botania={home={proxy="f2e0e825-64b3-4293-91b6-96b495fd4058", tocraft=sides.east, toroute=sides.west}, craft={proxy="ae53bb4d-0381-4d73-9f44-95c66545d103", tohome=sides.south, toroute=sides.west}, route={proxy="3a6d5481-3805-49a0-b523-b7247b45f5e7", home=sides.west, route=sides.east}},
            ceramics={home={proxy="85e89a82-7d54-4d3f-b63f-b4d44124b034", tocraft=sides.east, toroute=sides.west}, craft={proxy="7e36894d-8dd5-4fdd-8a58-a55e29a6aad9", tohome=sides.south, toroute=sides.west}, route={proxy="420b9b75-67f2-48a3-899e-7213c5bce4af", home=sides.west, route=sides.east}},
            chisel={home={proxy="4340939f-b5a1-489f-9b9f-5cb3495b9542", tocraft=sides.east, toroute=sides.west}, craft={proxy="3594a948-ec80-494a-94c7-938105facc76", tohome=sides.south, toroute=sides.west}, route={proxy="f5ed4d74-a8a4-49e5-97b8-ed4cb0efe57d", home=sides.west, route=sides.east}},
            bits={home={proxy="1e8f0efc-caf0-4416-bd1f-51a988afcb94", tocraft=sides.east, toroute=sides.west}, craft={proxy="6f1239ce-9ea8-40f8-9ac7-e71349bbbff0", tohome=sides.south, toroute=sides.west}, route={proxy="7a605723-513f-4538-b074-af48bd053380", home=sides.west, route=sides.east}},
            cyclic={home={proxy="0986efb2-16e1-43fa-8e3d-88bb0638cbb9", tocraft=sides.east, toroute=sides.west}, craft={proxy="fefb470d-f3e9-4c16-984d-364598a6a65c", tohome=sides.south, toroute=sides.west}, route={proxy="e5208326-0b26-4016-8fe0-911177372a7e", home=sides.west, route=sides.east}},
            diy={home={proxy="b1021b1c-01d8-4168-a75e-24b0fcfe7e0b", tocraft=sides.east, toroute=sides.west}, craft={proxy="c5cadbfb-ceae-4156-9c04-56a7d2db928d", tohome=sides.south, toroute=sides.west}, route={proxy="3a0fe893-80d5-46ea-b161-20d21a7cff28", home=sides.west, route=sides.east}}
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
local function GetProx(mod, typ)
    local pname = ModToPName(mod)
    --print("Mod: " .. mod .. " pname: " .. pname)
    local proxy = Proxies(pname)
    if (proxy[typ] == nil) then
        --print("proxy not found for typ: " .. typ)
        return nil
    else
        --print("proxy not for typ: " .. typ)
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
local function GetProxyByName(name, typ)
    local p = GetProxByName(name, typ)
    if (p ~= nil) then
        return p.proxy
    else
        return ""
    end
end
local function GetRoute(mod, typ, destinationmod, schalter)
    local typ2 = ""
    if typ == "craft" then
        typ2 = "home"
    elseif typ == "hometohome" then
        typ = "home"
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
