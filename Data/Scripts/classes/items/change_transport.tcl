$start
$after
def_class Holzkiepe wood transport 1 {} {

$put

	method recycle {user} {
		tasklist_add $user "recycle [get_ref this]"
	}

$end


$start
$after
def_class Grosse_Holzkiepe wood transport 1 {} {

$put

	method recycle {user} {
		tasklist_add $user "recycle [get_ref this]"
	}

$end


$start
$after
def_class Schubkarren wood transport 1 {} {

$put

	method recycle {user} {
		tasklist_add $user "recycle [get_ref this]"
	}

$end


$start
$after
def_class Hoverboard metal tool 2 {} {

$put

	method recycle {user} {
		tasklist_add $user "recycle [get_ref this]"
	}

$end


$start
$after
def_class Reithamster wood tool 2 {} {

$put

	method recycle {user} {
		tasklist_add $user "recycle [get_ref this]"
	}
	method recycle_whitelist {} {
		return {Hamster}
	}

$end