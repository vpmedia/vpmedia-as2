import mx.core.UIObject;

import gugga.collections.ArrayList;
import gugga.common.IEventDispatcher;
import gugga.debug.Assertion;
import gugga.utils.DrawUtil;

[Event("uiInitialized")]

// present function initUI a delayed version of init when sub components are initialized
// and can be used to attach listeners fill data source , create bindings etc.
class gugga.common.UIComponentEx extends UIObject implements IEventDispatcher
{
	
	private static var INVISIBLE_WIDTH:Number = 0.1;
	private static var INVISIBLE_HEIGHT:Number = 0.1;
	private static var OFFSET_FROM_SCENE_WHEN_INVISIBLE:Number = 1001;
	
	private var __Real_width:Number;
	private var __Real_heigth:Number;
	private var __Real_x:Number;
	private var __Real_y:Number;

	private var __DisableMouseEventsCover : MovieClip;
		
	
	private var mTrackableID : String;
	public function get TrackableID() : String { return mTrackableID; }
	public function set TrackableID(aValue : String) : Void { mTrackableID = aValue; }
	
	private var mMoveOutOfSceneWhenInvisible:Boolean = false;
	public function get MoveOutOfSceneWhenInvisible():Boolean { return mMoveOutOfSceneWhenInvisible; }
	public function set MoveOutOfSceneWhenInvisible(aValue:Boolean):Void { mMoveOutOfSceneWhenInvisible = aValue; }
	
	private var mMinimizeWhenInvisible:Boolean = false;
	public function get MinimizeWhenInvisible():Boolean { return mMinimizeWhenInvisible; }
	public function set MinimizeWhenInvisible(aValue:Boolean):Void { mMinimizeWhenInvisible = aValue; }
	
	public function get width() : Number 
	{
		if (this._width != INVISIBLE_WIDTH || !mMinimizeWhenInvisible)
		{
			__Real_width = _width;
		}

		return __Real_width;

	}
	
	public function set width(aValue:Number) : Void
	{		
		//set _width only if object is visible otherwise 
		//_width is set to 0 for performance reasons and 
		//will recive his new value when object is shown
		
		//this behaviour is optional and depends on MinimizeWhenInvisible flag
		
		__Real_width = aValue;
		if (this.visible || !mMinimizeWhenInvisible)
		{
			_width = aValue;
		}
	}
	

	public function get height() : Number 
	{ 
		if (this._height != INVISIBLE_HEIGHT || !mMinimizeWhenInvisible)
		{
			__Real_heigth = _height;
		}
		
		return __Real_heigth; 
	}
	
	public function set height(aValue:Number) : Void
	{
		//set _height only if object is visible otherwise 
		//_height is set to 0 for performance reasons and 
		//will recive his new value when object is shown
		
		//this behaviour is optional and depends on MinimizeWhenInvisible flag
		
		__Real_heigth = aValue;
		if (this.visible || !mMinimizeWhenInvisible)
		{
			_height = aValue;
		}
	}
	

	public function get x() : Number 
	{ 
		if (this._x != OFFSET_FROM_SCENE_WHEN_INVISIBLE || !mMoveOutOfSceneWhenInvisible)
		{
			__Real_x = _x;
		}
		
		return  __Real_x; 
	}
	
	public function set x(aValue:Number) : Void
	{		
		//set _x only if object is visible otherwise 
		//_x is move out of the scene for performance reasons
		//and will recive his new value when object is shown
		
		//this behaviour is optional and depends on MoveOutOfSceneWhenInvisible flag
		
		__Real_x = aValue;
		if (this.visible || !mMoveOutOfSceneWhenInvisible)
		{
			_x = aValue;
		}
	}
	
	public function get y() : Number 
	{ 
		if (this._y != OFFSET_FROM_SCENE_WHEN_INVISIBLE || !mMoveOutOfSceneWhenInvisible)
		{
			__Real_y = _y;
		}
		
		return  __Real_y; 
	}
	
	public function set y(aValue:Number) : Void
	{
		//set _y only if object is visible otherwise 
		//_y is move out of the scene for performance reasons  
		//and will recive his new value when object is shown
		
		//this behaviour is optional and depends on MoveOutOfSceneWhenInvisible flag
		
		__Real_y = aValue;
		if (this.visible || !mMoveOutOfSceneWhenInvisible)
		{
			_y = aValue;
		}
	}
	
	
	public function UIComponentEx() 
	{
		super();
		__Real_width = this._width;
		__Real_heigth = this._height;
		__Real_x = this._x;
		__Real_y = this._y;
	}
	
	public function show():Void
	{
		this.visible = true;
	}
	
