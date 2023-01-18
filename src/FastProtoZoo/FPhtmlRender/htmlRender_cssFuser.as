//###########################################################
//#### MAKO FastProtoZoo Components #########################
//#### email marcosangalli@hotmail.com ######################
//###########################################################
//
//styles if a Object containing two different sub object: _css and _style
//_style object is not been implemented for now
//
class FastProtoZoo.FPhtmlRender.htmlRender_cssFuser{
	//
	private var fused:Object;
	//
	function htmlRender_cssFuser(){

	}
	//
	public function doFusion(pieces:Array):Object{
		//assign the fist css
		this.fused=pieces[0];
		//fusion
		for (var k=1;k<pieces.length;k++){
			var styles=pieces[k];
			//
			var styleNames_array:Array = styles.getStyleNames();
			//
			for (var i = 0; i<styleNames_array.length; i++) {
				//search for duplicates
				var styleName_str:String = styleNames_array[i];
				var styleObject:Object = styles.getStyle(styleName_str);
				//
				for (var propName in styleObject) {
					var propValue = styleObject[propName];
					//##########################################################################
					var found=this.findClass(styleName_str);
					//if not in style create a new container
					if (!found){
						this.fused._css[styleName_str]=new Object();
					}
					this.fused._css[styleName_str][propName]=propValue
					//##########################################################################
				}
			}
		}
		//return fused css
		return(this.fused);
	}
	//
	private function findClass(cls:String):Boolean{
		var styleNames_array:Array = this.fused.getStyleNames();
		//
		for (var i = 0; i<styleNames_array.length; i++) {
			var styleName_str:String = styleNames_array[i];
			if (styleName_str==cls){
				return(true);
			}
		}
		//
		return (false);
	}
}
