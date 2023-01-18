/**
 * YugopMenu.
 *
 * @author: Christoph Asam, E-Mail: c.asam@betriebsraum.de, Url: http://www.betriebsraum.de
 * @version: 1.0
 */

import mx.events.EventDispatcher;
import de.betriebsraum.gui.YugopItem;

class de.betriebsraum.gui.YugopMenu extends MovieClip{
	
	
	/**********************************************************************
	* Private Variables
	* ********************************************************************/	
	
	private var _targetMc:MovieClip;
	private var _enabled:Boolean;
	private var _activeItem:YugopItem;
	private var _selectedItem:YugopItem;
	private var _items:Array;
	private var _space:Number;
	private var _easingSpeed:Number;
	private var _minDimension:Number;
	private var _maxDimension:Number;
	private var _align:String;
	private var _expand:String;
	private var _orgWidth:Number;
	private var _orgHeight:Number;
	private var _textanimDuration:Number;
	private var _textanimTime:Number;	
	
	/**********************************************************************
	* Public Variables
	* ********************************************************************/		

	
	// Event Methoden
	public var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListnere:Function;
	
	
	/**********************************************************************
	* Constructor
	* ********************************************************************/	
	
	public function YugopMenu(){
		
		this._items = new Array();
		
		// Default Values
		
		this._align = "horizontal";
		this._easingSpeed = 10;
		this._expand = "horizontal";
		this._maxDimension = 150;
		this._minDimension = 20;
		this._space = 5;
		this._textanimDuration = 15;
		this._textanimTime = 0;

		
		this["mcTemp"].unloadMovie();
		updateAfterEvent();
				
		EventDispatcher.initialize(this);
		addEventListener("onItemsChange",this);
		
	}
	
	/**********************************************************************
	* Getter
	* ********************************************************************/

	public function get activeItem():YugopItem{
		return this._activeItem;
	}	
	
	public function get align():String{
		return this._align;
	}
	
	public function get easingSpeed():Number{
		return this._easingSpeed;
	}
	
	public function get enabled():Boolean{
		return this._enabled;
	}
	
	public function get expand():String{
		return this._expand;
	}
	
	public function get items():Array{
		return this._items;
	}
	
	public function get maxDimension():Number{
		return this._maxDimension;
	}
	
	public function get minDimension():Number{
		return this._minDimension;
	}
	public function get selectedItem():YugopItem{
		return this._selectedItem;
	}	
	
	public function get selected():Number{
		
		for(var i=0; i < this._items.length;i++){
			
			if(this._selectedItem == this._items[i]){
				return i;
			}
			
		}
		
	}
	
	public function get space():Number{
		return this._space;
	}	

	/**********************************************************************
	* Setter
	* ********************************************************************/
	
	public function set activeItem(arg:YugopItem):Void{
		this._activeItem = arg;
	}
	
	public function set align(arg:String):Void{
		this._align = arg;
		this.reOrganizeItems();
	}
	
	public function set easingSpeed(arg:Number):Void{
		this._easingSpeed = arg;
	}
	
	public function set enabled(arg:Boolean):Void{
		
		if(arg){
			this._alpha = 100;
		} else {
			this._alpha = 50;
		}
		
		for(var i = 0; i < this._items.length; i++){
			this._items[i].enabled = arg;
		}
		
		this._enabled = arg;
	}
	
	public function set expand(arg:String):Void{
		this._expand = arg;
		this.reOrganizeItems();
	}
	
	public function set maxDimension(arg:Number):Void{
		this._maxDimension = arg;
	}	
	
	public function set minDimension(arg:Number):Void{
		this._minDimension = arg;
	}
	
	public function set selected(itemID:Number):Void{
		
		this._items[itemID]["mcItemBg"].onRollOver();
		this._selectedItem = this._items[itemID];
		this.startTextEffect(this._selectedItem);
		
	}	
	
	public function set selectedItem(arg:YugopItem):Void{
		this._selectedItem = arg;
	}

	public function set space(arg:Number):Void{
		this._space = arg;
	}
	
	public function set textanimDuration(arg:Number):Void{
		this._textanimDuration = arg;
	}
	
	/**********************************************************************
	* Public Functions
	* ********************************************************************/	
	
	public function addItem(iconLibID:String,label:String,handler:Function){
		
		// Item generieren
		this.attachMovie("YugopItem","item"+this._items.length,this.getNextHighestDepth());
		
		// Item registrieren
		this._items[this._items.length] = this["item"+this._items.length];
		
		
		// Item konfigurieren
		this._items[this._items.length-1].handler = handler;
		this._items[this._items.length-1].icon = iconLibID;
		this._items[this._items.length-1].label = label;
		this._items[this._items.length-1].id = this._items.length-1;
		
		if(this._selectedItem == undefined){
			this._selectedItem = this._items[this._items.length-1];
		}
	
		this.dispatchEvent({	type:"onItemsChange",
					target:this});
		
	}
	
