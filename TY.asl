/* 
     _____ __   __    _    ___  _    
    |_   _|\ \ / /   /_\  / __|| |   
      | |   \ V /_  / _ \ \__ \| |__ 
      |_|    |_|(_)/_/ \_\|___/|____|
If that looks funky ^ use a better text editor nerd.

    Ty the Tasmanian Tiger Autosplitter / Load Remover
    - Original ASL by Rythin
    - Rewrite by xMcacutt (Matt)

This autosplitter and load remover was written with a lot of care and attention to detail.
Please feel free to contact me by any means if more details on the ASL are required.
*/

state("TY", "V1.44") 
{
    byte loading:     0x285E84; // 1 on 2 paws, 0 on full paws
    byte paused:      0x289048; // 1 when pause menu open. 0 when not.
    float autosave_x: 0x28E610; // -219.9111176 when off screen
    int bilby_count:  0x2651AC; // For current level
    int cog_count:    0x265260; // For current level
    byte egg_count:   0x288730, 0xD; // Total
    int opal_count:   0x2888B0; // For current level
    byte completion:  0x288730, 0xC; // % based
    byte final_tali:  0x288730, 0xAC8; // Final talisman state in save data
    byte level:       0x288730, 0xAA4; // Level index (Z,A,B,C,D,E | 1-4 -> Z1 = 0, E4 -> 23)
    byte prev_level:  0x288730, 0xAA8;   
    byte menu_index:  0x286640; // Index of option selected on main menu
    int menu_loaded:  0x285B94; // 0 if main menu not yet loaded (used for crash handling)
    byte save_index:  0x28E6C4; // Save slot index
    byte menu_state:  0x28DCA0; // 255 if in game. Changes on menu depending on which screen is loaded.
    bool hardcore:    0x288730, 0xE; // Determines if hardcore has been activated for the save.
    // Rang collection data
    byte got_second:  0x288730, 0xAB6;
    byte got_frosty:  0x288730, 0xAB9;
    byte got_flame:   0x288730, 0xABA;
    byte got_kaboom:  0x288730, 0xABB;
    byte got_doom:    0x288730, 0xABC;
    byte got_mega:    0x288730, 0xABD;
    byte got_zoom:    0x288730, 0xABE;
    byte got_infra:   0x288730, 0xABF;
    byte got_zappy:   0x288730, 0xAC0;
    byte got_aqua:    0x288730, 0xAC1;
    byte got_multi:   0x288730, 0xAC2;
    byte got_chrono:  0x288730, 0xAC3;
}

state("Mul-Ty-Player", "V1.44") // Different process name for MTP.
{
    byte loading:     0x285E84;
    byte paused:      0x289048; 
    float autosave_x: 0x28E610; 
    int bilby_count:  0x2651AC;
    int cog_count:    0x265260;
    byte egg_count:   0x288730, 0xD;
    int opal_count:   0x2888B0;
    byte completion:  0x288730, 0xC;
    byte final_tali:  0x288730, 0xAC8;
    byte level:       0x288730, 0xAA4;
    byte prev_level:  0x288730, 0xAA8;
    byte menu_index:  0x286640;
    int menu_loaded:  0x285B94;
    byte save_index:  0x28E6C4;
    byte menu_state:  0x28DCA0;
    bool hardcore:    0x288730, 0xE;
    byte got_second:  0x288730, 0xAB6;
    byte got_frosty:  0x288730, 0xAB9;
    byte got_flame:   0x288730, 0xABA;
    byte got_kaboom:  0x288730, 0xABB;
    byte got_doom:    0x288730, 0xABC;
    byte got_mega:    0x288730, 0xABD;
    byte got_zoom:    0x288730, 0xABE;
    byte got_infra:   0x288730, 0xABF;
    byte got_zappy:   0x288730, 0xAC0;
    byte got_aqua:    0x288730, 0xAC1;
    byte got_multi:   0x288730, 0xAC2;
    byte got_chrono:  0x288730, 0xAC3;
}

