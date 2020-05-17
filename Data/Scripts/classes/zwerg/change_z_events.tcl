$start
$before

	def_event evt_task_useitem
$put

	def_event evt_task_recycle

$end


$start
$before

	handle_event evt_task_useitem {
	
$put

	handle_event evt_task_recycle {
		evt_task_recycle_proc
	}

$end

$start
$before

	// Benutzten von Items
$put
	proc evt_task_recycle_proc {} {
		global event_log
		global last_event event_repeat last_userevent_time

		if {$event_log} {
			log "[get_objname this] getting event EVT_TASK_RECYCLE"
		}

		set evtitem [event_get this -subject1]
		if {[obj_valid $evtitem] == 0} {
			return
		}

		//remove all tasks
		gnome_failed_work this
		tasklist_clear this
		kill_all_ghosts
		stop_prod
		state_triggerfresh this task

		set this_event "recycle $evtitem"
		if {$this_event==$last_event} {set event_repeat 1}
		set last_event $this_event
		notify_userevent

		//set icons
		set_objworkicons this recycling [get_objclass $evtitem]
		
		//change hat
		prod_change_muetze metal
		
		//go to item and pick it up when not already in inventory
		if {[inv_find_obj this $evtitem] < 0} {
			pickup $evtitem
		}

		//recycle it
		tasklist_add this "recycle $evtitem"
	}


$end