	public function addItemAt(pos:Number,iconLibID:String,label:String,handler:Function){

		// Item generieren
		this.attachMovie("YugopItem","item"+this._items.length,this.getNextHighestDepth());
		
		// Item registrieren
		this._items.splice(pos,0,this["item"+this._items.length]);
		
		// Item konfigurieren
		this._items[pos].handler 	= handler;
		this._items[pos].icon 		= iconLibID;
		this._items[pos].label 	= label;
		this._items[pos].id		= pos;
		
		if(this._selectedItem == undefined){
			this._selectedItem = this._items[this._items.length-1];
		}
		
		this.reOrganizeItems();
		this.dispatchEvent({	type:"onItemsChange",
					target:this});
		
	}
	
	public function destroy(){
		
		for(var i=0; i<this._items.length;i++){
			
			this._items[i].removeMovieClip();
			
		}
		
		this.removeMovieClip();		
		
	}
	
	public function removeAll(){
		
		for(var i=0; i<this._items.length;i++){
			
			this._items[i].removeMovieClip();
			
		}			

		this._items = new Array();
		
		this.dispatchEvent({	type:"onItemsChange",
					target:this});
		
	}
	
	public function removeItemAt(itemNum:Number){
			
		this._items[itemNum].removeMovieClip();

		this._items.splice(itemNum,1);
		
		this.reOrganizeItems();
		
	}
		
	public function update(){
		
		switch(this._align){
		
		case "horizontal":

			this.onEnterFrame = function(){
				
				for(var i=0;i< this._items.length; i++){
	
					this._items[i]._x = 	this._items[i-1]._x + 
							this._items[i-1]["mcItemBg"]._width + 
							this._space;
							
				}
	
				if(this.activeItem["mcItemBg"]._width == this._maxDimension){
					
					this.onEnterFrame = null;
				}
				
			}
			break;
				
		case "vertical":
		
			this.onEnterFrame = function(){
				
				for(var i=0;i< this._items.length; i++){
	
					this._items[i]._y = 	this._items[i-1]._y + 
							this._items[i-1]["mcItemBg"]._height + 
							this._space;
							
				}
	
				if(this.activeItem["mcItemBg"]._height == this._maxDimension){
					
					this.onEnterFrame = null;
				}
				
			}		
			break;
		}
	}
	
	
	/**********************************************************************
	* Private Functions
	* ********************************************************************/	
	
	private function reOrganizeItems(){
		
		for(var i = 0; i < this._items.length; i++){
			
			var iconLibID = this._items[i].iconLibID;
			var label = this._items[i].label;
			var handler = this._items[i].handler;
			var name = this._items[i]._name;
			
			this._items[i].removeMovieClip();
			
			this.attachMovie("YugopItem",name,this.getNextHighestDepth());
			
			this._items[i].handler = handler;
			this._items[i].icon 	= iconLibID;
			this._items[i].label 	= label;
			this._items[i].id = i;
			
			
		}
			
		
		
		
		this.dispatchEvent({	type:"onItemsChange",
					target:this});
		
	}
	
	private function onItemsChange(obj:Object){
		
		switch(this._align){
		
		case "horizontal":
					
			for(var i = 0; i < this._items.length; i++){
				
				this._items[i]["mcItemBg"]._width = this._minDimension;				
							
				this._items[i]._y = 0;
				
				if(this._items[i-1] != this._activeItem){
					
					this._items[i]._x = 	i * this._items[i]["mcItemBg"]._width + 
								i * this._space;
				} else {
	
					this._items[i]._x = 	i-1 * this._items[i]["mcItemBg"]._width +
								this._items[i-1]["mcItemBg"]._width +
								i * this._space;
				}
				
			}
			
			break;
			
		case "vertical":
					
			for(var i = 0; i < this._items.length; i++){

				this._items[i]["mcItemBg"]._height = this._minDimension;				
				
				this._items[i]._x = 0;
				
				if(this._items[i-1] != this._activeItem){
					this._items[i]._y = 	i * this._items[i]["mcItemBg"]._height + 
								i * this._space;
				} else {
	
					this._items[i]._y = 	i-1 * this._items[i]["mcItemBg"]._height +
								this._items[i-1]["mcItemBg"]._height +
								i * this._space;
				}
				
			}
						
			break;
		}
		
		this._selectedItem["mcItemBg"].onRollOver();
		this.startTextEffect(this._selectedItem);
		
		this.update();
		
	}
	
	private function startTextEffect(item:YugopItem){
		
		var strlen:Number =  this._activeItem.label.length;
		
		var refYugopMenu = this;
		
		item["mcIconHolder"].onEnterFrame = function(){
			
			var rndstr:String = "";
			//
			if ((refYugopMenu._textanimDuration - refYugopMenu._textanimTime) < strlen){
				
				rndstr += this._parent.label.substr(0, strlen - (refYugopMenu._textanimDuration - refYugopMenu._textanimTime))
				
				for (var i = 0; i<(refYugopMenu._textanimDuration - refYugopMenu._textanimTime); i++){
					rndstr+= String.fromCharCode(random(50) + 20)
				}
					
			} else {
				
				for (var i = 0; i<strlen; i++){
					rndstr+= String.fromCharCode(random(50) + 20)
				}
				
			}
			
			this._parent["txtLabel"].text = rndstr;
						
			if (refYugopMenu._textanimTime++ > refYugopMenu._textanimDuration){
				this._parent["txtLabel"].text = this._parent.label;
				refYugopMenu._textanimTime = 0
				delete this.onEnterFrame
			}
		}		
		
	}
}