state("TY", "V1.11") // Old Patch.
{
    byte loading:     0x273A94;
    byte paused:      0x278AC0;
    float autosave_x: 0x280288; 
    int bilby_count:  0x279CF8;
    int cog_count:    0x279DAC;
    byte egg_count:   0x278230, 0xD;
    int opal_count:   0x2783B0;
    byte completion:  0x278230, 0xC;
    byte final_tali:  0x278230, 0xAC8;
    byte level:       0x278230, 0xAA4;
    byte prev_level:  0x278230, 0xAA8;
    byte menu_index:  0x2741D0;
    int menu_loaded:  0x2737A4;
    byte save_index:  0x280950;
    byte menu_state:  0x27F918;
    byte got_second:  0x278230, 0xAB6;
    byte got_frosty:  0x278230, 0xAB9;
    byte got_flame:   0x278230, 0xABA;
    byte got_kaboom:  0x278230, 0xABB;
    byte got_doom:    0x278230, 0xABC;
    byte got_mega:    0x278230, 0xABD;
    byte got_zoom:    0x278230, 0xABE;
    byte got_infra:   0x278230, 0xABF;
    byte got_zappy:   0x278230, 0xAC0;
    byte got_aqua:    0x278230, 0xAC1;
    byte got_multi:   0x278230, 0xAC2;
    byte got_chrono:  0x278230, 0xAC3;
}

