/**
 * YugopItem.
 *
 * @author: Christoph Asam, E-Mail: c.asam@betriebsraum.de, Url: http://www.betriebsraum.de
 * @version: 1.0
 */
 
import mx.events.EventDispatcher;

class de.betriebsraum.gui.YugopItem extends MovieClip{


	/**********************************************************************
	* Private Variables
	* ********************************************************************/	
	
	private var _icon:MovieClip;
	private var _label:String;
	private var _handler:Function;
	private var _iconLibID:String;
	private var _refYM:MovieClip;
	private var _txtEffFlag:Boolean = false;
	
	
	/**********************************************************************
	* Public Variables
	* ********************************************************************/		

	public var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListnere:Function;
	public var id:Number;
	
	/**********************************************************************
	* Constructor
	* ********************************************************************/	
	
	function YugopItem(){
		
		this._refYM = this._parent;
		
		var refYM = this._refYM;
		
		EventDispatcher.initialize(this);
		addEventListener("onExpanding",this);
		addEventListener("onCollapsing",this);
		
		this["txtLabel"]._visible = false;
		
		
		this["mcItemBg"].onRollOver = function(){
			
			this._parent._txtEffFlag = false;
			
			refYM.activeItem = this._parent;

			this._parent.onEnterFrame = this._parent.expand;
			
			
			this._parent.dispatchEvent({	type:"onExpanding",
						target:this._parent});
						
						
		}
		
		this["mcItemBg"].onRollOut = function(){
			
			this._parent._txtEffFlag = false;
			
			if(refYM.selectedItem != this._parent){
			
				
			
				this._parent.onEnterFrame = this._parent.collapse;
			
				this._parent.dispatchEvent({	type:"onCollapsing",
							target:this._parent});
							
			}
		}
		
		this["mcItemBg"].onRelease = function(){
			
			refYM.selectedItem = this._parent;
			
			this._parent._handler();
			
		}

		
	}
	
	
	/**********************************************************************
	* Getter
	* ********************************************************************/	
	
	public function get handler():Function{
		return this._handler;
	}	
	
	public function get icon():MovieClip{
		return this._icon;
	}
	
	public function get iconLibID():String{
		
		return this._iconLibID;
	
	}
	
	public function get label():String{
		return this._label;
	}
	

	/**********************************************************************
	* Setter
	* ********************************************************************/
	
	public function set enabled(arg:Boolean):Void{
		
		if(arg){
			this["mcItemBg"].onRelease = this._handler;
		} else {
			this["mcItemBg"].onRelease = null;		
		}
	}
	
	public function set handler(arg:Function):Void{
		this._handler = arg;
	}
	
	public function set icon(arg:String):Void{
		this["mcIconHolder"].removeMovieClip();
		this["mcIconHolder"].attachMovie(arg,"mcIcon",1);
		this._icon =  this["mcIconHolder"].mcIcon;
		this._iconLibID = arg;
		
	}
	
	public function set label(arg:String):Void{
		this._label = arg;
	}	


	/**********************************************************************
	* Private Functions
	* ********************************************************************/	
	
	private function collapse(){
		
		this["txtLabel"]._visible = false;
		
		
		if(this._refYM.expand == "horizontal"){		
		
			this["mcItemBg"]._width -= 	Math.abs((this._refYM.minDimension - 
							this["mcItemBg"]._width)/this._refYM.easingSpeed);
													
		
			if(this["mcItemBg"]._width <= this._refYM.minDimension){
	
				this["mcItemBg"]._width = this._refYM.minDimension;
				this.onEnterFrame = null;
				
			}
			
		} else if(this._refYM.expand == "vertical"){
			
			this["mcItemBg"]._height -= 	Math.abs((this._refYM.minDimension - 
							this["mcItemBg"]._height)/this._refYM.easingSpeed);
													
		
			if(this["mcItemBg"]._height <= this._refYM.minDimension){
	
				this["mcItemBg"]._height = this._refYM.minDimension;
				this.onEnterFrame = null;
				
			}			
		}
		
	}	
	
	
	private function expand(){

		if(	this._refYM.activeItem != this._refYM.selectedItem and 
			!this._txtEffFlag){
				
			this._refYM.startTextEffect(this);
			this._refYM.activeItem = this;
			this._txtEffFlag = true;
			
		}
		
		this["txtLabel"]._visible = true;
		
		if(this._refYM.expand == "horizontal"){
		
			this["mcItemBg"]._width += 	Math.abs((this._refYM.maxDimension - 
							this["mcItemBg"]._width)/this._refYM.easingSpeed);
			
			
						
			if(this["mcItemBg"]._width >= this._refYM.maxDimension-0.5){
				
				this["mcItemBg"]._width = this._refYM.maxDimension;
				this._txtEffFlag = false;
				this.onEnterFrame = null;
				
			}
			
		} else if(this._refYM.expand == "vertical"){
			
			this["mcItemBg"]._height += 	Math.abs((this._refYM.maxDimension - 
							this["mcItemBg"]._height)/this._refYM.easingSpeed);
			
			
						
			if(this["mcItemBg"]._height >= this._refYM.maxDimension-0.5){
				
				this["mcItemBg"]._height = this._refYM.maxDimension;
				this._txtEffFlag = false;
				this.onEnterFrame = null;
				
			}			
		}

	}
	
	private function onCollapsing(args:Object){
				
		this._refYM.update();
		
		this._refYM.selectedItem._txtEffFlag = false;
		
		this._refYM.selectedItem.onEnterFrame = this.expand;
		
		this._refYM.startTextEffect(this._refYM.selectedItem);
						
	}
	
	private function onExpanding(args:Object){
		
		this._refYM.update();
		
		for(var i=0; i<this._refYM.items.length; i++){
			
			if(this._refYM.activeItem != this._refYM.items[i]){

				this._refYM.items[i].onEnterFrame = this.collapse;
			}
			
		}
		
	}
	

}