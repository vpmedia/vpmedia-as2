import com.architekture.controls.layout.*;
/* Copyright (C) 2005, Allen Ellison
	Portions copyright University of Maryland
	Portions coyright Architekture.com
	
	Freely distributable and usable for commercial and non-commercial applications.  No warrantee implied, etc.
	Please give credit where credit is due.
*/

class com.architekture.tests.mapTest extends mx.core.UIComponent {
	

	private var colors = [0xE09E9E,0xAEAFFB,0xA0E49A,0xD9F788,0xF0C988,0xBDE296,0x9AB9D8,0xB1A0D1,0xC29697,0xBECA8E,0x98C09C,0x97AAC1,0xA398C0,0xAEAFFB,0xA0E49A,0xD9F788];


	function mapTest() {
		super();
	}
	
	function init() {
		super.init();
		
		var numMaps:Number = 3+random(10);
		var maps:Array = new Array();
		
		for(var i=0;i<numMaps;i++) {
			var map = new Array();
			map.label=createRandomLabel();
			map.ceiling = random(100)+20;
			var numMapItems:Number = random(50);
			for(var j=0;j<numMapItems;j++) {
				var mapItem = {label:createRandomLabel(),size:5+random(map.ceiling)};
				map.push(mapItem);
			}
			maps.push(map);
		}
//		var map = [map_a,map_b,map_c,map_d];
		
		for(var i=0;i<maps.length;i++) {
			maps[i].size = calcUberSize(maps[i]);
		}
		

		_global.fillColor(0x444444);
		_global.strokeWidth = 5;
		SquarifiedLayout.squareLayout(maps,{x:10,y:10,w:1000-30,h:1000-30});
		_global.strokeWidth = 2;
		layoutChildren(maps);
		
		for(var i=0;i<maps.length;i++) {
			var m = maps[i];
		/*	m.fillColor = colors[i];
			m.indent = 0;
			var item = attachMovie("mapItem","item_"+i,100+i,m);
			item._alpha = 30;
		*/	
			for(var j=0;j<m.length;j++) {
				var n = m[j];
				n.fillColor = blendColors(colors[i],0xFFFFFF,Math.random()/2);
				n.fillColor2 = blendColors(n.fillColor,0x000000,.2);
				n.highlightColor = blendColors(n.fillColor,0xFFFFFF,.2);
				n.strokeColor = 0x555555;
				n.reference = attachMovie("mapItem","subItem_"+i+"_"+j,1000+1000*i+j,n);
			}
		}
		updateAfterEvent();

		trace("getTimer: "+getTimer());
	}

	// blendColors function courtesy of giles@roadnight.name
	
	function blendColors(colorA, colorB, amtB){
		//trace("blendColors: " + getTimer());
		// colorA - background color
		// colorB - foreground color
		// amtB amount of colorB to add (range 0.0 to 1.0)
	
		// in case your colors are hex strings ?
		colorA = Number(colorA);
		colorB = Number(colorB);
	
		// get colorA components
		var rA = (colorA >> 16) & 0xFF;
		var gA = (colorA >> 8) & 0xFF;
		var bA = colorA & 0xFF;
	
	   // get colorB components
		var rB = (colorB >> 16) & 0xFF;
		var gB = (colorB >> 8) & 0xFF;
		var bB = colorB & 0xFF;
	
	   // calculate colorC components
		var rC = Math.floor(rA*(1-amtB) + rB*amtB);
		var gC = Math.floor(gA*(1-amtB) + gB*amtB);
		var bC = Math.floor(bA*(1-amtB) + bB*amtB);
	
	   //var colorC = (rC <<16)+(gC << 8)+(bC);
		var colorC = "0x" + String(rC.toString(16)+gC.toString(16)+bC.toString(16)).toUpperCase();
		return colorC;
	}	
	
	function createRandomLabel() {
		var s:String = "abcdefghijklmnopqrstuvwxyz";
		var slen = s.length;
		var len:Number = random(2)+2;
		var rs:String="";
		for(var i=0;i<len;i++) {
			rs+=s.substr(random(slen),1);
		}
		return rs;
	}
	
	function calcUberSize(map) {
		var size:Number = 0;
		for(var i=0;i<map.length;i++) {
			size+=map[i].size;
		}
		return size;
	}
	
	function layoutChildren(map) {
		for(var i=0;i<map.length;i++) {
			_global.fillColor = colors[i];
			var bounds = {x:map[i].bounds.x+5,y:map[i].bounds.y+5,w:map[i].bounds.w-5,h:map[i].bounds.h-5};
			SquarifiedLayout.squareLayout(map[i],bounds);
		}
	}

}