startup 
{
    vars.crashed = false;

    vars.finished = false;

    // Used for timing the length of the autosave.
    vars.stopwatch1 = new Stopwatch(); 
    vars.save_time = 0;

    // Used for timing the length of non-pause time after an autosave to void the time removal if a threshold is exceeded.
    vars.stopwatch2 = new Stopwatch(); 
    vars.non_pause_time = 0;
    
    // Prevents splitting on reload unless all conditions are met.
    vars.can_split_reload = false; 

    // Prevents splitting immediately after intro cutscene when RC reload setting is on.
    vars.can_split_first = false; 

    // Collectible state containers.
    vars.cog_states = new byte[10];
    vars.egg_states = new byte[8];
    vars.bilby_states = new byte[5];

    // Settings
    settings.Add("Start", true, "Autostart settings");
        settings.Add("0", true, "Start on Save Slot 1", "Start");
        settings.Add("1", true, "Start on Save Slot 2", "Start");
        settings.Add("2", true, "Start on Save Slot 3", "Start");
        settings.Add("Hardcore", false, "Only Start If Hardcore", "Start");
        settings.Add("IL", false, "IL Mode", "Start");
            settings.SetToolTip("IL", "Start the timer on entering a level from main menu, rather than Rainbow Cliffs");
    settings.Add("Category", true, "Category Settings");
        settings.Add("Any% Final", true, "Split Early Any% Final Load", "Category");
            settings.SetToolTip("Any% Final", "Split as soon as doomerang hits final battle trigger.");
        settings.Add("100%", false, "Split On 100% Completion", "Category");
            settings.SetToolTip("100%", "Split as soon as save file hits 100% completion.");
        settings.Add("All Opals", false, "Split On 300 Opals", "Category");
            settings.SetToolTip("All Opals", "Split (per level) as soon as 300 opals have been collected (Recommended: Turn level entry / exits off)");
        settings.Add("All Rainbow Scales", false, "Split On Every Opal", "Category");
            settings.SetToolTip("All Rainbow Scales", "Intended for All Rainbow Scales only.");
    settings.Add("Rangs", false);
        settings.Add("Got Second Rang", false, "Got Second Rang", "Rangs");
        settings.Add("Got Frostyrang", false,  "Got Frostyrang", "Rangs");
        settings.Add("Got Flamerang", false, "Got Flamerang", "Rangs");
        settings.Add("Got Kaboomerang", false, "Got Kaboomerang", "Rangs");
        settings.Add("Got Doomerang", false, "Got Doomerang", "Rangs");
        settings.Add("Got Megarang", false, "Got Megarang",  "Rangs");
        settings.Add("Got Zoomerang", false, "Got Zoomerang", "Rangs");
        settings.Add("Got Infrarang", false, "Got Infrarang", "Rangs");
        settings.Add("Got Zappyrang", false, "Got Zappyrang", "Rangs");
        settings.Add("Got Aquarang", false, "Got Aquarang",  "Rangs");
        settings.Add("Got Multirang", false, "Got Multirang", "Rangs");
        settings.Add("Got Chronorang", false, "Got Chronorang", "Rangs");
    settings.Add("Levels", true);
    vars.levels = new Dictionary<int, string>
    {
        {0, "Rainbow Cliffs"}, 
        {4, "Two Up"}, {5, "Walk in the Park"}, {6, "Ship Rex"}, {7, "Bull's Pen"}, 
        {8, "Bridge on the River Ty"}, {9, "Snow Worries"}, {10, "Outback Safari"}, {19, "Crikey's Cove"}, 
        {12, "Lyre, Lyre Pants on Fire"}, {13, "Beyond the Black Stump"}, {14, "Rex Marks the Spot"}, {15, "Fluffy's Fjord"}, 
        {20, "Cass' Pass"}, {17, "Cass' Crest"}, {23, "Final Battle"}, {16, "Credits"}
    };
    vars.level_codes = new Dictionary<int, string>
    {
        {0, "Z1"}, {1, "Z2"}, {2, "Z3"}, {3, "Z4"}, 
        {4, "A1"}, {5, "A2"}, {6, "A3"}, {7, "A4"}, 
        {8, "B1"}, {9, "B2"}, {10, "B3"}, {11, "B4"}, 
        {12, "C1"}, {13, "C2"}, {14, "C3"}, {15, "C4"}, 
        {16, "D1"}, {17, "D2"}, {18, "D3"}, {19, "D4"}, 
        {20, "E1"}, {21, "E2"}, {22, "E3"}, {23, "E4"}
    };
    vars.egg_splits = new Dictionary<string, string[]> 
    {
        {"A1", new string[] {"Collect 300 Opals", "Find 5 Bilbies", "Time Attack", "Glide the Gap", "Rang the Frills", "Rock Jump", "Super Chomp", "Lower the Platforms"}},
        {"A2", new string[] {"Collect 300 Opals", "Find 5 Bilbies", "Wombat Race", "Truck Trouble", "Bounce Tree", "Drive me Batty", "Turkey Chase", "Log Climb"}},
        {"A3", new string[] {"Collect 300 Opals", "Find 5 Bilbies", "Race Rex", "Where's Elle?", "Aurora's Kids", "Quicksand Coconuts", "Ship Wreck", "Nest Egg"}},
        {"B1", new string[] {"Collect 300 Opals", "Find 5 Bilbies", "Time Attack", "Home, Sweet, Home", "Heat Dennis' House", "Tag Team Turkeys", "TY Diving", "Neddy the Bully"}},
        {"B2", new string[] {"Collect 300 Opals", "Find 5 Bilbies", "Time Attack", "Koala Chaos", "The Old Mill", "Trap the Yabby", "Musical Icicles", "Snowy Peak"}},
        {"B3", new string[] {"Collect 300 Opals", "Find 5 Bilbies", "Race Shazza", "Emu Roundup", "Frill Frenzy", "Fire Fight", "Toxic Trouble", "Secret Thunder Egg"}},
        {"C1", new string[] {"Collect 300 Opals", "Find 5 Bilbies", "Time Attack", "Lenny the Lyrebird", "Fiery Furnace", "Water Worries", "Muddy Towers", "Gantry Glide"}},
        {"C2", new string[] {"Collect 300 Opals", "Find 5 Bilbies", "Wombat Rematch", "Koala Crisis", "Cable Car Capers", "Flame Frills", "Catch Boonie", "Pillar Ponder"}},
        {"C3", new string[] {"Collect 300 Opals", "Find 5 Bilbies", "Race Rex", "Treasure Hunt", "Parrot Beard's Booty", "Frill Boat Battle", "Geyser Hop", "Volcanic Panic"}}
    };
    vars.cog_splits = new Dictionary<string, string[]> 
    {
        {"A1", new string[] {"Julius", "Shallow Water Podium", "Wooden Platform", "Second Rang Podium", "Post-Cave Podium", "Pontoon", "Waterfall Cave", "Julius Ledge", "Bridge Ledge", "Pre-Cave Podium"}},
        {"A2", new string[] {"Start Podium 2", "Log Bridges 2", "Slide 1 Top", "Slide 1 Cave", "Valley Platform", "Slide 2 Bottom", "Log Bridges 1", "Boulders Podium", "Under Bridge", "Start Podium 1"}},
        {"A3", new string[] {"Spire Button", "Pillar Platforming", "Starting Platform", "Big Rockpool", "Geyser Platforms", "Corner Island", "Small Rockpool", "Spire Tip", "Opal Collector", "Near Sunken Ship"}},
        {"B1", new string[] {"Podium Near Start", "Behind Cobweb", "Hidden Near Start", "Spider Den Podium", "Hidden Near Dennis", "Dead Tree", "Corner Podium", "Under Large Bridge", "In Dennis' Cave", "Under Small Bridge"}},
        {"B2", new string[] {"Pillar Platforming", "Above Ice Hole", "Bottom Of Mountain", "Under Water", "Behind Sheila's House", "Centre Ice Platform", "Under Water Behind Gate", "Mountain Cave", "Hidden Right-Hand Ice", "Metal Beam"}},
        {"B3", new string[] {"Cliff Jump", "Waterfall Cave", "Tornado Hay", "Spiral Bottom Shed", "Shed Near Start", "Emu Shed", "Water Towers Shed", "Waterfalls Shed", "Spiral Bottom Hay", "On Spiral"}},
        {"C1", new string[] {"Slide Bottom Trees", "Slide Bottom Podium", "Warpflower Podium", "Ice Block", "Podium Near End", "Tree Bounce", "Log Bridge Podium", "Spy Egg Podium", "Behind Cobweb", "Broken Bridge Podium"}},
        {"C2", new string[] {"Four Pillar Alcove", "Cliff Bottom Snow Pile", "Log Bridges ", "On The Cliff Ledge", "Cliff Bottom", "Cave Spire", "Ice Block", "Corner Podium", "Warpflower", "Ski-Lift Top"}},
        {"C3", new string[] {"Underwater 1", "Air Platforms", "Skull Rock Podiums", "Sea Mines", "Underwater 2", "Two Rock Island", "Volano", "Button Air Platforms", "Anchor Island", "Warpflowers"}}
    };
    vars.bilby_splits = new Dictionary<string, string[]>
    {
        {"A1", new string[] {"Dad - Near Start", "Mum - Corner Before Julius", "Girl - Behind Cog Pillar", "Boy - Julius", "Grandma - Platforms Waterfall"}},
        {"A2", new string[] {"Dad - Under Slide 1 Top", "Mum - Valley Between Slides", "Girl - Logs Bilby 2", "Boy - Logs Bilby 1", "Grandma - In Bouncey Tree"}},
        {"A3", new string[] {"Dad - Near Aurora", "Mum - Under Nest Egg", "Girl - Side Path Near Sharks", "Boy - Spire Bottom", "Grandma - After Coconut Egg"}},
        {"B1", new string[] {"Dad - Below Mum", "Mum - Small Broken Bridge", "Girl - Under Neddy Bridge", "Boy - Cave Near Start", "Grandma - Tree Near Dennis"}},
        {"B2", new string[] {"Dad - Frill Circle Near Mum", "Mum - Behind Ice Blocks", "Girl - Ice Platforms", "Boy - Under Mill Path", "Grandma - Bottom Behind Tree"}},
        {"B3", new string[] {"Dad - Opal Collector", "Mum - Emus", "Girl - Shazza Escort Shed", "Boy - Water Towers", "Grandma - Waterfall"}},
        {"C1", new string[] {"Dad - Side Path Near End", "Mum - Warpflower Alcove", "Girl - Behind Tree Root", "Boy - Near Opal Collector", "Grandma - Under Waterfall"}},
        {"C2", new string[] {"Dad - Cobwebs Below Ski-Lift", "Mum - Under Log Bridges", "Girl - Podium Near Warpflower", "Boy - Lower Cave", "Grandma - Four Bilbies Alcove"}},
        {"C3", new string[] {"Dad - Crab Island", "Mum - Between Two Rocks", "Girl - Along Longest Island", "Boy - Above Opal Collector", "Grandma - Podium Near Geyser"}}
    };

    vars.main_stages = new List<int> { 4, 5, 6, 8, 9, 10, 12, 13, 14 };

    // Level specific settings setup.
    foreach(var level in vars.levels)
    {
        int id = level.Key;
        string name = level.Value;
        string code = vars.level_codes[id];
        settings.Add(code, true, name, "Levels");
        settings.Add(code + " entry", false, "Level Entry", code);
        settings.Add(code + " reload", false, "Level Reload", code);
        bool defaultExits = id != 0 && id != 16;
        settings.Add(code + " exit", defaultExits, "Level Exit", code);
        if(vars.main_stages.Contains(id))
        {
            settings.Add(code + " eggs", false, "Thunder Eggs", code);
            foreach(var egg_name in vars.egg_splits[code]){
                settings.Add(code + egg_name, true, egg_name, code + " eggs");
            }
            settings.Add(code + " cogs", false, "Cogs", code);
            foreach(var cog_name in vars.cog_splits[code]){
                settings.Add(code + cog_name, true, cog_name, code + " cogs");
            }
            settings.Add(code + " bilbies", false, "Bilbies", code);
            foreach(var bilby_name in vars.bilby_splits[code]){
                settings.Add(code + bilby_name, true, bilby_name, code + " bilbies");
            }
            settings.Add(code + " b5", false, "Bilby 5", code);
            settings.SetToolTip(code + " b5", "Force Split Bilby 5");
        }
    }
}



