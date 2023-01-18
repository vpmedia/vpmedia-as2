//###########################################################
//#### MAKO FastProtoZoo Components #########################
//#### email marcosangalli@hotmail.com ######################
//###########################################################
import FastProtoZoo.FPlib.FP_Stringutils;
//
class FastProtoZoo.FPhtmlRender.htmlRender_htmlFix extends Object {
	//
	function htmlRender_htmlFix() {
	}
	//
	static function fix(source:String):String {
		//fix
		source+=" ";
		source=FP_Stringutils.searchAndReplace(source,">,<","><");
		source=FP_Stringutils.searchAndReplace(source,"</p>","<br/><br/>");
		//slit the string into an array
		var temp = new Array();
		temp = source.split('');
		var result = new Array();
		//loop the array
		for (var i = 0; i<temp.length; i++) {
			if (temp[i].charCodeAt(0) != 13 && temp[i].charCodeAt(0) != 10 && temp[i].charCodeAt(0) != 160) {
				//fix the child node structure
				 if (temp[i] == " ") {
					result.push(" ");
					//skip spaces
					var j=1;
					while(temp[i+j]==" "){
						j++;
					}
					i +=( j-1);
				}else if (temp.slice(i, i+2).join('')== "<p") {
					//skip p tag
					var j=1;
					while(temp[i+j]!=">"){
						j++;
					}
					i +=j;
				}else{
					result.push(temp[i]);
				}
			}
		}
		//join characters into a single string
		var output = result.join('');
		//fixing
		output=FP_Stringutils.searchAndReplace(output,"<br /> ","<br/>");
		//
		return (output);
	}
}
