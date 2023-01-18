//****************************************************************************
//Copyright (C) 2003-2005 Macromedia, Inc. All Rights Reserved.
//The following is Sample Code and is subject to all restrictions on
//such code as contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import mx.transitions.BroadcasterMX;

class net.manaca.ui.transitions.OnEnterFrameBeacon {

	#include "Version.as"

	static function init () {
		var gmc = _global.MovieClip;
		if (!_root.__OnEnterFrameBeacon) {
			BroadcasterMX.initialize (gmc);
			//这里存在一个bug，如果你设置一个深度为98765321的元件，则会出错
			var mc = _root.createEmptyMovieClip ("__OnEnterFrameBeacon", 98765321);
			mc.onEnterFrame = function () {  _global.MovieClip.broadcastMessage ("onEnterFrame"); };
		}
	}
};