init 
{
    // Uses module memory size to determine version.
    switch (modules.First().ModuleMemorySize) 
    {
        case 5623808:
            version = "V1.44";
            vars.cogs_ptr = 0x270424;
            vars.cog_length = 0x144;
            vars.cog_id_offset = 0x6C;
            vars.cog_state_offset = 0xC4;   
            vars.eggs_ptr = 0x270280;
            vars.egg_length = 0x144;
            vars.egg_id_offset = 0x6C;
            vars.egg_state_offset = 0xC4;
            vars.bilbies_ptr = 0x27D608;
            break;
        case 3985408:
            version = "V1.11";
            vars.cogs_ptr = 0x2601C4;
            vars.cog_length = 0x140;
            vars.cog_id_offset = 0x68;
            vars.cog_state_offset = 0xC0;   
            vars.eggs_ptr = 0x260008;
            vars.egg_length = 0x140;
            vars.egg_id_offset = 0x68;
            vars.egg_state_offset = 0xC0;
            vars.bilbies_ptr = 0x26B17C;
            break; 
        default:
            version = "Unknown";
        break;
    }
}



start 
{
    if (!settings["IL"]) 
    {
        if (current.menu_index == 1 
            && current.menu_state == 0 
            && old.menu_state == 9 
            && settings[current.save_index.ToString()])
        {
            if (version == "1.44") 
            {
                if ((settings["Hardcore"] && current.hardcore) || !settings["Hardcore"])
                {
                    return true;
                }
                return false;
            } 
            return true;
        }
        return false;
    }
    if(current.menu_state == 0 && old.menu_state == 9) 
    {
        return true;
    }
    return false;
}

