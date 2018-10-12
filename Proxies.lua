local sides = require("sides")
local p = {}
local function Proxies()
	return {
		actuallycomputers = {home={proxy="a", tocraft=sides.west, toroute=sides.east}, craft={proxy="0", tohome=sides.west, toroute=sides.east}},
		adchimneys = {home={proxy="b", tocraft=sides.east, toroute=sides.north}, craft={proxy="1", tohome=sides.east, toroute=sides.north}},
		aperture = {home={proxy="c", tocraft=sides.north, toroute=sides.west}, craft={proxy="2", tohome=sides.north, toroute=sides.west}},
		arcticmobs = {home={proxy="d", tocraft=sides.west, toroute=sides.east}, craft={proxy="3", tohome=sides.west, toroute=sides.east}}
	}
end
local function RouteSystem()
	return {
		actuallycomputers = {proxy="a", home=sides.west, craft=sides.east},
		adchimneys = {proxy="b", home=sides.east, craft=sides.north},
		aperture = {proxy="c", home=sides.north, craft=sides.west},
		arcticmobs = {proxy="d", home=sides.west, craft=sides.east}
	}
end
local function GetRoute(mod, typ, destinationmod)
	local typ2 = ""
	if(typ == "craft")then
		typ2 = "home"
	else
		typ2 = "craft"
	end 
	local proxies = Proxies()
	local routesystem = RouteSystem
	if((mod == destinationmod) or (destinationmod == nil))then
		return {{proxy = proxies[mod][typ2].proxy, side=proxies[mod][typ2][("to" .. typ)]}}
	else
		return {{proxy = proxies[mod][typ2].proxy, side=proxies[mod][typ2].toroute}, {proxy = routesystem[destinationmod].proxy, side=routesystem[destinationmod][typ]}}
	end
end
local function GetProxy(mod, typ)
	if(mod == "routing")then
		return ""
	else
		return Proxies()[mod][typ].proxy
	end
end

p.GetRoute = GetRoute
p.GetProxy = GetProxy
return p

		Mod-IngameName	HOME							CRAFT								Mod-Name	Mod-Version			
					Proxy		Side to Craft		Side to Route		Proxy		Side to Home		Side to Route							
																						
