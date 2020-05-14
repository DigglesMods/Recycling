$start
$after
def_class Presslufthammer metal tool 3 {} {

$put

	method use {user} {
		call_method this recycle $user
	}
	method recycle {user} {
		tasklist_add $user "recycle [get_ref this]"
	}

$end


$start
$after
def_class Kettensaege metal tool 3 {} {

$put

	method use {user} {
		call_method this recycle $user
	}
	method recycle {user} {
		tasklist_add $user "recycle [get_ref this]"
	}

$end


$start
$after
def_class Kristallstrahl energy tool 4 {} {

$put

	method use {user} {
		call_method this recycle $user
	}
	method recycle {user} {
		tasklist_add $user "recycle [get_ref this]"
	}

$end
