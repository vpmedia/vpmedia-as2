class janumedia.podAssets.podbgtype5 extends MovieClip{
	var left,center,right:MovieClip
	function podbgtype5(){
		this.useHandCursor = false;
		this.onPress = function(){ return; }
		this.attachMovie("pod_asset_mid_whitebg_left","left",0);
		this.attachMovie("pod_asset_mid_whitebg_center","center",1);
		this.attachMovie("pod_asset_mid_whitebg_right","right",3);
		center._x = left._x + left._width;
	}
	function setSize(w:Number,h:Number){
		right._x = w;
		center._width = w - right._width - left._width + 1;
		left._height = center._height = right._height = h;
	}
}