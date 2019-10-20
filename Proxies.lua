local sides = require("sides")
local prox = {}
local function Proxies(name)
    local pr = {
        minecraft = "5e641952-57b9-4d2c-bdc4-84c3169c9003",
		draconic = "d24e6b8e-ff7b-44ea-89b4-86a73b6b9625",
		conquest = "a40d3a48-9744-4d54-99d3-87c76fd4ba93",
		mekanism = "d2d897c3-e2a9-4fdf-a577-fe3b0dfae27a",
		utilities = "b9284235-0046-435d-a7eb-fd1f5b2c6bad",
		environ = "0d93120a-568c-4112-a1dd-255ab5e26684",
		storage = "dfb57f87-bd70-4562-9ec1-22156a464a96",
		nuclear = "b333b242-2daa-459c-84b0-c0f9b0b0bbe9",
		forestry = "cae64dcb-1234-4952-aee0-21972148db72",
		food = "8fc3a825-7e28-4837-90e1-4d4c81509270",
		immersive = "1cc5a8a0-26da-4edd-995a-866bc95c184f",
		railroad = "52a18662-2e76-44a7-a999-7debbbf74084",
		others = "cd1ea590-5105-4d81-abe2-9864207eae4d",
		fiifex = "1fd5006c-a302-4943-bb41-637eb00ed542",
		thermal = "d59fa1d2-8dda-4dba-89c1-45a0fdb89127",
		industrial = "edaa9125-0d0b-422a-bf67-54e9035d8d6c",
		treborn = "2a7e3cfc-9b8e-48b2-a28e-9150a69796fc",
		rftools = "8504ecf4-9fea-40c2-86c5-9f6480be785b",
		metals = "bb206f2e-c8c6-4c84-9597-4e8c1f1e5b50",
		modern = "01aa486d-7160-4fd9-8eb4-9a4b01e673c7",
		actadd = "b9e56557-ffc7-42d3-bf8e-395c365ee1d0",
		rocketry = "5c87e4c8-8126-40c0-a831-4f55d54d310c",
		biomes = "947d640f-de6a-4393-a204-9e68acc67885",
		botania = "cdbb54c8-bc48-4094-a773-a69192013e62",
		mystical = "9264e574-ff05-4e98-bfc8-c350ee107460",
		biblio = "c0487111-c1ff-44b6-815c-b22ec4b10f4a",
		fairy = "ab4d7c15-3ac1-435a-8432-148cd3ecbb6c",
		reliq = "65deff17-f43f-481f-b041-f958166f6ef8",
		terra = "fcfc1925-82ce-40fc-b99c-97b5329df2a5",
		appen = "8f381a1f-917a-4a9f-bc11-97261ac971b5",
		btrees = "169a4831-fdca-4ee7-91a2-a9a7066a7f31",
		binnie = "b14d7bfd-db09-455a-8189-f3a81715475f",
		aether = "da00087f-d650-43cb-8880-8cf022f230b6",
		plants = "963ccc48-7c46-45b8-9c5b-7a32b8f64352",
		cyclic = "a2dfecff-b3a4-4bd7-b4d9-068e72ac2185",
		tinkers = "92e2ce05-416d-4e6f-961a-0100e523a272",
		ceramics = "5f79d96a-06f5-4d59-813e-0ea958ea338a",
		atl = "9c86c94a-84c5-4a3a-9876-8bd9e0ddaa3a",
		deco = "d9db7a98-b5b2-4b78-b93a-0fdf7b6583c6",
		chisel = "033a0f4a-b1ab-4c80-a76f-5a592459c926",
		bits = "0e62359f-929d-4b17-b2bb-d1b64a23f7e3",
		flat = "bef99875-4b87-4874-8deb-7b18577c66a2",
		pillar = "14550cb5-4cdb-45ba-b91e-2608e243ae67",
		more = "a08ae5fc-c0ad-4598-9a6c-f4a2b74d0128",
		chimneys = "df0daf1b-f852-4639-b203-95a496ca7f1f",
		minewatch = "e0184266-3df9-4b63-b052-830060a9b8a3",
		future = "22997dcf-62d9-43a1-a8f7-c5a1b59b5b71",
		itemsort = "ae451f31-8a79-4ca0-8b40-9a534ba94511",
		fluid = "56338f1c-21de-4400-aa0e-8696db0a9c7e"
	}
    return pr[name]
