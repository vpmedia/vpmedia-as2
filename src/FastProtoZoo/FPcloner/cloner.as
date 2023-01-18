//###########################################################
//#### MAKO FastProtoZoo Components #########################
//#### email marcosangalli@hotmail.com ######################
//###########################################################
import FastProtoZoo.FPcloner.clonerItem;
//
class FastProtoZoo.FPcloner.cloner{
	//
	function cloner(){
	}
	//clone Array
	static function clone(original:Array):Array{
		var temp=new clonerItem();
		return(temp.clone(original));
	}
}