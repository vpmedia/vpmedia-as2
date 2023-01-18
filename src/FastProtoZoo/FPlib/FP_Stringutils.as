//###########################################################
//#### MAKO FastProtoZoo Components #########################
//#### email marcosangalli@hotmail.com ######################
//###########################################################
class FastProtoZoo.FPlib.FP_Stringutils extends Object {
	//
	function FP_Stringutils() {
	}
	//fast replace method
	static function searchAndReplace(source:String, search:String, replace:String):String {
		return source.split(search).join(replace);
	}
	//search and replace by charCode
	static function searchAndReplaceCharCode(source:String, search:Number, replace:String):String {
		//split into an array
		var temp=source.split("");
		//iterate and replace if found
		for (var i=0;i<temp.length;i++){
			//trace("char: "+temp[i]+" code: "+temp[i].charCodeAt(0));
			if (temp[i].charCodeAt(0)==search){
				temp[i]=replace;
			}
		}
		//return a string
		return temp.join("");
	}
}