update
{
    // Unfreezes the timer as soon as the menu is loaded after a crash.
    if (vars.crashed && current.menu_loaded != 0)
    {
        vars.crashed = false;
    } 

    if (timer.CurrentPhase == TimerPhase.Ended) vars.finished = true;
    else if (timer.CurrentPhase == TimerPhase.Running) vars.finished = false;

    // Gets collectible states on level entry.
    if (current.loading != 0 && old.loading == 1) 
    {
        if(vars.main_stages.Contains(current.level))
        {
            IntPtr offset_cog = (IntPtr)memory.ReadValue<int>(modules.First().BaseAddress + (int)vars.cogs_ptr);
            for(int i = 0; i < 10; i++) vars.cog_states[i] = memory.ReadValue<byte>(offset_cog + (i * (int)vars.cog_length) + (int)vars.cog_state_offset);

            IntPtr offset_egg = (IntPtr)memory.ReadValue<int>(modules.First().BaseAddress + (int)vars.eggs_ptr);
            for(int i = 0; i < 8; i++) vars.egg_states[i] = memory.ReadValue<byte>(offset_egg + (i * (int)vars.egg_length) + (int)vars.egg_state_offset);

            IntPtr offset_bilby1 = (IntPtr)memory.ReadValue<int>(modules.First().BaseAddress + (int)vars.bilbies_ptr);
            IntPtr offset_bilby2 = (IntPtr)memory.ReadValue<int>(offset_bilby1);
            for(int i = 0; i < 5; i++) vars.bilby_states[i] = memory.ReadValue<byte>(offset_bilby2 + (i * 0x134) + 0x34);
        }
    }

    // Autosave start
    if (current.autosave_x > -210f && old.autosave_x < -210f) {
        vars.stopwatch1.Restart();
    }

    // Autosave end
    if (current.autosave_x < -210f && old.autosave_x > -210f) {
        vars.stopwatch1.Stop();
        vars.save_time = vars.stopwatch1.ElapsedMilliseconds;
        
        // Starting second stopwatch.
        vars.stopwatch2.Restart();
    }

    // Second stopwatch only runs if game is not paused.
    if (current.paused == 1 && vars.stopwatch2.IsRunning) vars.stopwatch2.Stop();
    if (current.paused == 0 && old.paused == 1 && !vars.stopwatch2.IsRunning) vars.stopwatch2.Start();
    
    // If second stopwatch goes over threshold (3s = 3000ms), then void the time removal.
    if (vars.stopwatch2.ElapsedMilliseconds > 3000)
    {
        vars.stopwatch1.Reset();
        vars.stopwatch2.Reset();
        vars.save_time = 0;
    }

    vars.non_pause_time = vars.stopwatch2.ElapsedMilliseconds;
}

