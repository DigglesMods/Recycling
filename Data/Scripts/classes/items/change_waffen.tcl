$start
$after
def_class Steinschleuder wood tool 1 {} {

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
def_class PfeilUndBogen wood tool 1 {} {

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
def_class Schild wood tool 1 {} {

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
def_class Schwert metal tool 1 {} {

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
def_class Metallschild metal tool 2 {} {

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
def_class Buechse metal tool 3 {} {

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
def_class Lichtschwert energy tool 4 {} {

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
def_class Kristallschild metal tool 4 {} {

$put

	method use {user} {
		call_method this recycle $user
	}
	method recycle {user} {
		tasklist_add $user "recycle [get_ref this]"
	}

$end


$start
$before

SetWeaponClasses {
$put

def_class Keule metal tool 0 {} {
	call scripts/misc/animclassinit.tcl
	class_defaultanim keule.standard
	class_physic 1
	class_viewinfog 1
	method is_weapon {} {}
	method destroy {} { del this }
	method use {user} {
		call_method this recycle $user
	}
	method recycle {user} {
		tasklist_add $user "recycle [get_ref this]"
	}
	obj_init {
		set_selectable 	this 1
		set_hoverable 	this 1
		set_storable 	this 1
	}
}

def_class Streitaxt metal tool 0 {} {
	call scripts/misc/animclassinit.tcl
	class_defaultanim streitaxt.standard
	class_physic 1
	class_viewinfog 1
	method is_weapon {} {}
	method destroy {} { del this }
	method use {user} {
		call_method this recycle $user
	}
	method recycle {user} {
		tasklist_add $user "recycle [get_ref this]"
	}
	obj_init {
		set_selectable 	this 1
		set_hoverable 	this 1
		set_storable 	this 1
	}
}


$end

$start
$replace
{Keule 			keule}
$with
$end

$start
$replace
{Streitaxt		streitaxt}
$with
$end