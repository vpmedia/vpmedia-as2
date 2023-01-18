/**
 * TreeMenu.
 *
 * @author: Felix Raab, E-Mail: f.raab@betriebsraum.de, Url: http://www.betriebsraum.de
 * @version: 1.1
 */
 
 
import mx.transitions.Tween;
import mx.events.EventDispatcher; 
import mx.transitions.easing.*;

 
class de.betriebsraum.gui.TreeMenu {
	
	
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;	

	private var container_mc:MovieClip;	
	private var target_mc:MovieClip;	
	private var containerDepth:Number;
	
	private var isTweening:Boolean;
	private var isFading:Boolean;
	private var lastItem:MovieClip;
	private var lastULab:String;
	private var yOffset:Number = 0;
	
	private var _folderAction:Boolean;
	private var _x:Number;
	private var _y:Number;
	private var _movingSpeed:Number;
	private var _fadingSpeed:Number;
	private var _easingType:Function;
	private var _indention:Number;
	private var _rowHeight:Number;
	

	public function TreeMenu(target:MovieClip, depth:Number, x:Number, y:Number) {
		
		EventDispatcher.initialize(this);
		
		target_mc = target;
		containerDepth = depth;
		_x = x;
		_y = y;
		
		_folderAction = false;
		
		_movingSpeed = 0.5;
		_fadingSpeed = 0.5;
		_easingType = Strong.easeOut;
		_indention = 20;
		_rowHeight = 20;	
		
	}
	
	
	/***************************************************************************
	// PRIVATE METHODS (NOT DOCUMENTED)
	***************************************************************************/
	private function createMainContainer(x:Number, y:Number):Void {
	  
		container_mc = target_mc.createEmptyMovieClip("container_mc" + containerDepth, containerDepth);
		container_mc._x = x;
		container_mc._y = y;
		
	}
	
	
	private function makeMenu(parent:MovieClip, menuItems:Array, yPos:Number, xPos:Number, depth:Number, init:Boolean):Void {	
	
		var me:TreeMenu = this;	
		parent.childs = new Array();			
		var i:Number = 0;	
		
		while (i < menuItems.length) {
			
			var tmItem:MovieClip = container_mc.attachMovie("mc_item", "item_mc" + container_mc.getNextHighestDepth(), container_mc.getNextHighestDepth());			
								
			tmItem._y = yPos + yOffset;
			tmItem._x = xPos + (depth * _indention);
			yOffset += _rowHeight;
			
			tmItem.attributes = menuItems[i].attributes;
			tmItem.label = menuItems[i].attributes.label;
			tmItem.nodeValue = menuItems[i].firstChild.nodeValue;			
			tmItem.uLabel = tmItem.label+"_"+i+"_"+parent._name;
			
			var tweenFade = new Tween(tmItem, "_alpha", Regular.easeOut, 0, 100, _fadingSpeed, true);
			isFading = true;				
			tweenFade.onMotionFinished = function() {						
				if (me.isFading) {					
					me.isFading = false;
					me.dispatchEvent({target:me, type:"onFadeFinished"});	
				}						
			}
			
			if (menuItems[i].hasChildNodes() && menuItems[i].firstChild.nodeType != 3) {
				
				tmItem.childNodes = menuItems[i].childNodes;
				
				if (init && menuItems[i].attributes.open == "true") {
					trace(menuItems[i].attributes.label);
					makeMenu(tmItem, tmItem.childNodes, yPos, xPos, depth+1, true);	
					setIcon(tmItem, "folder", "opened");
				} else {						
					setIcon(tmItem, "folder", "closed");
				}
				
			} else {
				setIcon(tmItem, "tmItem", "closed");
			}		
			
			parent.childs.push(tmItem);				
			setClickHandler(tmItem);				
			i++;					
			
		}	
		
		if (!_folderAction) selectLastItem(parent.childs);
		
	}
	

