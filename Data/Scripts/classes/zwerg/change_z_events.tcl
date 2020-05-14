$start
$before

	def_event evt_task_useitem
$put

	def_event evt_task_recyclebuilding

$end


$start
$before

	handle_event evt_task_useitem {
	
$put

	handle_event evt_task_recyclebuilding {
		evt_task_recyclebuilding_proc
	}

$end

$start
$before

	// Benutzten von Items
$put
	proc evt_task_recyclebuilding_proc {} {
		global event_log
		global last_event event_repeat last_userevent_time

		if {$event_log} {
			log "[get_objname this] getting event EVT_TASK_RECYCLEBUILDING"
		}

		set evtitem [event_get this -subject1]
		if {[obj_valid $evtitem] == 0} {
			return
		}

		gnome_failed_work this
		tasklist_clear this
		kill_all_ghosts
		stop_prod
		state_triggerfresh this task

		set this_event "recyclebuilding $evtitem"
		if {$this_event==$last_event} {set event_repeat 1}
		set last_event $this_event
		notify_userevent

		if {[inv_find_obj this $evtitem] < 0} {
			pickup $evtitem
		}

		tasklist_add this "recycle $evtitem"

		set_objworkicons this [get_objclass $evtitem]
	}


$end