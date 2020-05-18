$start
$before

// Zwerg trinkt den angegebenen Trank Referenz
$put
//get the materials of a given item from the techtree
//returns {} when no recipe was found
proc get_materials {item_ref} {
	set objclass [get_objclass $item_ref]
	set tttsection_tocall $objclass
	call scripts/misc/techtreetunes.tcl
	return [subst \$tttmaterial_$objclass]
}

//dwarf recycles the given item if a crafting recipe is defined in techtree
//should be called by the recycle method of an item (which should be called by the use method of this item!)
proc recycle {item_ref} {
	if {![obj_valid $item_ref]} {
		tasklist_add this "rotate_tofront"
		tasklist_add this "play_anim dontknow"
		return 0
	}
	
	//do animated recycling
	if {[get_materials $item_ref] != {}} {
		//dust particles
		change_particlesource this 5 19 {0 0 0.5} {0.5 0 0.5} 48 2 0 2
		set_particlesource this 5 0
		//chip particles
		change_particlesource this 6 26 {0 0 0.5} {0 0 0} 32 1 0 2
		set_particlesource this 6 0

		//when stored in storage - pickup
		if {[get_instore $item_ref]} {
			pickup_from_store $item_ref
		}
		//drop item when in inventory
		if {[inv_find_obj this $item_ref] != -1 || [get_instore $item_ref]} {
			tasklist_add this "play_anim [putdown_anim]"
			tasklist_add this "beamto_world $item_ref [random 6.282]"
		}
		
		tasklist_add this "walk_near_item $item_ref 0.6 0.2"
		tasklist_add this "rotate_towards $item_ref"
		
		tasklist_add this "set_particlesource this 5 1"
		tasklist_add this "set_particlesource this 6 1"
		tasklist_add this "play_anim workatfloor"
		tasklist_add this "set_particlesource this 6 0"
		tasklist_add this "set_particlesource this 5 0"
		tasklist_add this "free_particlesource this 5"
		tasklist_add this "free_particlesource this 6"
		
		tasklist_add this "recycle_intern $item_ref"
		return 1
	} else {
		tasklist_add this "rotate_tofront"
		tasklist_add this "play_anim dontknow"
		return 0
	}
}

//should only be called by tasklist
proc recycle_intern {item_ref} {
	if {![obj_valid $item_ref] || [is_contained $item_ref] || [get_lock $item_ref]} {
		play_anim dontknow
		return 0
	}

	//materials which cannot be recycled
	set blacklist {Hamster Kohle Zipfelmuetze}
	//get item specific blacklisted materials
	if {[check_method [get_objclass $item_ref] recycle_blacklist]} {
		set blacklist [concat $blacklist [call_method $item_ref recycle_blacklist]]
	}
	
	//materials which must be recycled
	set whitelist {}
	//get item specific whitelisted materials
	if {[check_method [get_objclass $item_ref] recycle_whitelist]} {
		set whitelist [concat $whitelist [call_method $item_ref recycle_whitelist]]
	}
	
	//materials which should be replaced by other materials. Format: {{Eisen Eisenerz} {Gold Golderz} ...}
	set replacements {}
	//get item specific material replacements
	if {[check_method [get_objclass $item_ref] recycle_replacements]} {
		set replacements [concat $replacements [call_method $item_ref recycle_replacements]]
	}

	//get materials
	set materials [get_materials $item_ref]
	
	//do recycling
	set items_generated 0
	if {$materials != {}} {
		set position [get_pos $item_ref]
		//remove all items from item inventory (Storage or something similar)
		catch {
			foreach item [inv_list $item_ref] {
				inv_rem $item_ref $item
				set_visibility $item 1
				set_physic $item 1
				set_hoverable $item 1
				set_instore $item 0
				set_prodalloclock $item 0
				set_lock $item 0
				if {[get_objclass $item] == "Schatzbuch"} {
					call_method $item initiate $position
				} else {
					set_posbottom $item [vector_fix $position]
				}
				from_wall $item
			}
		}
		
		//delete item
		set_hoverable $item_ref 0
		set_visibility $item_ref 0
		del $item_ref
		
		//drop materials
		foreach item_class $materials {
			//get a material when whitelisted or (when not blacklisted with a chance) 
			if {[lsearch $whitelist $item_class] > -1 || ([lsearch $blacklist $item_class] == -1 && [random 100] < $print:CHANCE)} {
				set replace_class $item_class
				//replace item class when defined
				foreach replacement $replacements {
					if {[lindex $replacement 0] == $item_class} {
						set replace_class [lindex $replacement 1]
					}
				}
				set obj [new $replace_class]
				set_pos $obj $position
				set_owner $obj $position
				set_roty $obj [random 6.282]
				incr items_generated
			}
		}
	}
	
	//if no item was generated - play animation
	if {$items_generated < 1} {
		play_anim dontknow
	}
}



$end


$if:INGOTS_TO_ORE

$start
$replace
	set replacements {}
$with
	set replacements {
		{Eisen Eisenerz}
		{Gold Golderz}
		{Kristall Krisallerz}
	}
$end

$ifend