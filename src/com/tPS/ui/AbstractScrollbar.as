import com.tPS.ui.GenericLibraryElement;
import com.tPS.draw.Dimensions;
import com.tPS.draw.Shape;
import com.tPS.draw.Point;
import com.mosesSupposes.fuse.ZigoEngine;
import com.robertpenner.easing.Quad;
import flash.filters.BlurFilter;

/**
 * Abstract Scrollbar Class
 * superclass for scrolling abilities
 * @author tPS
 */
class com.tPS.ui.AbstractScrollbar extends GenericLibraryElement {
	private var blur:BlurFilter;
	private var type:String;
	private var scrollSource:Object;
	private var origin_y:Number;
	private var visibledimensions:Dimensions;
	private var diff:Number;
	private var perc:Number;
	
	function AbstractScrollbar($rt : MovieClip) {
		super($rt);
		//blur = new BlurFilter(0,16,2);
	}
	
	
	/**
	 * SETS UP SCROLLINGTYPE AND MASK
	 * @param	$visibledimensions	used only by type MC;
	 */
	public function setup($scroll_obj:Object, $visibledimensions:Dimensions) : Void {
				
		scrollSource = $scroll_obj;
		visibledimensions = $visibledimensions;
		
		type = ($scroll_obj instanceof MovieClip) ? "mc" : "txt";
		
		if(type == "mc"){
			setupMC();
		}else{
			setupTXT();
			
		}
		
		//scrollSource.filters = [new BlurFilter(0,0,2)];
		
		init();
				
	}
	
	/**
	 * FOR MOVIECLIP
	 */
	private function setupMC() : Void {
		//calculate Ratio
		var smc = MovieClip(scrollSource);
		origin_y = smc._y;
		diff = smc._height - visibledimensions._height;
				
		if(diff>0){
			//addMask
			var _prnt:MovieClip = smc._parent;
			//if there was no mask already
			if(_prnt.scroll_mc_mask == undefined){
				var msk_mc:MovieClip = _prnt.createEmptyMovieClip("scroll_mc_mask", _prnt.getNextHighestDepth());
				var msk_shape:Shape = new Shape(msk_mc,
												[ new Point(0,0), 
												  new Point(visibledimensions._width, 0), 
												  new Point(visibledimensions._width, visibledimensions._height), 
												  new Point(0, visibledimensions._height)
												]);
				
				msk_mc._x = smc._x;
				msk_mc._y = smc._y;
				//msk_mc.filters = [blur];
				//msk_mc.cacheAsBitmap = true;
			}	
			smc.setMask(msk_mc);
		}
	}
	
	/**
	 * FOR TEXTFIELD
	 */
	private function setupTXT() : Void {
		//calculate Ratio
		var stxt:TextField = TextField(scrollSource);
		diff = stxt.maxscroll-stxt.scroll;
	}
	
	private function init() : Void {		
		if(diff <= 0){
			disable();
		}else{
			enable();
		}
		scroll(0);				
	}
	
	
	/**
	 * BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR
	 * BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR
	 * BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR
	 * BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR
	 */	
	
	/**
	 * SCROLL
	 * @param 	perc:Number	 percentage of MAX to be scrolled to
	 */
	private function scroll($perc:Number) : Void {
		perc = $perc;
		if(type == "mc"){
			updateMC();
		}else{
			updateTXT();
		}
		broadcastMessage("setPanel",perc);
	}
	
	private function updateMC() : Void {
		var smc:MovieClip = MovieClip(scrollSource);
		//smc.filters = [blur];
		//ZigoEngine.doTween(smc,["_y","Blur_blurY"],[perc * -diff + origin_y,0],.4,Quad.easeOut);
		smc._y = perc * -diff + origin_y;
	}
	
	private function updateTXT() : Void {
		var stxt:TextField = TextField(scrollSource);
		stxt.scroll = perc * diff;
	}		

	public function disable() : Void {
		broadcastMessage("blend",false);
	}
	
	public function enable() : Void {
		broadcastMessage("blend",true);
	}

}