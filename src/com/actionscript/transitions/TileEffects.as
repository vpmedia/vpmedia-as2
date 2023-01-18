/*
created by Satori Canton
(c) 2005 ActionScript.com
*/
import com.actionscript.SatoriArray;
import com.actionscript.AScomponent;
class com.actionscript.transitions.TileEffects extends AScomponent {
	
	private var _tile:MovieClip;
	private var _tileArray:SatoriArray;
	private var _exitingArray:SatoriArray;
	private var _numberToBreak:Number;
	private var _effectType:Number;
	private var _fadeRate:Number;
	private var _tileBuffer:Number
	
	function TileEffects() {
		this._tileArray = new SatoriArray();
		this._exitingArray = new SatoriArray();
		this._tile.swapDepths(10);
		this._tile.removeMovieClip();
		this.setBreakNumber(1);
		this._fadeRate = 8;
		this._tileBuffer = 1;//used to cover anti-aliasing between tiles
	}
	public function createTiles(s:String, w:Number, h:Number):Void {
		this._x = w/2 + this._tileBuffer;
		this._y = h/2 + this._tileBuffer;
		var m:MovieClip = this.attachMovie(s, "temp", this.getNextHighestDepth());
		var mw:Number = m._width;
		var mh:Number = m._height;
		m.removeMovieClip();
		var y = Math.ceil(mh/h);
		while (y--){
			var x = Math.ceil(mw/w);
			while (x--){
				m = this.attachMovie("FallingTile", "tile"+this.getNextHighestDepth(), this.getNextHighestDepth());
				m.addListener(this);
				m.setMaskSize(w + this._tileBuffer*2, h + this._tileBuffer*2);
				m.setImage(s);
				m._x = w * x;
				m._y = h * y;
				m.setOffset(m._x, m._y);
				m.setGravity(this._fadeRate);
				m.cacheAsBitmap = true;
				this._tileArray.push(m);
			}
		}
	}
	public function setFadeRate(n:Number) {
		this._fadeRate = n;
		var l = this._tileArray.length;
		while(l--) {
			this._tileArray[l].setGravity(n);
		}
	}
	public function setBreakNumber(n:Number):Void {
		this._numberToBreak = n;
	}
	public function pourTiles():Void {
		this.dropTiles(1)
	}
	public function erodeTiles():Void {
		this.dropTiles(2)
	}
	public function shatterTiles():Void {
		this.dropTiles(0)
	}
	public function zoomTopToBottom():Void {
		this.zoomTiles(1);
	}
	public function zoomBottomToTop():Void {
		this.zoomTiles(2)
	}
	public function zoomRandom():Void {
		this.zoomTiles(0);
	}
	public function fadeTopToBottom():Void {
		this.fadeTiles(1);
	}
	public function fadeBottomToTop():Void {
		this.fadeTiles(2);
	}
	public function fadeRandom():Void {
		this.fadeTiles(0);
	}
	public function blurTopToBottom():Void {
		this.blurTiles(1);
	}
	public function blurBottomToTop():Void {
		this.blurTiles(2);
	}
	public function blurRandom():Void {
		this.blurTiles(0);
	}
	public function onTileRemoved(o:Object):Void {
		var l = this._exitingArray.length;
		while(l--) {
			if(this._exitingArray[l] == o) {
				this._exitingArray.pull(l);
			}
		}
		if(!this._exitingArray.length) {
			this.broadcastEvent('onEffectComplete');
		}
	}
	
	private function fadeTiles(n:Number):Void {
		this._effectType = n;
		this.onEnterFrame = function() {
			if(this._tileArray.length > 0) {
				var l = this._numberToBreak < this._tileArray.length ? this._numberToBreak : this._tileArray.length;
				while(l--){
					if(this._effectType == 0) {
						var n:Number = Math.floor(Math.random()*this._tileArray.length);
						var m:MovieClip = this._tileArray.pull(n);
					} else if(this._effectType == 1) {
						var m:MovieClip = this._tileArray.pop();
					} else {
						var m:MovieClip = this._tileArray.shift();
					}
					this._exitingArray.push(m);
					m.cacheAsBitmap = true;
					m.fadeAway();
				}
			} else {
				this.onEnterFrame = undefined;
			}
		}
	}
	private function zoomTiles(n:Number):Void {
		this._effectType = n;
		this.onEnterFrame = function() {
			if(this._tileArray.length > 0) {
				var l = this._numberToBreak < this._tileArray.length ? this._numberToBreak : this._tileArray.length;
				while(l--){
					if(this._effectType == 0) {
						var n:Number = Math.floor(Math.random()*this._tileArray.length);
						var m:MovieClip = this._tileArray.pull(n);
					} else if(this._effectType == 1) {
						var m:MovieClip = this._tileArray.pop();
					} else {
						var m:MovieClip = this._tileArray.shift();
					}
					this._exitingArray.push(m);
					m.cacheAsBitmap = true;
					m.zoomAway();
				}
			} else {
				this.onEnterFrame = undefined;
			}
		}
	}	
	private function dropTiles(n:Number):Void {
		this._effectType = n;
		this.onEnterFrame = function() {
			if(this._tileArray.length > 0) {
				var l = this._numberToBreak < this._tileArray.length ? this._numberToBreak : this._tileArray.length;
				while(l--){
					if(this._effectType == 0) {
						var n:Number = Math.floor(Math.random()*this._tileArray.length);
						var m:MovieClip = this._tileArray.pull(n);
					} else if(this._effectType == 1) {
						var m:MovieClip = this._tileArray.pop();
					} else {
						var m:MovieClip = this._tileArray.shift();
					}					this._exitingArray.push(m);
					m.cacheAsBitmap = true;
					m.swapDepths(this.getNextHighestDepth());
					m.popAndFall();
				}
			} else {
				this.onEnterFrame = undefined;
			}
		}
	}
	private function blurTiles(n:Number):Void {
		this._effectType = n;
		this.onEnterFrame = function() {
			if(this._tileArray.length > 0) {
				var l = this._numberToBreak < this._tileArray.length ? this._numberToBreak : this._tileArray.length;
				while(l--){
					if(this._effectType == 0) {
						var n:Number = Math.floor(Math.random()*this._tileArray.length);
						var m:MovieClip = this._tileArray.pull(n);
					} else if(this._effectType == 1) {
						var m:MovieClip = this._tileArray.pop();
					} else {
						var m:MovieClip = this._tileArray.shift();
					}
					this._exitingArray.push(m);
					m.cacheAsBitmap = true;
					m.swapDepths(this.getNextHighestDepth());
					m.fadeAway();
				}
			} else {
				this.onEnterFrame = undefined;
			}
		}
	}
}