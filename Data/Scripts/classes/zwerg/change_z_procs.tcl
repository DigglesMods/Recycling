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
		return 0
	}
	if {[inv_find_obj this $item_ref] == -1} {
		return 0
	}
	
	//do animated recycling
	tasklist_add this "rotate_tofront"
	if {[get_materials $item_ref] != {}} {
		tasklist_add this "play_anim workatfloor"
		tasklist_add this "recycle_intern $item_ref"
		return 1
	} else {
		tasklist_add this "play_anim dontknow"
		return 0
	}
}

//should only be called by tasklist
proc recycle_intern {item_ref} {
	//materials which cannot be recycled
	set blacklist {Hamster Kohle}
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
	
	//material which should be replaced by another material
	set replacements {
		{Eisen Eisenerz}
		{Gold Golderz}
		{Kristall Krisallerz}
	}
	//get item specific material replacements
	if {[check_method [get_objclass $item_ref] recycle_replacements]} {
		set replacements [concat $replacements [call_method $item_ref recycle_replacements]]
	}

	//get materials
	set materials [get_materials $item_ref]
	
	//do recycling
	set items_generated 0
	if {$materials != {}} {
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
				set_pos $item [get_pos this]
			}
		}
		
		//delete item
		del $item_ref
		
		//drop materials
		foreach item_class $materials {
			//get a material when whitelisted or (when not blacklisted with a chance) 
			if {[lsearch $whitelist $item_class] > -1 || ([lsearch $blacklist $item_class] == -1 && [random 100] < 75)} {
				set replace_class $item_class
				//replace item class when defined
				foreach replacement $replacements {
					if {[lindex $replacement 0] == $item_class} {
						set replace_class [lindex $replacement 1]
					}
				}
				set obj [new $replace_class]
				set_pos $obj [get_pos this]
				set_owner $obj [get_owner this]
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
