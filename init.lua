
lib_clouds = {}

-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")


local water_level = tonumber(minetest.get_mapgen_setting("water_level")) or 1

local enable = minetest.setting_getbool("lib_clouds_enable") or true
local regeneration = minetest.setting_getbool("lib_clouds_regeneration") or false

local cirrus_miny = minetest.setting_get("lib_clouds_cirrus_miny") or 150
local cirrus_maxy = minetest.setting_get("lib_clouds_cirrus_maxy") or 200
local cumulus_miny = minetest.setting_get("lib_clouds_cumulus_miny") or 120
local cumulus_maxy = minetest.setting_get("lib_clouds_cumulus_maxy") or 150
local fog_miny = minetest.setting_get("lib_clouds_fog_miny") or water_level
local fog_maxy = minetest.setting_get("lib_clouds_fog_maxy") or 25



if enable == true then


	minetest.register_node('lib_clouds:cloud_cirrus', {
		description = S("Cirrus Cloud"),
		_doc_items_longdesc = S("3D Clouds"),
		_doc_items_usagehelp = S("Generates 3D Clouds in air between 150m and 200m."),
		drawtype = "glasslike",
		tiles = {"lib_clouds_cloud.png"},
		--use_texture_alpha = false,
		paramtype = "light",
		post_effect_color = { r=128, g=128, b=128, a=128 },
		is_ground_content = false,
		sunlight_propagates = false,
		walkable = false,
		pointable = false,
		diggable = false,
		climbable = false,
		buildable_to = false,
		floodable = false, -- If true, liquids flow into and replace this node
		groups = {lib_clouds = 1},

		--node lifespan
		on_construct = function(pos)
			minetest.get_node_timer(pos):start(300)
		end,
		on_timer = function(pos, elapsed)
			minetest.set_node(pos, {name = "air"})
		end,
	})

	minetest.register_node('lib_clouds:cloud_cumulus', {
		description = S("Cumulus Cloud"),
		_doc_items_longdesc = S("3D Clouds"),
		_doc_items_usagehelp = S("Generates 3D Clouds in air between 120 and 150m."),
		drawtype = "glasslike",
		tiles = {"lib_clouds_cloud.png"},
		use_texture_alpha = true,
		paramtype = "light",
		post_effect_color = { r=128, g=128, b=128, a=128 },
		is_ground_content = false,
		sunlight_propagates = false,
		walkable = false,
		pointable = false,
		diggable = false,
		climbable = false,
		buildable_to = false,
		groups = {lib_clouds = 1},

		--node lifespan
		on_construct = function(pos)
			minetest.get_node_timer(pos):start(300)
		end,
		on_timer = function(pos, elapsed)
			minetest.set_node(pos, {name = "air"})
		end,
	})

	minetest.register_node('lib_clouds:cloud_fog', {
		description = S("Cirrus Cloud"),
		_doc_items_longdesc = S("3D Clouds"),
		_doc_items_usagehelp = S("Generates 3D Clouds in air between water_level or 1 and 25m."),
		drawtype = "glasslike",
		tiles = {"lib_clouds_cloud.png"},
		use_texture_alpha = true,
		paramtype = "light",
		light_source = 8,
		post_effect_color = { r=128, g=128, b=128, a=128 },
		is_ground_content = false,
		sunlight_propagates = true,
		walkable = false,
		pointable = false,
		diggable = false,
		climbable = false,
		buildable_to = false,
		groups = {lib_clouds = 1},

		--node lifespan
		on_construct = function(pos)
			minetest.get_node_timer(pos):start(300)
		end,
		on_timer = function(pos, elapsed)
			minetest.set_node(pos, {name = "air"})
		end,
	})



	minetest.register_ore({
		ore_type = "scatter", -- See "Ore types"
		ore = "lib_clouds:cloud_cirrus",
		wherein = "air",
		clust_scarcity = 8*8*8,
		clust_num_ores = 64,
		clust_size = 5,
		y_min = water_level + cirrus_miny,
		y_max = water_level + cirrus_maxy,
		flags = "",
		noise_threshold = 0.5,
		noise_params = {offset=0, scale=1, spread={x=100, y=100, z=100}, seed=23, octaves=3, persist=0.70},
				--  ^ NoiseParams structure describing the perlin noise used for ore distribution.
				--  ^ Needed for sheet ore_type.  Omit from scatter ore_type for a uniform ore distribution
		random_factor = 1.0,
				--  ^ Multiplier of the randomness contribution to the noise value at any
				--   given point to decide if ore should be placed.  Set to 0 for solid veins.
				--  ^ This parameter is only valid for ore_type == "vein".
		--biomes = {"tundra", "desert"}
				--  ^ List of biomes in which this decoration occurs.  Occurs in all biomes if this is omitted,
				--  ^ and ignored if the Mapgen being used does not support biomes.
				--  ^ Can be a list of (or a single) biome names, IDs, or definitions.
	})

	minetest.register_ore({
		ore_type = "puff", -- See "Ore types"
		ore = "lib_clouds:cloud_cumulus",
		wherein = "air",
		clust_scarcity = 8*8*8,
		clust_num_ores = 6,
		clust_size = 2,
		y_min = water_level + cumulus_miny,
		y_max = water_level + cumulus_maxy,
		flags = "",
		noise_threshold = 0.5,
		noise_params = {offset=0, scale=1, spread={x=100, y=100, z=100}, seed=23, octaves=3, persist=0.70},
				--  ^ NoiseParams structure describing the perlin noise used for ore distribution.
				--  ^ Needed for sheet ore_type.  Omit from scatter ore_type for a uniform ore distribution
		random_factor = 1.0,
				--  ^ Multiplier of the randomness contribution to the noise value at any
				--   given point to decide if ore should be placed.  Set to 0 for solid veins.
				--  ^ This parameter is only valid for ore_type == "vein".
		--biomes = {"rainforest", "deciduous_forest_swamp", "rainforest_swamp", "deciduous_forest", "coniferous_forest", "stone_grassland"}
				--  ^ List of biomes in which this decoration occurs.  Occurs in all biomes if this is omitted,
				--  ^ and ignored if the Mapgen being used does not support biomes.
				--  ^ Can be a list of (or a single) biome names, IDs, or definitions.
	})

	minetest.register_ore({
		ore_type = "puff", -- See "Ore types"
		ore = "lib_clouds:cloud_fog",
		wherein = {"air", "default:water_source",},
		clust_scarcity = 8*8*8,
		clust_num_ores = 8,
		clust_size = 3,
		y_min = water_level + fog_miny,
		y_max = water_level + fog_maxy,
		flags = "",
		noise_threshold = 0.5,
		noise_params = {offset=0, scale=1, spread={x=100, y=100, z=100}, seed=23, octaves=3, persist=0.70},
				--  ^ NoiseParams structure describing the perlin noise used for ore distribution.
				--  ^ Needed for sheet ore_type.  Omit from scatter ore_type for a uniform ore distribution
		random_factor = 0.4,
				--  ^ Multiplier of the randomness contribution to the noise value at any
				--   given point to decide if ore should be placed.  Set to 0 for solid veins.
				--  ^ This parameter is only valid for ore_type == "vein".
		--biomes = {"rainforest", "deciduous_forest_swamp", "rainforest_swamp" }
				--  ^ List of biomes in which this decoration occurs.  Occurs in all biomes if this is omitted,
				--  ^ and ignored if the Mapgen being used does not support biomes.
				--  ^ Can be a list of (or a single) biome names, IDs, or definitions.
	})


	if regeneration then

		minetest.register_abm{
			 nodenames = {"lib_clouds:cloud_cirrus"},
			interval = 7.5,
			chance = 5,
			catch_up = false,
			action = function(pos)

				local radius = 4
				local growthlimitgoo = 3
				local airlimit = 15

			--count goolim
				local num_goolim = {}
				
				local ps, cn = minetest.find_nodes_in_area(
					{x = pos.x - radius, y = pos.y - radius, z = pos.z - radius},
					{x = pos.x + radius, y = pos.y + radius, z = pos.z + radius}, {"lib_clouds:cloud_cirrus"})
				num_goolim = (cn["lib_clouds:cloud_cirrus"] or 0)

			--count air
				local num_gooair = {}
				local radius = 1
				local ps, cn = minetest.find_nodes_in_area(
					{x = pos.x - radius, y = pos.y - radius, z = pos.z - radius},
					{x = pos.x + radius, y = pos.y + radius, z = pos.z + radius}, {"air"})
				num_gooair = (cn["air"] or 0)

			--Replicate
				
				randpos = {x = pos.x + math.random(-1,1), y = pos.y + math.random(-1,1), z = pos.z + math.random(-1,1)}
				
				if num_goolim < growthlimitgoo then

					--spread to air
					if (num_gooair) > airlimit and minetest.get_node(randpos).name == "air" then
							
						minetest.set_node(randpos, {name = "lib_clouds:cloud_cirrus"})
								
					end	
						
				end
			
			end,
		}

		minetest.register_abm{
			 nodenames = {"lib_clouds:cloud_cirrus"},
			interval = 6,
			chance = 12,
			catch_up = true,
			action = function(pos)


				local radius = 2
				local growthlimitgoo = 8
				local airlimit = 10

			--count goolim
				local num_goolim = {}
				
				local ps, cn = minetest.find_nodes_in_area(
					{x = pos.x - radius, y = pos.y - radius, z = pos.z - radius},
					{x = pos.x + radius, y = pos.y + radius, z = pos.z + radius}, {"lib_clouds:cloud_cirrus"})
				num_goolim = (cn["lib_clouds:cloud_cirrus"] or 0)

			--count air
				local num_gooair = {}
				local radius = 1
				local ps, cn = minetest.find_nodes_in_area(
					{x = pos.x - radius, y = pos.y - radius, z = pos.z - radius},
					{x = pos.x + radius, y = pos.y + radius, z = pos.z + radius}, {"air"})
				num_gooair = (cn["air"] or 0)



			-- for Replicate sideways
				
				randpos = {x = pos.x + math.random(-1,1), y = pos.y, z = pos.z + math.random(-1,1)}


			-- for check light level at destination
			 
				local light_level_ranpos = {}
				local light_level_ranpos  = ((minetest.get_node_light(randpos)) or 0)


				
		-- do if well lit

			if  light_level_ranpos >=14 then

				

			if num_goolim < growthlimitgoo then

				--spread to air
				if (num_gooair) > airlimit and minetest.get_node(randpos).name == "air" then
						
					minetest.set_node(randpos, {name = "lib_clouds:cloud_cirrus"})
							
				end	
					
			end
			end
		end,
		}


		minetest.register_abm({
			nodenames = {"lib_clouds:cloud_cumulus"},
			neighbors = {"air"},
			interval = 15,
			chance = 10,
			catch_up = true,
			action = function(pos)

				local radius = 1
				local growthlimitgoo = 3
				local airlimit = 15

			--count goolim
				local num_goolim = {}
				
				local ps, cn = minetest.find_nodes_in_area(
					{x = pos.x - radius, y = pos.y - radius, z = pos.z - radius},
					{x = pos.x + radius, y = pos.y + radius, z = pos.z + radius}, {"lib_clouds:cloud_cumulus"})
				num_goolim = (cn["lib_clouds:cloud_cumulus"] or 0)

			--count air
				local num_gooair = {}
				local radius = 1
				local ps, cn = minetest.find_nodes_in_area(
					{x = pos.x - radius, y = pos.y - radius, z = pos.z - radius},
					{x = pos.x + radius, y = pos.y + radius, z = pos.z + radius}, {"air"})
				num_gooair = (cn["air"] or 0)

			--Replicate
				
				randpos = {x = pos.x + math.random(-1,1), y = pos.y + math.random(-1,1), z = pos.z + math.random(-1,1)}
				
				if num_goolim < growthlimitgoo then

					--spread to air
					if (num_gooair) > airlimit and minetest.get_node(randpos).name == "air" then
							
						minetest.set_node(randpos, {name = "lib_clouds:cloud_cumulus"})
								
					end	
						
				end

			end,
		})

		minetest.register_abm({
			nodenames = {"lib_clouds:cloud_cumulus"},
			neighbors = {"air"},
			interval = 10,
			chance = 30,
			catch_up = true,
			action = function(pos)

				local radius = 2
				local growthlimitgoo = 8
				local airlimit = 10

			--count goolim
				local num_goolim = {}
				
				local ps, cn = minetest.find_nodes_in_area(
					{x = pos.x - radius, y = pos.y - radius, z = pos.z - radius},
					{x = pos.x + radius, y = pos.y + radius, z = pos.z + radius}, {"lib_clouds:cloud_cumulus"})
				num_goolim = (cn["lib_clouds:cloud_cumulus"] or 0)

			--count air
				local num_gooair = {}
				local radius = 1
				local ps, cn = minetest.find_nodes_in_area(
					{x = pos.x - radius, y = pos.y - radius, z = pos.z - radius},
					{x = pos.x + radius, y = pos.y + radius, z = pos.z + radius}, {"air"})
				num_gooair = (cn["air"] or 0)

			-- for Replicate sideways
				
				randpos = {x = pos.x + math.random(-1,1), y = pos.y, z = pos.z + math.random(-1,1)}

			-- for check light level at destination
			 
				local light_level_ranpos = {}
				local light_level_ranpos  = ((minetest.get_node_light(randpos)) or 0)

		-- do if well lit

				if  light_level_ranpos >=14 then

					if num_goolim < growthlimitgoo then

						--spread to air
						if (num_gooair) > airlimit and minetest.get_node(randpos).name == "air" then
								
							minetest.set_node(randpos, {name = "lib_clouds:cloud_cumulus"})
									
						end	
					end
				end
			end,
		})


		minetest.register_abm({
			nodenames = {"lib_clouds:cloud_fog"},
			neighbors = {"air"},
			interval = 5,
			chance = 5,
			catch_up = true,
			action = function(pos)

				local radius = 1
				local growthlimitgoo = 3
				local airlimit = 15

			--count goolim
				local num_goolim = {}
				
				local ps, cn = minetest.find_nodes_in_area(
					{x = pos.x - radius, y = pos.y - radius, z = pos.z - radius},
					{x = pos.x + radius, y = pos.y + radius, z = pos.z + radius}, {"lib_clouds:cloud_fog"})
				num_goolim = (cn["lib_clouds:cloud_fog"] or 0)

			--count air
				local num_gooair = {}
				local radius = 1
				local ps, cn = minetest.find_nodes_in_area(
					{x = pos.x - radius, y = pos.y - radius, z = pos.z - radius},
					{x = pos.x + radius, y = pos.y + radius, z = pos.z + radius}, {"air"})
				num_gooair = (cn["air"] or 0)

			--Replicate
				
				randpos = {x = pos.x + math.random(-1,1), y = pos.y + math.random(-1,1), z = pos.z + math.random(-1,1)}
				
				if num_goolim < growthlimitgoo then

					--spread to air
					if (num_gooair) > airlimit and minetest.get_node(randpos).name == "air" then
							
						minetest.set_node(randpos, {name = "lib_clouds:cloud_fog"})
								
					end	
						
				end

			end,
		})

		minetest.register_abm({
			nodenames = {"lib_clouds:cloud_fog"},
			neighbors = {"air"},
			interval = 5,
			chance = 15,
			catch_up = true,
			action = function(pos)

				local radius = 2
				local growthlimitgoo = 8
				local airlimit = 10

			--count goolim
				local num_goolim = {}
				
				local ps, cn = minetest.find_nodes_in_area(
					{x = pos.x - radius, y = pos.y - radius, z = pos.z - radius},
					{x = pos.x + radius, y = pos.y + radius, z = pos.z + radius}, {"lib_clouds:cloud_fog"})
				num_goolim = (cn["lib_clouds:cloud_fog"] or 0)

			--count air
				local num_gooair = {}
				local radius = 1
				local ps, cn = minetest.find_nodes_in_area(
					{x = pos.x - radius, y = pos.y - radius, z = pos.z - radius},
					{x = pos.x + radius, y = pos.y + radius, z = pos.z + radius}, {"air"})
				num_gooair = (cn["air"] or 0)

			-- for Replicate sideways
				
				randpos = {x = pos.x + math.random(-1,1), y = pos.y, z = pos.z + math.random(-1,1)}

			-- for check light level at destination
			 
				local light_level_ranpos = {}
				local light_level_ranpos  = ((minetest.get_node_light(randpos)) or 0)

		-- do if well lit

				if  light_level_ranpos >=14 then

					if num_goolim < growthlimitgoo then

						--spread to air
						if (num_gooair) > airlimit and minetest.get_node(randpos).name == "air" then
								
							minetest.set_node(randpos, {name = "lib_clouds:cloud_fog"})
									
						end	
					end
				end
			end,
		})
	end
end