split 
{
    // Get level codes, not necessary just cleaner.
    int current_level = current.level;
    int old_level = old.level;
    string current_code = vars.level_codes[current_level];
    string old_code = vars.level_codes[old_level];

    // On menu, allow a split when reloading into the same level if setting applied but do not allow splits whilst on menu.
    if (current.menu_index != 255) 
    {
        vars.can_split_reload = true;
        return false;
    }

    // Final Battle Any% End
    if (current.final_tali != old.final_tali 
        && current.final_tali == 1
        && settings["Any% Final"])
    {
        return true;
    }

    // Level reload logic
    if (current.loading == 0 && old.loading == 1)
    {
        if(vars.log != null) vars.log.WriteLine(timer.CurrentTime.RealTime.ToString().Split('.')[0] + " Level Entered " + current_code);
        if (!vars.can_split_first && settings[current_code + " reload"])
        {
            vars.can_split_first = true;
            return false;
        }
        vars.can_split_first = true;
        if (vars.can_split_reload && settings[current_code + " reload"]) 
        {
            vars.can_split_reload = false;
            return true;
        }
        vars.can_split_reload = false;
    }

    // Level (Entry)
    if (current_level != old_level && settings[current_code + " entry"]) 
    {    
        if(current_code == "D1" && old_code == "E4" && settings["Any% Final"]) return false;
        return true;
    }

    // Level (Exit)
    if (current_level != old_level && settings[old_code + " exit"]) 
    {
        if(old_code == "E4" && current_code == "D1" && settings["Any% Final"]) return false;
        return true;
    }

    // Game completion
    if (current.completion != old.completion && current.completion == 100 && settings["100%"])
    {
        return true;
    }

    // Opals logic
    if (current.opal_count > old.opal_count)
    {
        if(settings["All Rainbow Scales"]) return true;
        if(current.opal_count == 300 && settings["All Opals"]) return true;
    }

    // Cogs
    if (current.cog_count != old.cog_count)
    {
        for(int i = 0; i < 10; i++)
        {
            // Follow pointer
            IntPtr offset = (IntPtr)memory.ReadValue<int>(modules.First().BaseAddress + (int)vars.cogs_ptr);
            byte state = memory.ReadValue<byte>(offset + (i * (int)vars.cog_length) + (int)vars.cog_state_offset);

            // Check to see if state has changed.
            if (state > 1 && vars.cog_states[i] <= 1)
            {
                // Upddate stored state.
                vars.cog_states[i] = state;

                // Get index of collectible and name of setting.
                int index = (int)memory.ReadValue<byte>(offset + (i * (int)vars.cog_length) + (int)vars.cog_id_offset);
                string code = vars.level_codes[current.level];
                string cog_name = vars.cog_splits[code][index];

                // Write info to log file.
                vars.log.WriteLine(timer.CurrentTime.RealTime.ToString().Split('.')[0] + " Cog " + cog_name);
                
                // Split if setting is active.
                if (settings[code + cog_name])  return true;
            }

            // Upddate stored state.
            vars.cog_states[i] = state;
        }
    }

    // Thunder Eggs
    if (current.egg_count > old.egg_count)
    {
        for(int i = 0; i < 8; i++)
        {
            // Follow pointer
            IntPtr offset = (IntPtr)memory.ReadValue<int>(modules.First().BaseAddress + (int)vars.eggs_ptr);
            byte state = memory.ReadValue<byte>(offset + (i * (int)vars.egg_length) + (int)vars.egg_state_offset);

            // Check to see if state has changed.
            if (state > 1 && vars.egg_states[i] <= 1)
            {
                // Upddate stored state.
                vars.egg_states[i] = state;

                // Get index of collectible and name of setting.
                int index = (int)memory.ReadValue<byte>(offset + (i * (int)vars.egg_length) + (int)vars.egg_id_offset);
                string code = vars.level_codes[current.level];
                string egg_name = vars.egg_splits[code][index];

                // Write info to log file.
                vars.log.WriteLine(timer.CurrentTime.RealTime.ToString().Split('.')[0] + " Egg " + egg_name);

                // Split if setting is active.
                if (settings[code + egg_name]) return true;
            }

            // Upddate stored egg state.
            vars.egg_states[i] = state;
        }
    }

    // Bilbies
    if (current.bilby_count != old.bilby_count)
    {
        for(int i = 0; i < 5; i++)
        {
            // Follow pointer
            IntPtr offset1 = (IntPtr)memory.ReadValue<int>(modules.First().BaseAddress + (int)vars.bilbies_ptr);
            IntPtr offset2 = (IntPtr)memory.ReadValue<int>(offset1);
            byte state = memory.ReadValue<byte>(offset2 + (i * 0x134) + 0x34);

            // Check to see if bilby state has changed.
            if (state != 1 && vars.bilby_states[i] == 1)
            {
                // Upddate stored state.
                vars.bilby_states[i] = state;

                // Get index of collectible and name of setting.
                int index = (int)memory.ReadValue<byte>(offset2 + (i * 0x134) + 0x0);
                string code = vars.level_codes[current.level];
                string bilby_name = vars.bilby_splits[code][index];

                // Write info to log file.
                vars.log.WriteLine(timer.CurrentTime.RealTime.ToString().Split('.')[0] + " Bilby " + bilby_name);

                // Split if setting is active.
                if (settings[code + bilby_name]) 
                {
                    byte[] b_states = vars.bilby_states;

                    // Handle bilby 5 separately according to an extra setting to avoid double splitting on bilby and TE
                    if(!settings[code + " b5"] && !b_states.Any(b => b == 1)) return false;

                    return true;
                }
            }

            // Upddate stored state.
            vars.bilby_states[i] = state;
        }
    }

        // Rangs
    if(settings["Rangs"])
    {
        if (current.got_second > old.got_second && settings["Got Second Rang"]) return true;
        if (current.got_frosty > old.got_frosty && settings["Got Frostyrang"]) return true;
        if (current.got_flame > old.got_flame && settings["Got Flamerang"]) return true;
        if (current.got_kaboom > old.got_kaboom && settings["Got Kaboomerang"]) return true;
        if (current.got_doom > old.got_doom && settings["Got Doomerang"]) return true;
        if (current.got_mega > old.got_mega && settings["Got Megarang"]) return true;
        if (current.got_zoom > old.got_zoom && settings["Got Zoomerang"]) return true;
        if (current.got_infra > old.got_infra && settings["Got Infrarang"]) return true;
        if (current.got_zappy > old.got_zappy && settings["Got Zappyrang"]) return true;
        if (current.got_aqua > old.got_aqua && settings["Got Aquarang"]) return true;
        if (current.got_multi > old.got_multi && settings["Got Multirang"]) return true;
        if (current.got_chrono > old.got_chrono && settings["Got Chronorang"]) return true;
    }

    return false;

}



