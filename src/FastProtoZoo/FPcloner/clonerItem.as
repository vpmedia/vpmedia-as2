//###########################################################
//#### MAKO FastProtoZoo Components #########################
//#### email marcosangalli@hotmail.com ######################
//###########################################################
class FastProtoZoo.FPcloner.clonerItem{
	//
	function clonerItem(){}
	//
	public function clone(original:Object):Object{
		//dispatch instanceof
		//trace("---"+typeof(original)+"_"+original);
		//
		//DISPATCH
		if (typeof(original)=="undefined"){
			var cloned=undefined;
		}else if (typeof(original)=="null"){
			var cloned=null;
		}else{
			//ARRAY
			if (original instanceof Array){
				var cloned=new Array();
				//
				for (var p=0;p<original.length;p++){
					//instantiate a new clonerItem
					var temp=new clonerItem();
					cloned.push(temp.clone(original[p]));
				}
			//TEXTFORMAT
			}else if (original instanceof TextFormat){
				var cloned=new TextFormat();
				//
				for (var p in original){
					//instantiate a new clonerItem
					var temp=new clonerItem();
					cloned[p]=temp.clone(original[p]);
				}
			//STRING
			}else if (typeof(original)=="string"){
				var cloned=new String();
				cloned=original;
			//NUMBER
			}else if (typeof(original)=="number"){
				var cloned=new Number();
				cloned=original;
			//BOOLEAN
			}else if (typeof(original)=="boolean"){
				var cloned=new Boolean();
				cloned=original;
			//OBJECT
			}else if (typeof(original)=="object"){
				//create Object container
				var cloned=new Object();
				//clone child
				for (var p in original){
					//instantiate a new clonerItem
					var temp=new clonerItem();
					cloned[p]=temp.clone(original[p]);
				}
			//REFERENCE
			}else if (typeof(original)=="movieclip"){
				//reference it only
				var cloned=new Object();
				cloned=original;
			//FUNCTION
			}else if (typeof(original)=="function"){
				//reference it only
				var cloned=new Function();
				cloned=original;
			}
		}
		//cloned
		return(cloned);
	}
}