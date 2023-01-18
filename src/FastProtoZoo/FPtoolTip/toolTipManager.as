//###########################################################
//#### MAKO FastProtoZoo Components #########################
//#### email marcosangalli@hotmail.com ######################
//###########################################################
//ToolTip manager: create a single toolTip instance
import FastProtoZoo.FPtoolTip.toolTip;
//
class FastProtoZoo.FPtoolTip.toolTipManager{
	//
	static var enabled:Boolean=false;
	//
	static function init(fadertime:Number):Void{
		//create single tip instance
		if (!enabled){
			_root.attachMovie(toolTip.symbolName,"FPtoolTipContainer",95000,{fadertime:fadertime});
		}
		//enable all
		enabled=true;
	}
	//
	static function showTip(message:String):Void{
		if (enabled && message!="" && message!=undefined){
			_root.FPtoolTipContainer.showTip(message);
		}
	}
	//
	static function hideTip():Void{
		if (enabled){
			_root.FPtoolTipContainer.hideTip();
		}
	}
	//fast create tip engine over owner
	static function createTip(owner:Object,message:String):Void{
		if (enabled){
			owner.onRollOver=function(){
				_root.FPtoolTipContainer.showTip(message);
			}
			owner.onRollOut=owner.onReleaseOutside=function(){
				_root.FPtoolTipContainer.hideTip();
			}
		}
	}
	//set new tip style
	static function setStyle(style:TextField.StyleSheet):Void{
		_root.FPtoolTipContainer.setStyle(style);
	}
	//disable style change
	static function set setStyleBlock(block:Boolean):Void{
		_root.FPtoolTipContainer.setStyleBlock(block);
	}
	static function get setStyleBlock():Boolean{
		return(_root.FPtoolTipContainer.getStyleBlock());
	}
}