﻿/*eco.VeinManager by Grant Skinner, http://gskinner.com/You may distribute this class as long as you give appropriate credit, and this comment block remains intact.Visit gskinner.com for more Flash news, information, and source code.*/import com.gskinner.eco.Vein;class com.gskinner.eco.VeinManager extends MovieClip {// constants:	private static var MAX_DEPTH:Number=2000;	private static var WIDTH:Number=400;	private static var HEIGHT:Number=400;	// private properties:	private var artery:MovieClip; // the main vein.	private var depth:Number = 0;	private var xoff:Number=WIDTH/2;	private var yoff:Number=HEIGHT/2;	private var xvel:Number=0;	private var yvel:Number=0;	private var rvel:Number=0;	private var canvas:MovieClip;	// constructor:	private function VeinManager() {		createEmptyMovieClip("canvas",0);		// create a sub clip so that we can do camera effects:		canvas.createEmptyMovieClip("veins",0);		canvas._x = xoff;		canvas._y = yoff;		// create the artery:		createVein(Vein.MAX_THICKNESS,0,0,random(6));		// set		onEnterFrame = doEnterFrame;	}	// public methods:	public function createVein(p_thickness:Number,p_x:Number,p_y:Number,p_angle:Number):Void {		depth = ++depth%MAX_DEPTH;		var v:MovieClip = canvas.veins.attachMovie("com.gskinner.eco.Vein","v"+depth,depth,{_x:p_x,_y:p_y,thickness:p_thickness,angle:p_angle,manager:this});		if (p_thickness == Vein.MAX_THICKNESS) { artery = v; }	}	// private methods:	private function doEnterFrame():Void {		// do camera effects:		var x:Number = -(artery._x+artery.x);		var y:Number = -(artery._y+artery.y);		xvel += (x-canvas.veins._x)/500;		yvel += (y-canvas.veins._y)/500;		xvel *= 0.97;		yvel *= 0.97;			var r:Number = artery.angle*180/Math.PI;		r=r%180+180;		rvel += (r-canvas._rotation)/3000;		rvel *= 0.91;		canvas._rotation += rvel;				canvas.veins._x += xvel;		canvas.veins._y += yvel;	}}