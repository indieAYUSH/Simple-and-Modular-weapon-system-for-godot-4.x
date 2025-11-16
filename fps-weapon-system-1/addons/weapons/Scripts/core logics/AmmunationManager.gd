extends Node3D
class_name  AmmunationManager



var reserved_ammo : Dictionary = {"shell"  : 30 , "riffle" : 180 , "smg" : 120 , "sniper" : 60 , "grenade" : 15 , "magnum" : 18}
var max_ammo : Dictionary = {"shell"  : 60 , "riffle" : 220 , "smg" : 180 , "sniper" : 90 , "grenade" : 30 , "magnum" : 18}



func ammo_refil(amt : int , key:String):
	var addition_amt = min( amt , max_ammo[key]-reserved_ammo[key] , 0)
	if addition_amt > 0:
		reserved_ammo[key] += amt
	else:
		print("ammo full")
