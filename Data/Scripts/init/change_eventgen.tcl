$start
$before
if {[check_method $subclass use]} {
$put

if {[check_method $subclass recycle]} {
				evtgen_attrib -evtid evt_task_recycle -subject1 $subpar -pos1 $pospar -cursor [lmsg "use"] -desc "[lmsg recycle]"
				return "use"
			} else
$end


$start
$after
		if {[get_boxed $subpar]} {
			if {$isininv} {

$put

				if {$alternate} {
					evtgen_attrib -evtid evt_task_recycle -subject1 $subpar -pos1 $pospar -cursor [lmsg "use"] -desc "[lmsg recycle]"
					return "use"
				}

$end