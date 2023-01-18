/*
created by Satori Canton
(c) 2005 ActionScript.com
*/
import com.actionscript.AScomponent;
class com.actionscript.transitions.TransitionsComponent extends AScomponent {
	
	[IconFile("TransitionsComponent.png")]
	[Inspectable(defaultValue="", name="Images")]
	public var imageArray:Array;
	[Inspectable(defaultValue=50, name="Tile Width")]
	public var tileWidth:Number;
	[Inspectable(defaultValue=50, name="Tile Height")]
	public var tileHeight:Number;
	[Inspectable(defaultValue=4, name="Number Affected")]
	public var numberAffected:Number;
	[Inspectable(defaultValue=8, name="Effect Speed")]
	public var effectSpeed:Number;
	[Inspectable(defaultValue="random", name="Effect Type", enumeration="pourTiles,erodeTiles,shatterTiles,blurTopToBottom,blurBottomToTop,blurRandom,zoomTopToBottom,zoomBottomToTop,zoomRandom,fadeTopToBottom,fadeBottomToTop,fadeRandom,random")]
	public var effect:String;
	public var isInTransit:Boolean
	
	private var clip:MovieClip;
	private var icon:MovieClip;
	private var image:MovieClip;
	private var _imageCounter:Number
	private var _effectTypeArray:Array
	
	function TransitionsComponent() {
		this.isInTransit = false;
		this._imageCounter = 0;
		this._effectTypeArray = ["pourTiles", "erodeTiles", "shatterTiles", "zoomTopToBottom", "zoomBottomToTop", "zoomRandom", "fadeTopToBottom", "fadeBottomToTop", "fadeRandom", "blurTopToBottom", "blurBottomToTop", "blurRandom", "random"]
		this.clip.swapDepths(10);
		this.clip.removeMovieClip();
		var m = this.attachMovie("TileEffects", "clip", 10);
		m.addListener(this);
		this.icon.swapDepths(11);
		this.icon.removeMovieClip();
		this.attachMovie(this.imageArray[this._imageCounter], "image", 5);
		this.setEffectSpeed(this.effectSpeed);
		this.setNumberAffected(this.numberAffected);	}
	
	public function setEffectSpeed(n:Number):Void {
		if(n<1) n=1;
		this.clip.setFadeRate(n);
	}
	public function setNumberAffected(n:Number):Void {
		n = Math.abs(Math.round(n));
		if(n<1)n=1;
		this.numberAffected = n
		this.clip.setBreakNumber(n);
	}
	public function setImageArray(a:Array):Void {
		this.imageArray = a;
		var m = this.attachImage(this.imageArray[this._imageCounter]);
	}
	public function setEffectType(s:String):Void {
		var l:Number = this._effectTypeArray.length;
		while(l--) {
			if(this._effectTypeArray[l] == s) {
				this.effect = s;
				return;
			}
		}
		throw new Error(s + " is not a valid effect type."); 
	}
	public function setTileWidth(n:Number):Void {
		this.tileWidth = n;
	}
	public function setTileHeight(n:Number):Void {
		this.tileHeight = n;
	}
	public function getNextImage():Void {
		if(!this.isInTransit) {
			this.isInTransit = true;
			this.createNewTiles();
			this._imageCounter = (this._imageCounter + 1) % this.imageArray.length;
			this.attachImage(this.imageArray[this._imageCounter]);
			if(this.effect == "random") {
				this.clip[this._effectTypeArray[Math.floor(Math.random() * (this._effectTypeArray.length-1))]]()
			} else {
				this.clip[this.effect]();
			}
		}
	}
	public function getPreviousImage():Void {
		if(!this.isInTransit) {
			this.isInTransit = true;
			this.createNewTiles();
			this._imageCounter--;
			while(this._imageCounter < 0) {
				this._imageCounter += this.imageArray.length;
			}
			this.attachImage(this.imageArray[this._imageCounter]);
			if(this.effect == "random") {
				this.clip[this._effectTypeArray[Math.floor(Math.random() * (this._effectTypeArray.length-1))]]()
			} else {
				this.clip[this.effect]();
			}
		}
	}
	public function onEffectComplete(o:Object):Void {
		this.isInTransit = false;
		this.broadcastEvent("onEffectComplete");
	}
	
	private function createNewTiles():Void {
		clip.createTiles(this.imageArray[this._imageCounter], this.tileWidth, this.tileHeight);
	}
	private function attachImage(s:String):MovieClip {
		if(this.image != undefined) {
			this.image.removeMovieClip();
		}
		var m:MovieClip = this.attachMovie(s, "image", 5);
		m.cacheAsBitmap = true;
		return(m);
	}
}