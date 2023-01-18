// ---------------------------
// Electro 1
// Author: Anton Volkov
// http://antonvolkov.com
// ---------------------------
import flash.filters.GlowFilter;
import flash.display.BitmapData;
import flash.geom.ColorTransform;
import flash.geom.Rectangle;
import flash.geom.Point;
var b:BitmapData = new BitmapData (400, 400, true, 0);
var mc:MovieClip = this.createEmptyMovieClip ("mc", 1);
mc.attachBitmap (b, 1);
mc.blendMode = 14;
var a:Array = new Array ();
var d:Array = new Array ();
for (var i = 0; i < 10; i++) {
	a[i] = new Point (Math.random () * 400, Math.random () * 400);
	d[i] = new Point (Math.random () * 10 - 5, Math.random () * 10 - 5);
}
var rand:Number = Math.random () * 10000;
var glow:GlowFilter = new GlowFilter (0xFF9000, 1, 12, 12, 2, 2, false, false);
var r:Array = new Array (256);
var ra:Array = new Array (256);
for (var i = 0; i < 256; i++) {
	r[i] = 0;
}
r[128] = 0x60FF3000;
r[129] = 0x80FF9000;
r[130] = 0xFFFFFF00;
r[131] = 0x80FF9000;
r[132] = 0x60FF3000;
onEnterFrame = function () {
	for (var i = 0; i < 10; i++) {
		this.a[i].x += this.d[i].x;
		this.a[i].y += this.d[i].y;
	}
	this.b.perlinNoise (120, 120, 3, this.rand, false, true, 0, true, this.a);
	this.b.paletteMap (this.b, this.b.rectangle, new Point (0, 0), this.r, this.r, this.r, this.r);
	this.b.applyFilter (this.b, this.b.rectangle, new Point (0, 0), this.glow);
};


// ---------------------------
// Electro 2
// Author: Anton Volkov
// http://antonvolkov.com
// ---------------------------
import flash.filters.GlowFilter;
import flash.display.BitmapData;
import flash.geom.ColorTransform;
import flash.geom.Rectangle;
import flash.geom.Point;
var b:BitmapData = new BitmapData (400, 400, true, 0);
var mc:MovieClip = this.createEmptyMovieClip ("mc", 1);
mc.attachBitmap (b, 1);
mc.blendMode = 14;
var a:Array = new Array ();
var d:Array = new Array ();
for (var i = 0; i < 10; i++) {
	a[i] = new Point (Math.random () * 400, Math.random () * 400);
	d[i] = new Point (Math.random () * 10 - 5, Math.random () * 10 - 5);
}
var rand:Number = Math.random () * 10000;
var glow:GlowFilter = new GlowFilter (0xFFFFFF, 0.5, 15, 15, 2, 2, false, false);
var r:Array = new Array (256);
var ra:Array = new Array (256);
for (var i = 0; i < 16; i++) {
	r[i * 16] = 0;
	r[i * 16 + 1] = 0;
	r[i * 16 + 2] = 0;
	r[i * 16 + 3] = 0;
	r[i * 16 + 4] = 0;
	r[i * 16 + 5] = 0x60FFFFFF;
	r[i * 16 + 6] = 0x80FFFFFF;
	r[i * 16 + 7] = 0xFFFFFFFF;
	r[i * 16 + 8] = 0x80FFFFFF;
	r[i * 16 + 9] = 0x60FFFFFF;
	r[i * 16 + 10] = 0;
	r[i * 16 + 11] = 0;
	r[i * 16 + 12] = 0;
	r[i * 16 + 13] = 0;
	r[i * 16 + 14] = 0;
	r[i * 16 + 15] = 0;
}
onEnterFrame = function () {
	for (var i = 0; i < 10; i++) {
		this.a[i].x += this.d[i].x;
		this.a[i].y += this.d[i].y;
	}
	this.b.perlinNoise (400, 400, 4, this.rand, false, true, 0, true, this.a);
	this.b.paletteMap (this.b, this.b.rectangle, new Point (0, 0), this.r, this.r, this.r, this.r);
	this.b.applyFilter (this.b, this.b.rectangle, new Point (0, 0), this.glow);
};