end
local function ModToCrafter(mod)
    local mtpn = {
       actuallyadditions="actadd",
       adchimneys="chimneys",
       adhooks="others",
       advancedrocketry="rocketry",
       ae2stuff="appen",
       aether_legacy="aether",
       animania="aether",
       appliedenergistics2="appen",
       aquamunda="others",
       arcticmobs="cyclic",
       as_extraresources="chimneys",
       astikoor="others",
       atlcraft="atl",
       basemetals="metals",
       baubles="others",
       betterquesting="others",
       bibliocraft="biblio",
       bigreactors="nuclear",
       binniecore="btrees",
       biomesoplenty="biomes",
       blackthorne="draconic",
       blueboyscaterpillarmtspack="draconic",
       botania="botania",
       botany="binnie",
       bq_standard="others",
       buildcraftbuilders="rocketry",
       buildcraftcore="rocketry",
       buildcraftenergy="rocketry",
       buildcraftfactory="rocketry",
       buildcraftlib="rocketry",
       buildcraftrobotics="rocketry",
       buildcraftsilicon="rocketry",
       buildcrafttransport="rocketry",
       car="draconic",
       carryon="others",
       carz="others",
       cdm="draconic",
       ceramics="ceramics",
       cfm="draconic",
       chisel="chisel",
       chiselsandbits="others",
       compactmachines3="others",
       conquest="conquest",
       cookingforblockheads="others",
       corail_pillar="pillar",
       corail_pillar_extension_biomesoplenty="pillar",
       corail_pillar_extension_chisel="pillar",
       corail_pillar_extension_forestry="pillar",
       coralreef="others",
       customnpcs="others",
       cyclicmagic="cyclic",
       darkutils="utilities",
       davincisvessels="others",
       ddb="others",
       deepresonance="others",
       defiledlands="utilities",
       demonmobs="cyclic",
       desertmobs="cyclic",
       draconicevolution="draconic",
       electrostatics="others",
       elementalmobs="cyclic",
       energyconverters="others",
       environmentalmaterials="environ",
       environmentaltech="environ",
       etlunar="environ",
       extrabees="binnie",
       extrabitmanipulation="others",
       extratrees="btrees",
       extrautils2="utilities",
       fairylights="fairy",
       farmory="fiifex",
       fcl="fiifex",
       fdecostuff="fiifex",
       ffoods="fiifex",
       flatcoloredblocks="flat",
       floricraft="fairy",
       fmagic="fiifex",
       forestmobs="cyclic",
       forestry="forestry",
       forge="minecraft",
       fp="future",
       fpfa="future",
       freshwatermobs="cyclic",
       fresource="fiifex",
       frsm="fiifex",
       fvtm="fiifex",
       gemmary="others",
       gendustry="binnie",
       genetics="binnie",
       gravestone="others",
       gravitygun="others",
       harvestcraft="food",
       ic2="industrial",
       ichunutil="others",
       immcraft="immersive",
       immersiveengineering="immersive",
       immersivehempcraft="immersive",
       immersiverailroading="railroading",
       immersivetech="immersive",
       industrialforegoing="fiifex",
       infernomobs="cyclic",
       infinitycraft="fiifex",
       itorch="others",
       junglemobs="cyclic",
       libvulpes="rocketry",
       lycanitesmobs="cyclic",
       magicbees="binnie",
       malisisadvert="others",
       malisisblocks="others",
       malisisdoors="others",
       malisisswitches="others",
       mekanism="mekanism",
       mekanismgenerators="mekanism",
       mekanismtools="mekanism",
       minecraft="minecraft",
       minewatch="minewatch",
       mmmpack="draconic",
       moarfood="food",
       modcurrency="others",
       modernmetals="modern",
       morebeautifulbuttons="more",
       morebeautifulplates="more",
       mores="minewatch",
       mountainmobs="cyclic",
       mts="draconic",
       mtsheavyindustrialbyadamrk="draconic",
       mtsofficialpack="draconic",
       mtsseagullcivilpack="draconic",
       mtsseagullmilitarypack="draconic",
       mxtune="others",
       mysticalagradditions="mystical",
       mysticalagriculture="mystical",
       nethermetals="others",
       nuclearcraft="nuclear",
       ocsensors="storage",
       opencomputers="storage",
       openglider="others",
       persistentbits="others",
       personalcars="draconic",
       placeableitems="others",
       plainsmobs="cyclic",
       plants2="plants",
       platforms="others",
       props="others",
       psi="others",
       quantumstorage="storage",
       questbook="others",
       rafradek_tf2_weapons="minewatch",
       rangedpumps="others",
       rebornstorage="storage",
       redstonearsenal="others",
       redstonepaste="others",
       refinedstorage="storage",
       rftools="rftools",
       rftoolscontrol="rftools",
       rftoolsdim="rftools",
       runecraft="others",
       rustic="plants",
       saltmod="others",
       saltwatermobs="cyclic",
       shadowmobs="cyclic",
       signpost="others",
       simpledimensions="others",
       simplytea="others",
       steamworld="others",
       swampmobs="cyclic",
       tconstruct="tinkers",
       techreborn="treborn",
       terraqueous="terra",
       teslacorelib="terra",
       teslathingies="terra",
       theoneprobe="others",
       thermalcultivation="thermal",
       thermaldynamics="thermal",
       thermalexpansion="thermal",
       thermalfoundation="thermal",
       torcharrowsmod="others",
       twilightforest="plants",
       uniquecrops="plants",
       unlimitedchiselworks="chisel",
       unuparts="draconic",
       vc="draconic",
       xnet="others",
       xreliquary="reliq",
       zerocore="others"
    }
    return mtpn[mod]
end
local function GetProx(mod, typ)
    local pname = ModToCrafter(mod)
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
    elseif typ == "crafttocraft" then
        typ = "craft"
        typ2 = "craft"
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
        return {{proxy = pro.proxy, side=pro.toroute}, {proxy = ro.proxy, side=ro[typ]}}
    end
end
prox.GetRoute = GetRoute
prox.GetProx = GetProx
prox.GetProxy = GetProxy
prox.GetProxByName = GetProxByName
prox.GetProxyByName = GetProxyByName
prox.ModToCrafter = ModToCrafter
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
