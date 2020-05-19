$start
$before

	def_event evt_task_useitem
$put

	def_event evt_task_recycle
	def_event evt_task_recyclebuilding

$end


$start
$before

	handle_event evt_task_useitem {
	
$put

	handle_event evt_task_recycle {
		evt_task_recycle_proc
	}
	handle_event evt_task_recyclebuilding {
		evt_task_recyclebuilding_proc
	}

$end

$start
$before

	// Benutzten von Items
$put
	proc recycle_preparation {} {
		global event_log
		global last_event event_repeat last_userevent_time

		if {$event_log} {
			log "[get_objname this] getting event EVT_TASK_RECYCLE"
		}

		set evtitem [event_get this -subject1]
		if {[obj_valid $evtitem] == 0} {
			return -1
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
		
		return $evtitem
	}

	proc evt_task_recycle_proc {} {
		set evtitem [recycle_preparation]
		if {$evtitem >= 0} {
			//recycle it
			tasklist_add this "call_method $evtitem recycle [get_ref this]"
		}
	}
	proc evt_task_recyclebuilding_proc {} {
		set evtitem [recycle_preparation]
		if {$evtitem >= 0} {
			//recycle it
			tasklist_add this "call_method $evtitem recycle_building [get_ref this]"
			log "after task"
		}
	}


$end