	private function setClickHandler(tmItem:MovieClip):Void {
		
		var me:TreeMenu = this;
		
		tmItem.onRelease = function() {	
		
			var item:MovieClip = me.lastItem;
		
			if (this.childNodes) {	
			
				if (me._folderAction) me.setIcon(item, "tmItem", "closed");						
				if (me.isTweening) return;					
				
				this.open ? me.setIsOpen(this, false) : me.setIsOpen(this, true);
					
			} else {
				
				me.setIcon(item, "tmItem", "closed");
				me.setIcon(this, "tmItem", "opened");
				me.lastItem = this;	
				me.lastULab = this.uLabel;
		
			}

			me.dispatchEvent({target:me, type:'onClick', selectedItem:this});
			
		}
		
	}
	
	
	private function setIsOpen(tmItem:MovieClip, mode:Boolean):Void {
		
		if (mode) {
			
			yOffset = 0;
			
			moveMenu(tmItem, tmItem.childNodes.length);			
			makeMenu(tmItem, tmItem.childNodes, tmItem._y+_rowHeight, tmItem._x+_indention, 0, false);
			setIcon(tmItem, "folder", "opened");			
			
		} else {

			var killMe:Array = getCloseList(tmItem);
			
			moveMenu(tmItem, -killMe.length);
			killMenu(killMe);	
			setIcon(tmItem, "folder", "closed");		
			
		}		
		
	}
	
	
	private function moveMenu(tmItem:MovieClip, rowNum:Number):Void {
	
		var me:TreeMenu = this;
	
		for (var i:String in container_mc) {
			if (container_mc[i] instanceof MovieClip) {
				if (container_mc[i]._y > tmItem._y) {			
					
					var tweenMove = new Tween(container_mc[i], "_y", _easingType, container_mc[i]._y, container_mc[i]._y + (rowNum * _rowHeight), _movingSpeed, true);					
					isTweening = true;
					
					tweenMove.onMotionFinished = function() {						
						if (me.isTweening) {					
							me.isTweening = false;
							me.dispatchEvent({target:me, type:"onMoveFinished"});	
						}						
					}	
					
				}				
			}
		}
	
	}
	
	
	private function getCloseList(tmItem:MovieClip):Array {		
	
		var target:Array = new Array();
		walkChilds(tmItem, tmItem, target);
		return target;

		
	}
	
	
	private function walkChilds(tmItem:MovieClip, thisItem:MovieClip, target:Array):Void {
		
		for (var i:Number = 0; i < tmItem.childs.length; i++) {			
			target.push(tmItem.childs[i]);			
			if (tmItem.childs[i].open) walkChilds(tmItem.childs[i], thisItem, target);
		}
		
	}
	
	
	private function killMenu(items:Array):Void {
		
		var me:TreeMenu = this;
		
		for (var i:String in items) {						
					
			var tweenFade = new Tween(items[i], "_alpha", Regular.easeOut, 100, 0, _fadingSpeed, true);			
			isFading = true;		
			
			tweenFade.onMotionFinished = function(thisItem:MovieClip) {				
				thisItem.obj.removeMovieClip();				
				if (me.isFading) {								
					me.isFading = false;				
					me.dispatchEvent({target:me, type:"onFadeFinished"});	
				}					
			}
					
		}		
		
	}
	
	
	private function setIcon(tmItem:MovieClip, type:String, state:String):Void {
		
		if (type == "folder" && state == "opened") tmItem.open = true;
		if (type == "folder" && state == "closed") tmItem.open = false;
		
		tmItem.icon_mc.gotoAndStop(type+"_"+state);
		
	}
	
	
	private function selectLastItem(childs:Array):Void {	

		for (var i:String in childs) {
			if (lastULab == childs[i].uLabel) {
				setIcon(childs[i], "tmItem", "opened");	
				lastItem = childs[i];
			}			
		}
		
	}
	
	
	/***************************************************************************
	// PUBLIC METHODS
	***************************************************************************/
	public function setXML(XMLData:XML):Void {		

		createMainContainer(_x, _y);
		makeMenu(container_mc, XMLData.firstChild.childNodes, 0, 0, 0, true);
	
	}
	
	
	public function move(x:Number, y:Number):Void {
		
		container_mc._x = x;
		container_mc._y = y;
		
	}
	
	
	public function destroy():Void {
		container_mc.removeMovieClip();		
	}
	
	
	/***************************************************************************
	// GETTER / SETTER
	***************************************************************************/
	public function set folderAction(mode:Boolean):Void {
		_folderAction = mode;	
	}
	
	public function get folderAction():Boolean {
		return _folderAction;	
	}
	
	public function set movingSpeed(newSpeed:Number):Void {
		_movingSpeed = newSpeed;		
	}
	
	public function get movingSpeed():Number {
		return _movingSpeed;		
	}
	
	
	public function set fadingSpeed(newSpeed:Number):Void {
		_fadingSpeed = newSpeed;		
	}
	
	public function get fadingSpeed():Number {
		return _fadingSpeed;		
	}
	
	
	public function set easingType(newEase:Function):Void {
		_easingType = newEase;
	}
	
	public function get easingType():Function {
		return _easingType;
	}
	
	
	public function set indention(newIndention:Number):Void {
		_indention = newIndention;
	}
	
	public function get indention():Number {
		return _indention;
	}
	
	
	public function set rowHeight(newRowHeight:Number):Void {
		_rowHeight = newRowHeight;	
	}
	
	public function get rowHeight():Number {
		return _rowHeight;	
	}	
	
	
}