// implementations
import flash.filters.*;
import flash.geom.*;
import flash.display.*;
import mx.transitions.*;
import mx.transitions.easing.*;
import com.vpmedia.events.Delegate;
// start class
class com.vpmedia.effects.Convolution {
	// START CLASS
	public var className:String = "Convolution";
	public var classPackage:String = "com.vpmedia.effects";
	public var version:String = "1.0.0";
	public var author:String = "András Csizmadia";
	//
	var filterDataArray;
	var filterArray;
	function Convolution () {
		this.filterDataArray = new Array ();
		this.filterArray = new Array ();
		this.filterDataArray["bigEdge"] = 0;
		this.filterDataArray["borders"] = 0;
		this.filterDataArray["define"] = 0;
		this.filterDataArray["defocus"] = 0;
		this.filterDataArray["edges"] = 0;
		this.filterDataArray["emboss"] = 50;
		this.filterDataArray["highlight"] = 128;
		this.filterDataArray["stone"] = 90;
		this.filterDataArray["shiftOutline"] = 0;
		this.filterArray["bigEdge"] = "0,0,0,0,0,0,0,0,-2,-2,-2,-2,-2,0,0,-2,-3,-3,-3,-2,0,0,-2,-3,53,-3,-2,0,0,-2,-3,-3,-3,-2,0,0,-2,-2,-2,-2,-2,0,0,0,0,0,0,0,0";
		this.filterArray["borders"] = "0,0,0,0,0,0,0,0,0,1,2,1,0,0,0,1,2,3,2,1,0,0,2,3,-35,3,2,0,0,1,2,3,2,1,0,0,0,1,2,1,0,0,0,0,0,0,0,0,0";
		this.filterArray["define"] = "-5,-2,0,0,0,0,0,-2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,2,6";
		this.filterArray["defocus"] = "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,1,-7,1,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0";
		this.filterArray["edges"] = "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-5,-5,-5,0,0,0,0,-5,39,-5,0,0,0,0,-5,-5,-5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0";
		this.filterArray["emboss"] = "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,-1,0,0,0,0,0,-1,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0";
		this.filterArray["highlight"] = "0,0,0,0,0,0,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0";
		this.filterArray["stone"] = "0,0,0,0,0,0,0,0,-1,-1,-1,-1,0,0,0,-1,-1,-1,0,1,0,0,-1,-1,0,1,1,0,0,-1,0,1,1,1,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0";
		this.filterArray["shiftOutline"] = "1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,-15,0,0,0,1,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1";
	}
	//shift outline
	function strToMatrix (mat:String) {
		var a = mat.split (",");
		for (var i in a) {
			a[i] = parseInt (a[i]);
		}
		return a;
	}
	function main (__target, __type) {
		var divisor = parseInt (this.filterDataArray[__type]);
		var filter = new flash.filters.ConvolutionFilter (7, 7, strToMatrix (this.filterArray[__type]), 1, divisor);
		__target.filters = [filter];
	}
}
