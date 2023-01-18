/**
* Hue and Saturation MovieClip Prototype modifiers
* 
* Adds _hue and _saturation properties to movie clips.
* 
* _hue is a value on the color wheel between 0 and 360.
* _saturation is a number >= 0 where 0 = grayscale, and
* 100 is normal color.  
* 
* Example Usage:
*   // only needs to be called once at app startup
*   com.bumpslide.util.HueSatProto.init(); 
* 
*   // makes image mc grayscale
*   image_mc._saturation = 0;
* 
*   // tweens an image's hue using zigo/fuse tweens
*   image_mc.tween('_hue', 360, .5, 'easeOutQuad');
* 
*/

import flash.filters.ColorMatrixFilter;

class com.bumpslide.util.HueSatProto
{
	/**
	* Adds _hue and _saturation properties to movie clips
	*/
	static function init() {
		
		if(_init) return false;
		_init = true;
		
		trace('Initializing Hue/Saturation shortcuts on MovieClip.prototype.');
		
		var __mc_getSat = function () {
			return this._cmFltrGetVal('saturation',100.0);
		}
		var __mc_setSat = function (sat) {
			if(sat==100) sat=null;
			this._cmFltrSetVal('saturation', sat);
		}
		var __mc_getHue = function () {
			return this._cmFltrGetVal('hue',0);
		}
		var __mc_setHue = function (hue) {
			//hue%=360;
			//if(hue==0) hue=null;
			this._cmFltrSetVal('hue', hue);
		}
		
		// add hue and saturation properties to movieclips
		var mcproto = _global.MovieClip.prototype;
		
		mcproto.addProperty('_saturation',__mc_getSat,__mc_setSat); 
		mcproto.addProperty('_hue',__mc_getHue,__mc_setHue); 
				
		mcproto._cmFltrIndex = {};
		mcproto._cmFltrVal = {};
		
		mcproto._cmFltrGetVal = function(ft, defaultVal) { // ft=filterType
			if(this._cmFltrVal[ft]==undefined) this._cmFltrVal[ft] = defaultVal;
			return this._cmFltrVal[ft];
		}
		mcproto._cmFltrSetVal = function (ft,val) {	
			//trace('Setting '+ft+' to '+val);
			//trace('Filter Index is '+this._cmFltrIndex[ft]);
			this._cmFltrVal[ft] = val;	
			var fltrsCopy = (this.filters.length) ? this.filters.concat() : [];	
			delete fltrsCopy[this._cmFltrIndex[ft]];		
			if(val!=null) {
				if(this._cmFltrIndex[ft]==undefined) this._cmFltrIndex[ft]=fltrsCopy.length;
				fltrsCopy[this._cmFltrIndex[ft]] = this['_cmFltr_'+ft].apply(this, [val]);
			} else {
				this._cmFltrIndex[ft] = null;
			}
			this.filters = fltrsCopy;
		}

		// s = 0-100 where 0=grayscale, and 100=normal full color;
		mcproto._cmFltr_saturation = function (s:Number):ColorMatrixFilter{
			if(s==undefined)s=1; var r=0.213; var g=0.715; var b=0.072; var t = (100-s)/100;
			return new ColorMatrixFilter([t*r+1-t,t*
			g,t*b,0,0,t*r,t*g+1-t,t*b,0,0,t*r,t*g,t*b+1-t,0,0,0,0,0,1,0]);
		}

		// alter hue based on rotation of color wheel
		mcproto._cmFltr_hue = function (rot:Number):ColorMatrixFilter {
			//rot %= 360;
			rot*=Math.PI/180;
			var c = Math.cos(rot); var s = Math.sin(rot);
			var r=0.213; var g=0.715; var b=0.072;
			return new ColorMatrixFilter([(r + (c * (1 - r))) + (s * (-r)), (g + (c * (-g))) + (s * (-g)), (b + (c * (-b))) + (s * (1 - b)), 0, 0, (r + (c * (-r))) + (s * 0.143), (g + (c * (1 - g))) + (s * 0.14), (b + (c * (-b))) + (s * -0.283), 0, 0, (r + (c * (-r))) + (s * (-(1 - r))), (g + (c * (-g))) + (s * g), (b + (c * (1 - b))) + (s * b), 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1]);
		}
		
		var hiddenProps = ['_cmFltrIndex', '_cmFltrVal', '_cmFltrGetVal', '_cmFltrSetVal', '_cmFltr_saturation', '_cmFltr_hue'];
		_global.ASSetPropFlags( mcproto, hiddenProps, 1);
		
		
	}
	
	static private var _init:Boolean = false;

	/**
	* Private Constructor
	*/
	private function HueSatProto() {}

}