local function Proxies()
|	return {																					
|	|	actuallycomputers	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	0	", tohome=sides.		, toroute=sides.		}},		ActuallyComputers	02.01.2000			
|	|	adchimneys	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	1	", tohome=sides.		, toroute=sides.		}},		Advanced Chimneys	1.12.1-3.2.1.0			
|	|	aperture	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	2	", tohome=sides.		, toroute=sides.		}},		Aperture	01. Jan			
|	|	arcticmobs	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	3	", tohome=sides.		, toroute=sides.		}},		Lycanites Arctic Mobs	1.20.3.0			
|	|	as_extraresources	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	4	", tohome=sides.		, toroute=sides.		}},		ï¿½9AS: ï¿½6Extra Resources Add-on	1.0.7			
|	|	autoreglib	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	5	", tohome=sides.		, toroute=sides.		}},		AutoRegLib	01.03.2015			
|	|	baubles	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	6	", tohome=sides.		, toroute=sides.		}},		Baubles	01.05.2002			
|	|	bdlib	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	7	", tohome=sides.		, toroute=sides.		}},		BD Lib	1.14.3.11			
|	|	bigreactors	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	8	", tohome=sides.		, toroute=sides.		}},		Extreme Reactors	1.12.2-0.4.5.45			
|	|	biomebundle	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	9	", tohome=sides.		, toroute=sides.		}},		Biome Bundle	05. Jan			
|	|	blockpalette	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	10	", tohome=sides.		, toroute=sides.		}},		BlockPalette	01.05.2000			
|	|	bookshelf	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	11	", tohome=sides.		, toroute=sides.		}},		Bookshelf	2.3.552			
|	|	bq_standard	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	12	", tohome=sides.		, toroute=sides.		}},		Standard Expansion	2.4.134			
|	|	brandonscore	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	13	", tohome=sides.		, toroute=sides.		}},		Brandon's Core	02.04.2000			
|	|	bushmastercore	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	14	", tohome=sides.		, toroute=sides.		}},		Bush Master Core	1.0.2			
|	|	car	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	15	", tohome=sides.		, toroute=sides.		}},		Car Mod	01.02.2010			
|	|	carryon	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	16	", tohome=sides.		, toroute=sides.		}},		Carry On	01. Jul			
|	|	carz	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	17	", tohome=sides.		, toroute=sides.		}},		Carz	Proof of Concept 2.1 (BTM Version)			
|	|	cdm	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	18	", tohome=sides.		, toroute=sides.		}},		MrCrayfish's Device Mod	0.2.0-pre6			
|	|	ceramics	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	19	", tohome=sides.		, toroute=sides.		}},		Ceramics	1.12-1.3.3b			
|	|	cfm	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	20	", tohome=sides.		, toroute=sides.		}},		MrCrayfish's Furniture Mod	04.01.2005			
|	|	chisel	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	21	", tohome=sides.		, toroute=sides.		}},		Chisel	MC1.12.2-0.2.0.31			
|	|	chiselsandbits	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	22	", tohome=sides.		, toroute=sides.		}},		Chisels & Bits	14.23			
|	|	chunkpregenerator	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	23	", tohome=sides.		, toroute=sides.		}},		Chunk Pregenerator	01.06.2001			
|	|	codechickenlib	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	24	", tohome=sides.		, toroute=sides.		}},		CodeChicken Lib	3.1.5.331			
|	|	cofhcore	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	25	", tohome=sides.		, toroute=sides.		}},		CoFH Core	04.03.2009			
|	|	cofhworld	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	26	", tohome=sides.		, toroute=sides.		}},		CoFH World	01.01.2001			
|	|	compactmachines3	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	28	", tohome=sides.		, toroute=sides.		}},		Compact Machines 3	3.0.12			
|	|	compot	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	29	", tohome=sides.		, toroute=sides.		}},		Combined Potions	01. Jan			
|	|	connect	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	30	", tohome=sides.		, toroute=sides.		}},		Connect	1.0.3-mc1.12.2-SNAPSHOT			
|	|	conquest	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	31	", tohome=sides.		, toroute=sides.		}},		Conquest Reforged	3.0.2			
|	|	cookingforblockheads	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	32	", tohome=sides.		, toroute=sides.		}},		Cooking for Blockheads	06.03.2017			
|	|	corail_pillar	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	33	", tohome=sides.		, toroute=sides.		}},		Corail Pillar	4.0.0			
|	|	corail_pillar_extension_biomesoplenty	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	34	", tohome=sides.		, toroute=sides.		}},		Corail Pillar	Biomes O'Plenty Extension			
|	|	corail_pillar_extension_chisel	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	35	", tohome=sides.		, toroute=sides.		}},		Corail Pillar	Chisel Extension			
|	|	corail_pillar_extension_forestry	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	36	", tohome=sides.		, toroute=sides.		}},		Corail Pillar	Forestry Extension			
|	|	coralreef	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	37	", tohome=sides.		, toroute=sides.		}},		Coralreef	2.0			
|	|	craftstudioapi	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	38	", tohome=sides.		, toroute=sides.		}},		CraftStudio API	1.0.0			
|	|	crafttweaker	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	39	", tohome=sides.		, toroute=sides.		}},		CraftTweaker2	04.01.2009			
|	|	crafttweakerjei	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	40	", tohome=sides.		, toroute=sides.		}},		CraftTweaker JEI Support	2.0.2			
|	|	ctgui	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	41	", tohome=sides.		, toroute=sides.		}},		CT-GUI	1.0.0			
|	|	ctm	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	42	", tohome=sides.		, toroute=sides.		}},		CTM	MC1.12-0.2.3.9			
|	|	cucumber	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	43	", tohome=sides.		, toroute=sides.		}},		Cucumber	1.0.3			
|	|	customnpcs	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	44	", tohome=sides.		, toroute=sides.		}},		CustomNPCs	01. Dez			
|	|	cyclicmagic	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	45	", tohome=sides.		, toroute=sides.		}},		Cyclic	01.10.2010			
|	|	darkutils	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	46	", tohome=sides.		, toroute=sides.		}},		Dark Utilities	1.8.207			
|	|	davincisvessels	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	47	", tohome=sides.		, toroute=sides.		}},		Davinci's Vessels	@DVESSELSVER@			
|	|	ddb	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	48	", tohome=sides.		, toroute=sides.		}},		DIY Decorative Blocks	${version}			
|	|	deepresonance	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	49	", tohome=sides.		, toroute=sides.		}},		DeepResonance	01.06.2000			
|	|	defiledlands	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	50	", tohome=sides.		, toroute=sides.		}},		Defiled Lands	01.02.2000			
|	|	demonmobs	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	51	", tohome=sides.		, toroute=sides.		}},		Lycanites Demon Mobs	1.20.3.0			
|	|	desertmobs	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	52	", tohome=sides.		, toroute=sides.		}},		Lycanites Desert Mobs	1.20.3.0			
|	|	draconicevolution	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	53	", tohome=sides.		, toroute=sides.		}},		Draconic Evolution	02.03.2010			
|	|	dynamiclights	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	54	", tohome=sides.		, toroute=sides.		}},		Dynamic Lights	01.04.2006			
|	|	dynamiclights_creepers	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	55	", tohome=sides.		, toroute=sides.		}},		Dynamic Lights on Creepers	1.0.6			
|	|	dynamiclights_dropitems	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	56	", tohome=sides.		, toroute=sides.		}},		Dynamic Lights on ItemEntities	01.01.2000			
|	|	dynamiclights_entityclasses	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	57	", tohome=sides.		, toroute=sides.		}},		Dynamic Lights on specified Entities	1.0.1			
|	|	dynamiclights_flamearrows	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	58	", tohome=sides.		, toroute=sides.		}},		Dynamic Lights on Flame enchanted Arrows	1.0.1			
|	|	dynamiclights_floodlights	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	59	", tohome=sides.		, toroute=sides.		}},		Dynamic Lights Flood Light	1.0.3			
|	|	dynamiclights_mobequipment	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	60	", tohome=sides.		, toroute=sides.		}},		Dynamic Lights on Mob Equipment	01.01.2000			
|	|	dynamiclights_onfire	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	61	", tohome=sides.		, toroute=sides.		}},		Dynamic Lights on burning	1.0.7			
|	|	dynamiclights_otherplayers	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	62	", tohome=sides.		, toroute=sides.		}},		Dynamic Lights Other Player Light	1.0.9			
|	|	dynamiclights_theplayer	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	63	", tohome=sides.		, toroute=sides.		}},		Dynamic Lights Player Light	01.01.2003			
|	|	eleccore	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	64	", tohome=sides.		, toroute=sides.		}},		ElecCore	1.8.434			
|	|	electrostatics	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	65	", tohome=sides.		, toroute=sides.		}},		Electrostatics	1.0.0			
|	|	elementalmobs	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	66	", tohome=sides.		, toroute=sides.		}},		Lycanites Elemental Mobs	1.20.3.0			
|	|	energyconverters	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	67	", tohome=sides.		, toroute=sides.		}},		Energy Converters	1.0.1.2			
|	|	environmentalmaterials	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	68	", tohome=sides.		, toroute=sides.		}},		Environmental Materials	@EM_VERSION@			
|	|	environmentaltech	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	69	", tohome=sides.		, toroute=sides.		}},		Environmental Tech	1.12.2-2.0.8a			
|	|	etlunar	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	70	", tohome=sides.		, toroute=sides.		}},		ET Lunar	1.12.2-2.0.8a			
|	|	extrabitmanipulation	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	71	", tohome=sides.		, toroute=sides.		}},		Extra Bit Manipulation	1.12-3.2.1			
|	|	extrautils2	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	72	", tohome=sides.		, toroute=sides.		}},		Extra Utilities 2	1.0			
|	|	fairylights	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	73	", tohome=sides.		, toroute=sides.		}},		Fairy Lights	02.01.2002			
|	|	farmory	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	74	", tohome=sides.		, toroute=sides.		}},		Forge Your World Armory	01.03.2001			
|	|	fcl	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	75	", tohome=sides.		, toroute=sides.		}},		Fexcraft Common Library	XII.40			
|	|	fdecostuff	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	76	", tohome=sides.		, toroute=sides.		}},		Forge Your World Decoration And Stuff	01.03.2001			
|	|	ffactory	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	77	", tohome=sides.		, toroute=sides.		}},		Forge Your World Factory	01.03.2001			
|	|	ffoods	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	78	", tohome=sides.		, toroute=sides.		}},		Forge Your World Foods	01.03.2001			
|	|	flatcoloredblocks	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	79	", tohome=sides.		, toroute=sides.		}},		Flat Colored Blocks	mc1.12-6.6			
|	|	floricraft	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	80	", tohome=sides.		, toroute=sides.		}},		Floricraft	04.04.2001			
|	|	fmagic	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	81	", tohome=sides.		, toroute=sides.		}},		Forge Your World Mystical	01.03.2001			
|	|	FML	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	82	", tohome=sides.		, toroute=sides.		}},		Forge Mod Loader	8.0.99.99			
|	|	forestmobs	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	83	", tohome=sides.		, toroute=sides.		}},		Lycanites Forest Mobs	1.20.3.0			
|	|	forestry	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	84	", tohome=sides.		, toroute=sides.		}},		Forestry	5.7.0.219			
|	|	forge	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	85	", tohome=sides.		, toroute=sides.		}},		Minecraft Forge	14.23.3.2676			
|	|	forgeendertech	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	86	", tohome=sides.		, toroute=sides.		}},		Forge Endertech	1.12.1-4.3.0.0			
|	|	forgelin	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	87	", tohome=sides.		, toroute=sides.		}},		Shadowfacts' Forgelin	01.06.2000			
|	|	fp	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	88	", tohome=sides.		, toroute=sides.		}},		Futurepack	26.3.210			
|	|	fp.api	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	89	", tohome=sides.		, toroute=sides.		}},		Futurepack API	01.01.2000			
|	|	fpfa	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	90	", tohome=sides.		, toroute=sides.		}},		Futurepack Forestry Addon	01.01.2002			
|	|	freshwatermobs	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	91	", tohome=sides.		, toroute=sides.		}},		Lycanites Freshwater Mobs	1.20.3.0			
|	|	fresource	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	92	", tohome=sides.		, toroute=sides.		}},		Forge Your World Resource / Core	01.03.2001			
|	|	frsm	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	93	", tohome=sides.		, toroute=sides.		}},		Fex's Random Stuff Mod	4.0.27			
|	|	fvtm	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	94	", tohome=sides.		, toroute=sides.		}},		Fex's Vehicle and Transportation Mod	2.6.b29			
|	|	gemmary	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	95	", tohome=sides.		, toroute=sides.		}},		Gemmary	1.0.0.0			
|	|	gendustry	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	96	", tohome=sides.		, toroute=sides.		}},		GenDustry	1.6.5.8			
|	|	gravestone	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	97	", tohome=sides.		, toroute=sides.		}},		Gravestone Mod	01.10.2001			
|	|	gravitygun	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	98	", tohome=sides.		, toroute=sides.		}},		GravityGun	7.0.0			
|	|	harvestcraft	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	99	", tohome=sides.		, toroute=sides.		}},		Pam's HarvestCraft	1.12.2c			
|	|	hud	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	100	", tohome=sides.		, toroute=sides.		}},		Better HUD	01.03.2009			
|	|	ic2	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	101	", tohome=sides.		, toroute=sides.		}},		IndustrialCraft 2	2.8.73-ex112			
|	|	ichunutil	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	102	", tohome=sides.		, toroute=sides.		}},		iChunUtil	07.01.2004			
|	|	immcraft	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	103	", tohome=sides.		, toroute=sides.		}},		Immersive Craft	01.04.2000			
|	|	immersiveengineering	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	104	", tohome=sides.		, toroute=sides.		}},		Immersive Engineering	0.12-80			
|	|	immersivehempcraft	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	105	", tohome=sides.		, toroute=sides.		}},		Immersive HempCraft	1.12-0.0.4.0			
|	|	immersiverailroading	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	106	", tohome=sides.		, toroute=sides.		}},		Immersive Railroading	1.0.1			
|	|	immersivetech	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	107	", tohome=sides.		, toroute=sides.		}},		Immersive Tech	01.03.2007			
|	|	industrialforegoing	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	108	", tohome=sides.		, toroute=sides.		}},		Industrial Foregoing	1.12.2-1.12.2			
|	|	infernomobs	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	109	", tohome=sides.		, toroute=sides.		}},		Lycanites Inferno Mobs	1.20.3.0			
|	|	infinitycraft	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	110	", tohome=sides.		, toroute=sides.		}},		InfinityCraft	1.12.2-r1			
|	|	inventorytweaks	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	111	", tohome=sides.		, toroute=sides.		}},		Inventory Tweaks	1.63+release.109.220f184			
|	|	itorch	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	112	", tohome=sides.		, toroute=sides.		}},		iTorch	01.02.2000			
|	|	jehc	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	113	", tohome=sides.		, toroute=sides.		}},		Just Enough HarvestCraft	01.03.2001			
|	|	jei	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	114	", tohome=sides.		, toroute=sides.		}},		Just Enough Items	4.8.5.138			
|	|	jeibees	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	115	", tohome=sides.		, toroute=sides.		}},		JEI Bees	0.9.0.5			
|	|	jeiintegration	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	116	", tohome=sides.		, toroute=sides.		}},		JEI Integration	1.5.1.36			
|	|	jeresources	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	117	", tohome=sides.		, toroute=sides.		}},		Just Enough Resources	0.8.7.41			
|	|	junglemobs	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	118	", tohome=sides.		, toroute=sides.		}},		Lycanites Jungle Mobs	1.20.3.0			
|	|	lycanitesmobs	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	119	", tohome=sides.		, toroute=sides.		}},		Lycanites Mobs	1.20.3.0			
|	|	magicbees	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	120	", tohome=sides.		, toroute=sides.		}},		MagicBees	1.0			
|	|	malisisadvert	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	121	", tohome=sides.		, toroute=sides.		}},		Malisis Advert	1.12-6.0.0			
|	|	malisisblocks	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	122	", tohome=sides.		, toroute=sides.		}},		Malisis Blocks	1.12.2-6.0.3			
|	|	malisiscore	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	123	", tohome=sides.		, toroute=sides.		}},		MalisisCore	1.12.2-6.3.0			
|	|	malisisdoors	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	124	", tohome=sides.		, toroute=sides.		}},		MalisisDoors	1.12.2-7.2.2			
|	|	malisisswitches	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	125	", tohome=sides.		, toroute=sides.		}},		Malisis Switches	1.12-5.0.0			
|	|	mantle	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	126	", tohome=sides.		, toroute=sides.		}},		Mantle	1.12-1.3.1.21			
|	|	mcjtylib_ng	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	127	", tohome=sides.		, toroute=sides.		}},		McJtyLib	02.06.2007			
|	|	mcp	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	128	", tohome=sides.		, toroute=sides.		}},		Minecraft Coder Pack	Sep 42			
|	|	mekanism	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	129	", tohome=sides.		, toroute=sides.		}},		Mekanism	1.12.2-9.4.10.345			
|	|	mekanismgenerators	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	130	", tohome=sides.		, toroute=sides.		}},		MekanismGenerators	09.04.2010			
|	|	mekanismtools	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	131	", tohome=sides.		, toroute=sides.		}},		MekanismTools	09.04.2010			
|	|	minewatch	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	132	", tohome=sides.		, toroute=sides.		}},		Minewatch	Mrz 13			
|	|	moarfood	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	133	", tohome=sides.		, toroute=sides.		}},		MoarFood	01.01.2002			
|	|	moartinkers	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	134	", tohome=sides.		, toroute=sides.		}},		Moar Tinkers	0.5.4			
|	|	mobends	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	135	", tohome=sides.		, toroute=sides.		}},		Mo' Bends	0.24			
|	|	modcurrency	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	136	", tohome=sides.		, toroute=sides.		}},		Good Ol' Currency Mod	1.12-1.2.6			
|	|	modernmetals	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	137	", tohome=sides.		, toroute=sides.		}},		Modern Metals	2.5.0-beta3			
|	|	morebeautifulbuttons	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	138	", tohome=sides.		, toroute=sides.		}},		More Beautiful Buttons	1.12.2-1.6.0.14			
|	|	morebeautifulplates	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	139	", tohome=sides.		, toroute=sides.		}},		More Beautiful Plates	1.12.2-1.0.3			
|	|	mores	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	140	", tohome=sides.		, toroute=sides.		}},		Mores	01. Feb			
|	|	mountainmobs	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	141	", tohome=sides.		, toroute=sides.		}},		Lycanites Mountain Mobs	1.20.3.0			
|	|	movingworld	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	142	", tohome=sides.		, toroute=sides.		}},		Moving World	1.12-6.342			
|	|	mxtune	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	143	", tohome=sides.		, toroute=sides.		}},		mxTune	0.5.0-beta.2			
|	|	mysticalagradditions	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	144	", tohome=sides.		, toroute=sides.		}},		Mystical Agradditions	01.02.2008			
|	|	mysticalagriculture	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	145	", tohome=sides.		, toroute=sides.		}},		Mystical Agriculture	01.06.2007			
|	|	neid	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	146	", tohome=sides.		, toroute=sides.		}},		NotEnoughIDs	1.5.4.2			
|	|	nethermetals	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	147	", tohome=sides.		, toroute=sides.		}},		Nether Metals	1.2.0-beta1			
|	|	netherportalfix	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	148	", tohome=sides.		, toroute=sides.		}},		NetherPortalFix	05.03.2013			
|	|	nuclearcraft	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	149	", tohome=sides.		, toroute=sides.		}},		NuclearCraft	2.9d			
|	|	ocjs	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	150	", tohome=sides.		, toroute=sides.		}},		OCJS	0.5.1			
|	|	ocsensors	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	151	", tohome=sides.		, toroute=sides.		}},		OpenComputers Sensors	1.0.4			
|	|	ocxnetdriver	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	152	", tohome=sides.		, toroute=sides.		}},		OpenComputers Xnet Driver	1.0			
|	|	opencomputers	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	153	", tohome=sides.		, toroute=sides.		}},		OpenComputers	1.7.2.104			
|	|	opencomputers|core	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	154	", tohome=sides.		, toroute=sides.		}},		OpenComputers (Core)	1.7.2.104			
|	|	openglider	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	155	", tohome=sides.		, toroute=sides.		}},		Open Glider	@VERSION@			
|	|	openterraingenerator	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	156	", tohome=sides.		, toroute=sides.		}},		Open Terrain Generator	v6			
|	|	orespawn	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	157	", tohome=sides.		, toroute=sides.		}},		OreSpawn	03.02.2000			
|	|	otgcore	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	158	", tohome=sides.		, toroute=sides.		}},		OTG Core	01. Dez			
|	|	persistentbits	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	159	", tohome=sides.		, toroute=sides.		}},		Persistent Bits	1.0.6a			
|	|	personalcars	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	160	", tohome=sides.		, toroute=sides.		}},		Personal Cars	01. Apr			
|	|	placeableitems	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	161	", tohome=sides.		, toroute=sides.		}},		Placeable Items Mod	03. Feb			
|	|	plainsmobs	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	162	", tohome=sides.		, toroute=sides.		}},		Lycanites Plains Mobs	1.20.3.0			
|	|	plants2	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	163	", tohome=sides.		, toroute=sides.		}},		Plants	02.02.2002			
|	|	platforms	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	164	", tohome=sides.		, toroute=sides.		}},		Platforms	01.04.2002			
|	|	props	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	165	", tohome=sides.		, toroute=sides.		}},		Decocraft	02.06.2001			
|	|	psi	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	166	", tohome=sides.		, toroute=sides.		}},		Psi	r1.1-59			
|	|	ptrmodellib	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	167	", tohome=sides.		, toroute=sides.		}},		ptrmodellib	1.0.2			
|	|	quantumstorage	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	168	", tohome=sides.		, toroute=sides.		}},		QuantumStorage	04.04.2006			
|	|	questbook	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	169	", tohome=sides.		, toroute=sides.		}},		Better Questing Quest Book	3.0.0-1.12.1			
|	|	radixcore	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	170	", tohome=sides.		, toroute=sides.		}},		RadixCore	1.12.x-2.2.1			
|	|	rafradek_tf2_weapons	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	171	", tohome=sides.		, toroute=sides.		}},		TF2 Stuff Mod	01.03.2005			
|	|	rangedpumps	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	172	", tohome=sides.		, toroute=sides.		}},		Ranged Pumps	0.5			
|	|	reborncore	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	173	", tohome=sides.		, toroute=sides.		}},		Reborn Core	3.6.1.183			
|	|	rebornstorage	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	174	", tohome=sides.		, toroute=sides.		}},		RebornStorage	1.0.0			
|	|	redstonearsenal	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	175	", tohome=sides.		, toroute=sides.		}},		Redstone Arsenal	02.03.2009			
|	|	redstoneflux	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	176	", tohome=sides.		, toroute=sides.		}},		Redstone Flux	2.0.2			
|	|	redstonepaste	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	177	", tohome=sides.		, toroute=sides.		}},		Redstone Paste	01.07.2005			
|	|	refinedstorage	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	178	", tohome=sides.		, toroute=sides.		}},		Refined Storage	01.05.1932			
|	|	rftools	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	179	", tohome=sides.		, toroute=sides.		}},		RFTools	Jul 33			
|	|	rftoolscontrol	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	180	", tohome=sides.		, toroute=sides.		}},		RFTools Control	01.08.2001			
|	|	rftoolsdim	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	181	", tohome=sides.		, toroute=sides.		}},		RFTools Dimensions	Mai 53			
|	|	runecraft	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	182	", tohome=sides.		, toroute=sides.		}},		ï¿½9RuneCraft	01.04.2002			
|	|	rustic	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	183	", tohome=sides.		, toroute=sides.		}},		Rustic	0.4.5			
|	|	saltmod	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	184	", tohome=sides.		, toroute=sides.		}},		Salty Mod	1.12_d			
|	|	saltwatermobs	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	185	", tohome=sides.		, toroute=sides.		}},		Lycanites Saltwater Mobs	1.20.3.0			
|	|	shadowmobs	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	186	", tohome=sides.		, toroute=sides.		}},		Lycanites Shadow Mobs	1.20.3.0			
|	|	shetiphiancore	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	187	", tohome=sides.		, toroute=sides.		}},		ShetiPhian-Core	03.05.2005			
|	|	signpost	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	188	", tohome=sides.		, toroute=sides.		}},		Sign Post	01.06.2001			
|	|	simpledimensions	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	189	", tohome=sides.		, toroute=sides.		}},		Simple Dimensions	01.03.2001			
|	|	simplytea	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	190	", tohome=sides.		, toroute=sides.		}},		Simply Tea	01. Apr			
|	|	swampmobs	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	191	", tohome=sides.		, toroute=sides.		}},		Lycanites Swamp Mobs	1.20.3.0			
|	|	tconstruct	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	192	", tohome=sides.		, toroute=sides.		}},		Tinkers' Construct	1.12.2-2.9.1.65			
|	|	techreborn	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	193	", tohome=sides.		, toroute=sides.		}},		Tech Reborn	2.12.1.446			
|	|	terraqueous	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	194	", tohome=sides.		, toroute=sides.		}},		Terraqueous	01.04.2006			
|	|	tesla	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	195	", tohome=sides.		, toroute=sides.		}},		TESLA	1.0.63			
|	|	teslacorelib	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	196	", tohome=sides.		, toroute=sides.		}},		Tesla Core Lib	1.0.12			
|	|	teslacorelib_registries	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	197	", tohome=sides.		, toroute=sides.		}},		Tesla Core Lib Registries	1.0.12			
|	|	teslathingies	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	198	", tohome=sides.		, toroute=sides.		}},		Tesla Powered Thingies	1.0.12			
|	|	theoneprobe	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	199	", tohome=sides.		, toroute=sides.		}},		The One Probe	01.04.2019			
|	|	thermalcultivation	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	200	", tohome=sides.		, toroute=sides.		}},		Thermal Cultivation	0.1.4			
|	|	thermaldynamics	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	201	", tohome=sides.		, toroute=sides.		}},		Thermal Dynamics	02.03.2009			
|	|	thermalexpansion	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	202	", tohome=sides.		, toroute=sides.		}},		Thermal Expansion	05.03.2009			
|	|	thermalfoundation	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	203	", tohome=sides.		, toroute=sides.		}},		Thermal Foundation	02.03.2009			
|	|	tinkersoc	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	204	", tohome=sides.		, toroute=sides.		}},		Tinkers Construct OpenComputers Driver	0.1			
|	|	tinkertoolleveling	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	205	", tohome=sides.		, toroute=sides.		}},		Tinkers Tool Leveling	1.12-1.0.3.DEV.56fac4f			
|	|	torcharrowsmod	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	206	", tohome=sides.		, toroute=sides.		}},		TorchArrows	1.12.1-3			
|	|	trackapi	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	207	", tohome=sides.		, toroute=sides.		}},		Track API	01. Jan			
|	|	twilightforest	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	208	", tohome=sides.		, toroute=sides.		}},		The Twilight Forest	3.5.263			
|	|	uniquecrops	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	209	", tohome=sides.		, toroute=sides.		}},		Unique Crops	0.1.46			
|	|	unlimitedchiselworks	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	210	", tohome=sides.		, toroute=sides.		}},		Unlimited Chisel Works	0.2.0			
|	|	unlimitedchiselworks_botany	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	211	", tohome=sides.		, toroute=sides.		}},		Unlimited Chisel Works	Botany Compat			
|	|	valkyrielib	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	212	", tohome=sides.		, toroute=sides.		}},		Valkyrie Lib	1.12.2-2.0.8a			
|	|	vc	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	213	", tohome=sides.		, toroute=sides.		}},		ViesCraft	05.06.2000			
|	|	waddles	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	214	", tohome=sides.		, toroute=sides.		}},		Waddles	0.5.6			
|	|	worldutils	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	215	", tohome=sides.		, toroute=sides.		}},		World Utils	0.4.2			
|	|	xnet	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	216	", tohome=sides.		, toroute=sides.		}},		XNet	01.06.2007			
|	|	xray	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	217	", tohome=sides.		, toroute=sides.		}},		XRay	01.04.2000			
|	|	xreliquary	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	218	", tohome=sides.		, toroute=sides.		}},		Reliquary	1.12.2-1.3.4.728			
|	|	zerocore	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	219	", tohome=sides.		, toroute=sides.		}},		Zero CORE	1.12-0.1.1.0			
|	|	actuallyadditions	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	220	", tohome=sides.		, toroute=sides.		}},		Actually Additions	1.12.2-r133			
|	|	adhooks	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	221	", tohome=sides.		, toroute=sides.		}},		Advanced Hook Launchers	1.12.1-3.1.2.0			
|	|	advancedrocketry	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	222	", tohome=sides.		, toroute=sides.		}},		Advanced Rocketry	1.4.0.-82			
|	|	ae2stuff	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	223	", tohome=sides.		, toroute=sides.		}},		AE2 Stuff	0.7.0.4			
|	|	aether_legacy	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	224	", tohome=sides.		, toroute=sides.		}},		Aether Legacy	1.12.2-v1.0.1			
|	|	animania	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	225	", tohome=sides.		, toroute=sides.		}},		Animania	01.04.2003			
|	|	appliedenergistics2	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	226	", tohome=sides.		, toroute=sides.		}},		Applied Energistics 2	rv5-stable-4			
|	|	aquamunda	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	227	", tohome=sides.		, toroute=sides.		}},		Aqua Munda	0.3.0beta			
|	|	astikoor	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	228	", tohome=sides.		, toroute=sides.		}},		Astikoor	1.0.0			
|	|	atlcraft	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	229	", tohome=sides.		, toroute=sides.		}},		ATLCraft Candles Mod	MC1.12-Ver1.9			
|	|	basemetals	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	230	", tohome=sides.		, toroute=sides.		}},		Base Metals	2.5.0-beta3			
|	|	betterquesting	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	231	", tohome=sides.		, toroute=sides.		}},		Better Questing	2.5.236			
|	|	bibliocraft	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	232	", tohome=sides.		, toroute=sides.		}},		BiblioCraft	02.04.2003			
|	|	binniecore	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	233	", tohome=sides.		, toroute=sides.		}},		Binnie Core	unspecified			
|	|	binniedesign	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	234	", tohome=sides.		, toroute=sides.		}},		Binnie's Design	1.0			
|	|	biomesoplenty	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	235	", tohome=sides.		, toroute=sides.		}},		Biomes O' Plenty	7.0.1.2312			
|	|	botania	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	236	", tohome=sides.		, toroute=sides.		}},		Botania	r1.10-353			
|	|	botany	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	237	", tohome=sides.		, toroute=sides.		}},		Binnie's Botany	2.5.0.110			
|	|	buildcraftbuilders	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	238	", tohome=sides.		, toroute=sides.		}},		BC Builders	7.99.13			
|	|	buildcraftcore	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	239	", tohome=sides.		, toroute=sides.		}},		BuildCraft	7.99.13			
|	|	buildcraftenergy	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	240	", tohome=sides.		, toroute=sides.		}},		BC Energy	7.99.13			
|	|	buildcraftfactory	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	241	", tohome=sides.		, toroute=sides.		}},		BC Factory	7.99.13			
|	|	buildcraftlib	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	242	", tohome=sides.		, toroute=sides.		}},		BuildCraft Lib	7.99.13			
|	|	buildcraftrobotics	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	243	", tohome=sides.		, toroute=sides.		}},		BC Robotics	7.99.13			
|	|	buildcraftsilicon	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	244	", tohome=sides.		, toroute=sides.		}},		BC Silicon	7.99.13			
|	|	buildcrafttransport	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	245	", tohome=sides.		, toroute=sides.		}},		BC Transport	7.99.13			
|	|	extrabees	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	246	", tohome=sides.		, toroute=sides.		}},		Binnie's Extra Bees	2.5.0.110			
|	|	extratrees	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	247	", tohome=sides.		, toroute=sides.		}},		Binnie's Extra Trees	2.5.0.110			
|	|	genetics	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	248	", tohome=sides.		, toroute=sides.		}},		Binnie's Genetics	2.5.0.110			
|	|	libvulpes	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	249	", tohome=sides.		, toroute=sides.		}},		Vulpes library	0.2.8.-31			
|	|	minecraft	 = {home={proxy="			", tocraft=sides.		, toroute=sides.		}, craft={proxy="	250	", tohome=sides.		, toroute=sides.		}}		Minecraft	01.12.2002			
|	}
end	
local function RouteSystem()
|	return {																					
|	|	actuallycomputers	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	adchimneys	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	aperture	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	arcticmobs	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	as_extraresources	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	autoreglib	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	baubles	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	bdlib	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	bigreactors	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	biomebundle	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	blockpalette	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	bookshelf	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	bq_standard	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	brandonscore	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	bushmastercore	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	car	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	carryon	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	carz	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	cdm	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	ceramics	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	cfm	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	chisel	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	chiselsandbits	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	chunkpregenerator	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	codechickenlib	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	cofhcore	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	cofhworld	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	compactmachines3	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	compot	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	connect	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	conquest	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	cookingforblockheads	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	corail_pillar	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	corail_pillar_extension_biomesoplenty	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	corail_pillar_extension_chisel	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	corail_pillar_extension_forestry	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	coralreef	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	craftstudioapi	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	crafttweaker	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	crafttweakerjei	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	ctgui	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	ctm	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	cucumber	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	customnpcs	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	cyclicmagic	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	darkutils	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	davincisvessels	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	ddb	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	deepresonance	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	defiledlands	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	demonmobs	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	desertmobs	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	draconicevolution	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	dynamiclights	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	dynamiclights_creepers	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	dynamiclights_dropitems	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	dynamiclights_entityclasses	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	dynamiclights_flamearrows	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	dynamiclights_floodlights	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	dynamiclights_mobequipment	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	dynamiclights_onfire	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	dynamiclights_otherplayers	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	dynamiclights_theplayer	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	eleccore	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	electrostatics	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	elementalmobs	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	energyconverters	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	environmentalmaterials	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	environmentaltech	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	etlunar	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	extrabitmanipulation	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	extrautils2	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	fairylights	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	farmory	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	fcl	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	fdecostuff	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	ffactory	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	ffoods	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	flatcoloredblocks	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	floricraft	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	fmagic	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	FML	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	forestmobs	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	forestry	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	forge	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	forgeendertech	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	forgelin	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	fp	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	fp.api	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	fpfa	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	freshwatermobs	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	fresource	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	frsm	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	fvtm	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	gemmary	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	gendustry	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	gravestone	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	gravitygun	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	harvestcraft	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	hud	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	ic2	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	ichunutil	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	immcraft	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	immersiveengineering	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	immersivehempcraft	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	immersiverailroading	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	immersivetech	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	industrialforegoing	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	infernomobs	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	infinitycraft	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	inventorytweaks	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	itorch	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	jehc	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	jei	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	jeibees	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	jeiintegration	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	jeresources	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	junglemobs	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	lycanitesmobs	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	magicbees	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	malisisadvert	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	malisisblocks	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	malisiscore	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	malisisdoors	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	malisisswitches	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	mantle	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	mcjtylib_ng	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	mcp	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	mekanism	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	mekanismgenerators	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	mekanismtools	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	minewatch	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	moarfood	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	moartinkers	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	mobends	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	modcurrency	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	modernmetals	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	morebeautifulbuttons	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	morebeautifulplates	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	mores	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	mountainmobs	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	movingworld	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	mxtune	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	mysticalagradditions	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	mysticalagriculture	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	neid	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	nethermetals	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	netherportalfix	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	nuclearcraft	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	ocjs	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	ocsensors	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	ocxnetdriver	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	opencomputers	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	opencomputers|core	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	openglider	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	openterraingenerator	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	orespawn	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	otgcore	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	persistentbits	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	personalcars	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	placeableitems	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	plainsmobs	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	plants2	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	platforms	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	props	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	psi	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	ptrmodellib	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	quantumstorage	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	questbook	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	radixcore	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	rafradek_tf2_weapons	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	rangedpumps	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	reborncore	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	rebornstorage	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	redstonearsenal	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	redstoneflux	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	redstonepaste	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	refinedstorage	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	rftools	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	rftoolscontrol	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	rftoolsdim	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	runecraft	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	rustic	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	saltmod	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	saltwatermobs	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	shadowmobs	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	shetiphiancore	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	signpost	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	simpledimensions	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	simplytea	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	swampmobs	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	tconstruct	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	techreborn	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	terraqueous	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	tesla	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	teslacorelib	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	teslacorelib_registries	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	teslathingies	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	theoneprobe	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	thermalcultivation	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	thermaldynamics	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	thermalexpansion	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	thermalfoundation	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	tinkersoc	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	tinkertoolleveling	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	torcharrowsmod	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	trackapi	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	twilightforest	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	uniquecrops	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	unlimitedchiselworks	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	unlimitedchiselworks_botany	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	valkyrielib	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	vc	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	waddles	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	worldutils	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	xnet	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	xray	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	xreliquary	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	zerocore	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	actuallyadditions	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	adhooks	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	advancedrocketry	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	ae2stuff	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	aether_legacy	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	animania	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	appliedenergistics2	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	aquamunda	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	astikoor	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	atlcraft	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	basemetals	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	betterquesting	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	bibliocraft	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	binniecore	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	binniedesign	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	biomesoplenty	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	botania	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	botany	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	buildcraftbuilders	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	buildcraftcore	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	buildcraftenergy	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	buildcraftfactory	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	buildcraftlib	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	buildcraftrobotics	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	buildcraftsilicon	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	buildcrafttransport	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	extrabees	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	extratrees	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	genetics	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	libvulpes	 = {proxy="			", home=sides.		, craft=sides.		},												
|	|	minecraft	 = {proxy="			", home=sides.		, craft=sides.		}												
|	}																					