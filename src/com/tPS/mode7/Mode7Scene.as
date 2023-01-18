import com.tPS.tween.Thread;
import flash.display.BitmapData;
import com.tPS.draw.Shape;
import com.tPS.draw.Point;
/**
 * Mode7 Scene
 * 
 * @author tPS
 */
class com.tPS.mode7.Mode7Scene {
	
	private static var CENTER:Point = new Point(Stage.width/2, Stage.height/2);
	private static var RESOLUTION:Number = 3;
	
	private var _rt:MovieClip;
	private var _scrt:MovieClip;
	
	private var _rotation:Number;
	private var _cosness:Number;
	private var _sinness:Number;
	
	private var stripes:Array;
	
	
	/**
	 * CONSTRUCTOR
	 * @param $rt:	 	MovieClip
	 * 					the Base_mc
	 * 					
	 * @param initObj:	Initialization Object
	 * 					[groundFloor] Identifier:String
	 * 					[background] Identifier:String
	 */
	public function Mode7Scene($rt:MovieClip, initObj:Object) {
		_rt = $rt;

		setup();
		if(initObj)	init(initObj);
	}
	
	private function setup() : Void {
		Thread.initialize();		
	}
	
	private function init(initObj:Object) : Void {
		//init vars
		_rotation = 0;
		_cosness = 0;
		_sinness = 0;
		stripes = [];
				
		//overwrite or create baseclip
		_scrt = _rt.createEmptyMovieClip("mode7_mc", _rt.getNextHighestDepth());
		_scrt._x = CENTER.x;
		_scrt._y = CENTER.y;
		
		//attachGround
		attachGround(initObj.groundFloor);
	}
	
	private function attachGround($img:String) : Void {
		var stripe:MovieClip;
		var img_mc:MovieClip;
		var move_mc:MovieClip;
		var img_bd:BitmapData = BitmapData.loadBitmap($img);
		var msk:Shape;
		var msk_clip:MovieClip;
		
		var a:Number = 1;
		while(++a <= 180/RESOLUTION){
			//create stripe
			stripe = _scrt.createEmptyMovieClip("pic"+a, a*3+1);
			img_mc = stripe.createEmptyMovieClip("pic",1);
			move_mc = img_mc.createEmptyMovieClip("move",1);
			move_mc.attachBitmap(img_bd,0);
			move_mc._x = -move_mc._width*.5;
			move_mc._y = -move_mc._height*.5;			
			stripe._xscale = stripe._yscale = a*RESOLUTION*10;
			
			//create mask
			msk_clip = _scrt.createEmptyMovieClip("msk"+a, a*3+2);
			msk_clip._x = -CENTER.x;
			msk_clip._y = 200 + a*RESOLUTION;
			msk = new Shape(msk_clip, [new Point(0,0), new Point(Stage.width,0), new Point(Stage.width, RESOLUTION), new Point(0, RESOLUTION)]);
			stripe.setMask(msk_clip);
			stripes.push(stripe);
		}
		
		delete stripe;
		delete img_mc;
		delete move_mc;
		delete img_bd;
		delete msk;
		delete msk_clip;
	}
}


/**
//attaches ground and mask
// ms is set as the value u type in at the start.
for (a=1; a <= (180/ms); a++) {
	//grd = ground, mask = the mask movieclip
	grd = attachMovie("pic", "pic"+a, a*3+1);
	grd.pic._xscale = grd.pic._yscale=100;
	grd._x = 275;
	grd._y = 400;
	//the ground is scaled only once, when created. not on every frame
	grd._xscale = a*ms*10
	grd._yscale = a*ms*10;
	/// the below code happens on every frame for each bit of the ground.
	
	grd.onEnterFrame = function() {
		//the pic is rotated, but the 'move' symbol inside the pic is what is moved.
		this.pic._rotation = _root.rotation;
		this.pic.move._y += _root.cosness;
		this.pic.move._x += _root.sinness;
	};

	mask = attachMovie("mask", "mask"+a, a*3+2);
	mask._height = ms;
	mask._y = 200+a*ms;
	grd.setMask(mask);
}"
*/
