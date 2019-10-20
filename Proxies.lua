local sides = require("sides")
local prox = {}
local function GetProxyByCrafter(name)
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
local function ModToProp(mod, typ)
    local mtpn = {
		actuallyadditions={crafter="actadd", name="Actually Additions"},
		adchimneys={crafter="chimneys", name="Advanced Chimneys"},
		adhooks={crafter="others", name="Advanced Hook Launchers"},
		advancedrocketry={crafter="rocketry", name="Advanced Rocketry"},
		advancedsticks={crafter="chimneys", name="Advanced Sticks"},
		ae2stuff={crafter="appen", name="Applied Energistics 2 Stuff"},
		aether_legacy={crafter="aether", name="Aether Legacy"},
		animania={crafter="aether", name="Animania"},
		animus={crafter="reliq", name="Blood Magic"},
		appliedenergistics2={crafter="appen", name="Applied Energistics 2"},
		aquamunda={crafter="others", name="Aqua Munda"},
		arcticmobs={crafter="cyclic", name="Lycanites Mobs"},
		armorunder={crafter="biomes", name="Tough as Nails"},
		as_extraresources={crafter="chimneys", name="Advanced Sticks"},
		astikorcarts={crafter="others", name="Astikoor"},
		astralsorcery={crafter="reliq", name="Astral Sorcery"},
		atlcraft={crafter="atl", name="ATLCraft"},
		base={crafter="others", name="BASE"},
		basemetals={crafter="metals", name="Base Metals"},
		baubles={crafter="others", name="Baubles"},
		betterquesting={crafter="others", name="Better Questing"},
		bibliocraft={crafter="biblio", name="BiblioCraft"},
		bigreactors={crafter="nuclear", name="Extreme Reactors"},
		binniecore={crafter="btrees", name="Binnie Core"},
		biomesoplenty={crafter="biomes", name="Biomes O' Plenty"},
		blackthorne={crafter="draconic", name="MTS - Stuff"},
		bloodarsenal={crafter="reliq", name="Blood Magic"},
		bloodmagic={crafter="reliq", name="Blood Magic"},
		bloodtinker={crafter="reliq", name="Blood Magic"},
		blueboyscaterpillarmtspack={crafter="draconic", name="MTS - Stuff"},
		botania={crafter="botania", name="Botania"},
		botanicadds={crafter="botania", name="Botania"},
		botany={crafter="binnie", name="Binnie Botany"},
		bq_standard={crafter="others", name="Better Questing"},
		buildcraftbuilders={crafter="rocketry", name="Buildcraft"},
		buildcraftcompat={crafter="rocketry", name="Buildcraft"},
		buildcraftcore={crafter="rocketry", name="Buildcraft"},
		buildcraftenergy={crafter="rocketry", name="Buildcraft"},
		buildcraftfactory={crafter="rocketry", name="Buildcraft"},
		buildcraftlib={crafter="rocketry", name="Buildcraft"},
		buildcraftrobotics={crafter="rocketry", name="Buildcraft"},
		buildcraftsilicon={crafter="rocketry", name="Buildcraft"},
		buildcrafttransport={crafter="rocketry", name="Buildcraft"},
		buildinggadgets={crafter="others", name="Building Gadgets"},
		car={crafter="draconic", name="Car Mod"},
		carryon={crafter="others", name="Carry On"},
		carz={crafter="others", name="Carz"},
		cd4017be_lib={crafter="others", name="CD4017BE Lib"},
		cdm={crafter="draconic", name="MrCrayfish's Device Mod"},
		ceramics={crafter="ceramics", name="Ceramics"},
		cfm={crafter="draconic", name="MrCrayfish's Furniture Mod"},
		chickenchunks={crafter="others", name="Chicken Chunks"},
		chisel={crafter="others", name="Chisel"},
		chiselsandbits={crafter="others", name="Chisels & Bits"},
		circuits={crafter="others", name="Automated Redstone"},
		colossalchests={crafter="others", name="Colossal Chests"},
		compactmachines3={crafter="others", name="Compact Machines"},
		conarm={crafter="tinkers", name="Tinkers Constructs Armory"},
		conquest={crafter="conquest", name="Conquest Reforged"},
		cookingforblockheads={crafter="others", name="Cooking for Blockheads"},
		corail_pillar={crafter="pillar", name="Corail Pillar"},
		corail_pillar_extension_biomesoplenty={crafter="pillar", name="Corail Pillar"},
		corail_pillar_extension_chisel={crafter="pillar", name="Corail Pillar"},
		corail_pillar_extension_forestry={crafter="pillar", name="Corail Pillar"},
		corail_pillar_extension_quark={crafter="pillar", name="Corail Pillar"},
		coralreef={crafter="others", name="Coralreef"},
		customnpcs={crafter="others", name="Custom NPCs"},
		cyclicmagic={crafter="cyclic", name="Cyclic"},
		danknull={crafter="others", name="DankNull"},
		darkutils={crafter="utilities", name="Dark Utilities"},
		davincisvessels={crafter="others", name="Davincis Vessels"},
		ddb={crafter="others", name="Do it Yourself"},
		deepresonance={crafter="others", name="Deep Resonance"},
		defiledlands={crafter="utilities", name="Defiled Lands"},
		demonmobs={crafter="cyclic", name="Lycanites Mobs"},
		desertmobs={crafter="cyclic", name="Lycanites Mobs"},
		draconicadditions={crafter="draconic", name="Draconic Evolution"},
		draconicevolution={crafter="draconic", name="Draconic Evolution"},
		electrostatics={crafter="others", name="Electrostatics"},
		elementalmobs={crafter="cyclic", name="Lycanites Mobs"},
		elevatorid={crafter="others", name="Elevator Mod"},
		enderio={crafter="environ", name="Ender IO"},
		energyconverters={crafter="others", name="Energy Converters"},
		environmentalmaterials={crafter="environ", name="Environmental Tech"},
		environmentaltech={crafter="environ", name="Environmental Tech"},
		etlunar={crafter="environ", name="Environmental Tech"},
		extrabees={crafter="binnie", name="Binnie Bees"},
		extrabitmanipulation={crafter="others", name="Extra Bit Manipulation"},
		extratrees={crafter="btrees", name="Binnie Trees"},
		extrautils2={crafter="utilities", name="Extra Utilities 2"},
		fairylights={crafter="fairy", name="Fairy Lights"},
		farmory={crafter="fiifex", name="Forge Your World"},
		fcl={crafter="fiifex", name="Fexcraft"},
		fdecostuff={crafter="fiifex", name="Forge Your World"},
		ffactory={crafter="fiifex", name="Forge Your World"},
		ffoods={crafter="fiifex", name="Forge Your World"},
		flatcoloredblocks={crafter="flat", name="Flat Colored Blocks"},
		floricraft={crafter="fairy", name="Floricraft"},
		fmagic={crafter="fiifex", name="Forge Your World"},
		forestmobs={crafter="cyclic", name="Lycanites Mobs"},
		forestry={crafter="forestry", name="Forestry"},
		forge={crafter="minecraft", name="Minecraft"},
		fp={crafter="future", name="Futurepack"},
		fpfa={crafter="future", name="Futurepack"},
		freshwatermobs={crafter="cyclic", name="Lycanites Mobs"},
		fresource={crafter="fiifex", name="Forge Your World"},
		frsm={crafter="fiifex", name="Fexcraft"},
		funkylocomotion={crafter="others", name="Funky Locomotion"},
		fvtm={crafter="fiifex", name="Fexcraft"},
		gemmary={crafter="others", name="Gemmary"},
		gendustry={crafter="binnie", name="Gendustry"},
		genetics={crafter="binnie", name="Binnie Genetics"},
		gravestone={crafter="others", name="Gravestone"},
		gravestone_qq_extended={crafter="others", name="Gravestone"},
		gravitygun={crafter="others", name="Gravity Gun"},
		guideapi={crafter="others", name="Guide API"},
		hammercore={crafter="others", name="HammerCore"},
		harvestcraft={crafter="food", name="Pam's HarvestCraft"},
		ic2={crafter="industrial", name="IndustrialCraft 2"},
		ichunutil={crafter="others", name="iChunUtil"},
		immcraft={crafter="immersive", name="Immersive Engineering"},
		immersiveengineering={crafter="immersive", name="Immersive Engineering"},
		immersivehempcraft={crafter="immersive", name="Immersive HempCraft"},
		immersivepetroleum={crafter="immersive", name="Immersive Petroleum"},
		immersiverailroading={crafter="railroading", name="Immersive Railroading"},
		immersivetech={crafter="immersive", name="Immersive Engineering"},
		industrialforegoing={crafter="fiifex", name="Industrial Foregoing"},
		industrialwires={crafter="immersive", name="Industrial Wires"},
		infernomobs={crafter="cyclic", name="Lycanites Mobs"},
		infinitycraft={crafter="fiifex", name="InfinityCraft"},
		integrateddynamics={crafter="appen", name="Integrated Dynamics"},
		integratedtunnels={crafter="appen", name="Integrated Tunnels"},
		itorch={crafter="others", name="iTorch"},
		junglemobs={crafter="cyclic", name="Lycanites Mobs"},
		libvulpes={crafter="rocketry", name="Vulpes library"},
		lost_aether={crafter="aether", name="Aether Legacy"},
		lycanitesmobs={crafter="cyclic", name="Lycanites Mobs"},
		magicbees={crafter="binnie", name="MagicBees"},
		malisisadvert={crafter="others", name="Malisis Mods"},
		malisisblocks={crafter="others", name="Malisis Mods"},
		malisisdoors={crafter="others", name="Malisis Mods"},
		malisisswitches={crafter="others", name="Malisis Mods"},
		mekanism={crafter="mekanism", name="Mekanism"},
		mekanismgenerators={crafter="mekanism", name="Mekanism"},
		mekanismtools={crafter="mekanism", name="Mekanism"},
		microblockcbe={crafter="others", name="Microblocks"},
		minecolonies={crafter="aether", name="MineColonies"},
		minecraft={crafter="minecraft", name="Minecraft"},
		minewatch={crafter="minewatch", name="Minewatch"},
		mmdlib={crafter="metals", name="MMD Lib"},
		mmmpack={crafter="draconic", name="MTS - Stuff"},
		moarboats={crafter="others", name="Moar Boats"},
		moarfood={crafter="food", name="MoarFood"},
		modcurrency={crafter="others", name="Good Old Currency"},
		modernmetals={crafter="modern", name="Modern Metals"},
		morebeautifulbuttons={crafter="more", name="More Beautiful Buttons"},
		morebeautifulplates={crafter="more", name="More Beautiful Plates"},
		mores={crafter="minewatch", name="Mores"},
		mountainmobs={crafter="cyclic", name="Lycanites Mobs"},
		mts={crafter="draconic", name="MTS"},
		mtsheavyindustrialbyadamrk={crafter="draconic", name="MTS - Stuff"},
		mtsofficialpack={crafter="draconic", name="MTS - Stuff"},
		mtsseagullcivilpack={crafter="draconic", name="MTS - Stuff"},
		mtsseagullmilitarypack={crafter="draconic", name="MTS - Stuff"},
		mtsseagulltrinpartpack={crafter="draconic", name="MTS - Stuff"},
		mxtune={crafter="others", name="MXTune"},
		mysticalagradditions={crafter="mystical", name="Mystical Agriculture"},
		mysticalagriculture={crafter="mystical", name="Mystical Agriculture"},
		nethermetals={crafter="others", name="Nether Metals"},
		nuclearcraft={crafter="nuclear", name="NuclearCraft"},
		ocdevices={crafter="storage", name="Open Computers"},
		ocsensors={crafter="storage", name="Open Computers"},
		opencomputers={crafter="storage", name="Open Computers"},
		openglider={crafter="others", name="Open Glider"},
		patchouli={crafter="others", name="Patchouli"},
		persistentbits={crafter="others", name="Persistent Bits"},
		personalcars={crafter="draconic", name="Personal Cars"},
		placeableitems={crafter="others", name="Placeable Items Mod"},
		plainsmobs={crafter="cyclic", name="Lycanites Mobs"},
		plants2={crafter="plants", name="Plants"},
		platforms={crafter="others", name="Platforms"},
		plustic={crafter="tinkers", name="Plustic"},
		pneumaticcraft={crafter="ceramics", name="Pneumatic Craft"},
		props={crafter="others", name="Decocraft"},
		psi={crafter="others", name="PSI"},
		quantumstorage={crafter="storage", name="Quantum Storage"},
		questbook={crafter="others", name="Better Questing"},
		rafradek_tf2_weapons={crafter="minewatch", name="TF2 Stuff Mod"},
		railstuff={crafter="railroading", name="Immersive Railroading"},
		randomthings={crafter="biomes", name="Random Things"},
		rangedpumps={crafter="others", name="Ranged Pumps"},
		rebornstorage={crafter="storage", name="Reborn Storage"},
		redstonearsenal={crafter="others", name="Redstone Arsenal"},
		redstonepaste={crafter="others", name="Redstone Paste"},
		refinedstorage={crafter="storage", name="Refined Storage"},
		rftools={crafter="rftools", name="RFTools"},
		rftoolscontrol={crafter="rftools", name="RFTools Control"},
		rftoolsdim={crafter="rftools", name="RFTools Dimensions"},
		runecraft={crafter="others", name="RuneCraft"},
		rustic={crafter="plants", name="Rustic"},
		saltmod={crafter="others", name="Salt Mod"},
		saltwatermobs={crafter="cyclic", name="Lycanites Mobs"},
		sereneseasons={crafter="biomes", name="Serene Seasons"},
		shadowmobs={crafter="cyclic", name="Lycanites Mobs"},
		signpost={crafter="others", name="Sign Post"},
		simpledimensions={crafter="others", name="Simple Dimensions"},
		simplytea={crafter="others", name="Simply Tea"},
		steamworld={crafter="others", name="SteamWorld"},
		structurize={crafter="aether", name="Structurize"},
		swampmobs={crafter="cyclic", name="Lycanites Mobs"},
		taiga={crafter="tinkers", name="Tinkers Alloy Addon"},
		tanaddons={crafter="biomes", name="Tough as Nails"},
		tcomplement={crafter="tinkers", name="Tinkers Constructs Complement"},
		tconstruct={crafter="tinkers", name="Tinkers Construct"},
		techreborn={crafter="treborn", name="Tech Reborn"},
		terraqueous={crafter="terra", name="Terraqueous"},
		teslacorelib={crafter="terra", name="Tesla"},
		teslathingies={crafter="terra", name="Tesla"},
		thaumcomp={crafter="biblio", name="ThaumCraft"},
		thaumcraft={crafter="biblio", name="ThaumCraft"},
		theoneprobe={crafter="others", name="The One Probe"},
		thermalcultivation={crafter="thermal", name="Thermal Cultivation"},
		thermaldynamics={crafter="thermal", name="Thermal Dynamics"},
		thermalexpansion={crafter="thermal", name="Thermal Expansion"},
		thermalfoundation={crafter="thermal", name="Thermal Foundation"},
		torcharrowsmod={crafter="others", name="TorchArrow"},
		toughasnails={crafter="biomes", name="Tough as Nails"},
		twilightforest={crafter="plants", name="Twilight Forrest"},
		uniquecrops={crafter="plants", name="Unique Crops"},
		unlimitedchiselworks={crafter="chisel", name="Unlimited Chisel Works"},
		unuparts={crafter="draconic", name="MTS - Stuff"},
		valkyrielib={crafter="others", name="Valkyrie Lib"},
		vehicle={crafter="draconic", name="MrCrayfish's - Vehicles"},
		vc={crafter="draconic", name="ViesCraft"},
		xnet={crafter="others", name="XNet"},
		xreliquary={crafter="reliq", name="Reliquary"},
		zerocore={crafter="others", name="Zero CORE"},
	}
    return mtpn[mod][typ]
end
local function ModCrafter(mod)
	return ModToProp(mod, "crafter")
end
local function ModName(mod)
	return ModToProp(mod, "name")
end
local function GetProxyByMod(mod)
    return GetProxyByCrafter(ModCrafter(mod))
end

prox.GetProxyByMod = GetProxyByMod
prox.GetProxyByCrafter = GetProxyByCrafter
prox.ModCrafter = ModCrafter
prox.ModName = ModName
return prox
