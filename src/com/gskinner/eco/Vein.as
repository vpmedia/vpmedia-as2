﻿/*eco.Vein by Grant Skinner, http://gskinner.com/You may distribute this class as long as you give appropriate credit, and this comment block remains intact.Visit gskinner.com for more Flash news, information, and source code.*/import com.gskinner.eco.VeinManager;class com.gskinner.eco.Vein extends MovieClip {// constants:	public static var MAX_THICKNESS=5;	// public properties:	public var x:Number=0;	public var y:Number=0;	// private properties:	private var angle:Number=0;	private var thickness:Number;	private var count:Number=0;	private var originalThickness;	private var manager:VeinManager;	// constructor:	private function Vein() {		lineStyle(thickness,0x770000+(MAX_THICKNESS-thickness)*35,30+thickness/MAX_THICKNESS*70);		originalThickness = thickness;		onEnterFrame = grow;	}	// private methods:	private function grow():Void {		var t:Number = MAX_THICKNESS-thickness+1;		angle += Math.PI/180*(random(t*20)-t*10);		var length:Number = random(7)+t+2;		x += length*Math.cos(angle);		y += length*Math.sin(angle);		lineTo(x,y);				if (thickness > 1 && random(((thickness==MAX_THICKNESS) ? 6 : 2.3*thickness)) == 1) {			manager.createVein(thickness-1-random(thickness-1),_x+x,_y+y,angle);		}				if (thickness < MAX_THICKNESS && count > random(22)*thickness) {			count = 0;			lineStyle(--thickness,0x770000+t*35,30+thickness/MAX_THICKNESS*70);			if (thickness == 0) { count = 130+originalThickness*30; onEnterFrame = fadeDown; }		} else {			count++;		}				if (thickness == MAX_THICKNESS) {			if (count == 10) {				var d:Number = _root.nextDepth = (++_root.nextDepth)%1000;				manager.createVein(thickness,_x+x,_y+y,angle);				count = 440;				onEnterFrame = fadeDown;			}		}	}		private function fadeDown():Void {		count-=2;		_alpha = Math.min(_alpha,count);		if (count <= 0) { delete(onEnterFrame); this.removeMovieClip(); }	}}