reset 
{
    return current.menu_index == 1 && current.menu_state == 9 && old.menu_state != 9;
}



isLoading 
{
    return (current.loading == 1 && current.menu_index == 255) || vars.crashed;
}



exit
{
    vars.crashed = true;
    timer.IsGameTimePaused = true;
}



gameTime
{
    // This is disgusting but it is the only way I could think of to prevent removal of autosave from hub 2 levels any%
    if ((current.prev_level != 0 || (current.level == 0 && current.prev_level == 0))
        && (current.level != old.level || old.prev_level == 24 && current.prev_level != 24)
        && vars.save_time != 0)
    {
        vars.log.WriteLine(current.prev_level + " " + current.level);
        vars.log.WriteLine(vars.save_time + "ms Autosave Removed");
        timer.SetGameTime(timer.CurrentTime.GameTime - TimeSpan.FromMilliseconds(vars.save_time));
        vars.save_time = 0;
    }
}

onStart
{
    // Prevents time removal on first load.
    vars.save_time = 0;

    // Setup new log file.
    if(!Directory.Exists("./Components/TyLogs")) Directory.CreateDirectory("./Components/TyLogs");
    DirectoryInfo directory = new DirectoryInfo("./Components/TyLogs");
    FileInfo oldestFile = directory.GetFiles()
        .OrderBy(file => file.LastWriteTime)
        .FirstOrDefault();
    if(Directory.GetFiles("./Components/TyLogs").Count() >= 250)
    {
        oldestFile.Delete();
    }
    DateTime currentTime = DateTime.UtcNow;
    long unixTime = ((DateTimeOffset)currentTime).ToUnixTimeSeconds();
    vars.log_path = Path.Combine("./Components/TyLogs/", unixTime.ToString() + ".txt");
    var fs =  File.Create(vars.log_path);
    vars.log = new StreamWriter(fs);
    vars.log.WriteLine(unixTime + "\n");

    int xhash = 0;
    int number = (int)unixTime;
    while (number != 0)
    {
        xhash += number % 10;
        number /= 10;
    }

    int fileCount = 0;
    string moduleDirectory = System.IO.Path.GetDirectoryName(modules.First().FileName);

    vars.log.WriteLine("BASE");
    foreach(string file in Directory.GetFiles(moduleDirectory)) 
    {
        if(!file.EndsWith(".mdmp"))
        {
            vars.log.WriteLine("  " + Path.GetFileName(file));
            fileCount++;
        }
    }

    if(Directory.Exists(Path.Combine(moduleDirectory, "PC_External")))
    {
        vars.log.WriteLine("\nEXTERNAL");
        foreach(string file in Directory.GetFiles(Path.Combine(moduleDirectory, "PC_External"), "*", SearchOption.AllDirectories))
        {
            vars.log.WriteLine("  " + Path.GetFileName(file));
            fileCount++;
        } 
    }

    if(Directory.Exists(Path.Combine(moduleDirectory, "PC_Specific")))
    {
        vars.log.WriteLine("\nSPECIFIC");
        foreach(string file in Directory.GetFiles(Path.Combine(moduleDirectory, "PC_Specific"), "*", SearchOption.AllDirectories)) 
        {
            vars.log.WriteLine("  " + Path.GetFileName(file));
            fileCount++;
        }
    }
    vars.log.WriteLine("\n#" + modules.First().ModuleMemorySize * fileCount + "#");
    number = modules.First().ModuleMemorySize * fileCount;
    while (number != 0)
    {
        xhash += number % 10;
        number /= 10;
    }

    string[] filesToCheck = {
            "Data_PC.rkv",
            "Video_PC.rkv",
            "Music_PC.rkv",
            "Override_PC.rkv"
        };

    foreach (string fileName in filesToCheck)
    {
        string filePath = Path.Combine(moduleDirectory, fileName);
        if (File.Exists(filePath))
        {
            FileInfo fileInfo = new FileInfo(filePath);
            vars.log.WriteLine("*" + fileInfo.Length + "*");
            number = (int)fileInfo.Length;
            while (number != 0)
            {
                xhash += number % 10;
                number /= 10;
            }
        }
    }

    using (FileStream stream = File.OpenRead(Path.Combine(moduleDirectory, "TY.exe")))
    {
        System.Security.Cryptography.SHA256 sha256 = System.Security.Cryptography.SHA256.Create();
        byte[] hashBytes = sha256.ComputeHash(stream);
        vars.log.WriteLine("@" + BitConverter.ToString(hashBytes).Replace("-", "").ToLower());
        foreach(byte b in hashBytes) xhash += (int)b;
    }
    
    vars.log.WriteLine("$" + xhash);
    vars.log.WriteLine();
}



onReset
{
    // Release log file.
    try
    {
        vars.log.Close(); 
    }
    catch
    {

    }

    if(vars.finished)
    {
        if(!Directory.Exists("./Components/TyLogs/FinishedRuns")) Directory.CreateDirectory("./Components/TyLogs/FinishedRuns");
        File.Copy(vars.log_path, Path.Combine("./Components/TyLogs/FinishedRuns", Path.GetFileName(vars.log_path)));
    }
}


/*
Thank you for reading through my code!
Thank you Lawn for talking through the miserable parts of this code with me.
Thank you Rythin for the headstart with the original ASL file.
- Matt :)
*/