	public function hide():Void
	{
		this.visible = false;
	}
	
	public function enableBoundingBoxMouseEvents():Void
	{
		__removeDisableMouseEventsCover();
	}
	
	public function disableBoundingBoxMouseEvents():Void
	{
		__applyDisableMouseEventsCover();
	}
	
	//TODO: why these methods are overridden
	public function dispatchEvent(eventObj : Object) : Void 
	{
		super.dispatchEvent(eventObj);
	}

	public function addEventListener(event : String, handler) : Void 
	{
		super.addEventListener(event, handler);
	}

	public function removeEventListener(event : String, handler) : Void 
	{
		super.removeEventListener(event, handler);
	}
	
	function init():Void 
	{
		super.init();
		doLater(this,"_initUI");
	}

	function createChildren():Void 
	{
		// Call createClassObject to create subobjects.
		size();
		invalidate();
	}

	// Overridable function 
	// overide this function when you need a delayed version of init 
	// it is called when sub components are fully initialized
	// and can be used to attach listeners fill data source , create bindings etc.
	function _initUI()
	{
		initUI();
		dispatchEvent({type:"uiInitialized", target:this});
	}	
	
	function initUI(){}//overridable
	
	public function getComponent(aComponentName : String)
	{
		Assertion.failIfNull(this[aComponentName], "Invalid Component name (" + aComponentName + ") in AssigmentMap", this, arguments);
		
		return this[aComponentName];
	}
	
	public function getComponentByPath(aComponentPath : Array)
	{
		var conponentPath : ArrayList = new ArrayList();
			
		conponentPath.addAll(aComponentPath);
			
		var componentName : String;
		var component : Object = this;
		while(conponentPath.length > 0)
		{
			componentName = String(conponentPath.shift());
			component = component[componentName];
			
			if(!component)
			{
				Assertion.failIfNull(component, "Invalid Component name (" + componentName + ") for path " +
					aComponentPath + " in AssigmentMap", this, arguments);
					
				break;
			}
		}
		
		return component;
	}
	
	//this method is called from UIObject class in setter of the visible property  
	private	function setVisible(aNewValue:Boolean, noEvent:Boolean) : Void
	{
		if (aNewValue == this.visible)
		{
			super.setVisible(aNewValue, noEvent);
			return; 
		}
		
		if(aNewValue)
		{
			if (mMinimizeWhenInvisible)
			{
				__setRealSize();
			}
			
			if (mMoveOutOfSceneWhenInvisible)
			{
				__returnBackToScene();
			}
		}
		else
		{
			if (mMinimizeWhenInvisible)
			{
				__saveSizeAndMakeItZero();
			}
			
			if (mMoveOutOfSceneWhenInvisible)
			{
				__moveOutOfScene();
			}
		}
		
		super.setVisible(aNewValue, noEvent);
	}
	
	private function __setRealSize()
	{
		
		if (this._width == INVISIBLE_WIDTH)
		{
			this._width = __Real_width;
		}
		
		if (this._height == INVISIBLE_HEIGHT)
		{
			this._height = __Real_heigth;
		}
	}
	
	private function __saveSizeAndMakeItZero()
	{
		__Real_width = this._width;
		__Real_heigth = this._height;
		
		this._width = INVISIBLE_WIDTH;
		this._height = INVISIBLE_HEIGHT;
	}
	
	private function __moveOutOfScene()
	{
		var pt:Object = {x: 0, y: 0};
		this.localToGlobal(pt);
		
		var globalX:Number = Number(pt["x"]);
		var globalY:Number = Number(pt["y"]);
		
		__Real_x = this._x;
		__Real_y = this._y;
		
		this._x = this._x - globalX - OFFSET_FROM_SCENE_WHEN_INVISIBLE;
		this._y = this._y - globalY - OFFSET_FROM_SCENE_WHEN_INVISIBLE;

	}
	
	private function __returnBackToScene()
	{
		this._x = __Real_x;
		this._y = __Real_y;
	}
	
	private function __applyDisableMouseEventsCover():Void
	{
		if (!__DisableMouseEventsCover)
		{
			this.enabled = false;
			__DisableMouseEventsCover = DrawUtil.createBoundingBoxCover("__DisableMouseEventsCover", this);
			__DisableMouseEventsCover.onRelease = function(){};
			__DisableMouseEventsCover.useHandCursor = false;
		}
	}
	
	private function __removeDisableMouseEventsCover():Void
	{
		this.enabled = true;
		__DisableMouseEventsCover.removeMovieClip();
		__DisableMouseEventsCover = null;
	}
	
}
