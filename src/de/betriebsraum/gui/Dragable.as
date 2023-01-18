import mx.utils.Delegate;


class de.betriebsraum.gui.Dragable {
	
	
	private var snapToMouse:Boolean;
	private var dragable_mc:MovieClip;
	private var dragger_mc:MovieClip;
	private var bounding_mc:MovieClip;
	
	private var _dragableSize:Object;
	
	
	public function Dragable(snapToMouse:Boolean, dragable_mc:MovieClip, dragger_mc:MovieClip, bounding_mc:MovieClip) {
		
		this.snapToMouse = snapToMouse;
		this.dragable_mc = dragable_mc;
		this.dragger_mc = dragger_mc;
		this.bounding_mc = bounding_mc;
		
		_dragableSize = new Object();
		
		init();
		
	}
	
	
	private function init():Void {	
		
		dragger_mc = dragger_mc ? dragger_mc : dragable_mc;
		
		dragger_mc.onPress = Delegate.create(this, startDragging);
		dragger_mc.onRelease = dragger_mc.onReleaseOutside = Delegate.create(this, stopDragging);
		
	}
	
	
	private function startDragging():Void {	
	
		var boundX:Number = bounding_mc ? bounding_mc._x : 0;
		var boundY:Number = bounding_mc ? bounding_mc._y : 0;
		var boundW:Number = bounding_mc ? bounding_mc._width  : Stage.width;
		var boundH:Number = bounding_mc ? bounding_mc._height : Stage.height;		
		var dragableW:Number = dragableSize.w ? dragableSize.w : dragable_mc._width;
		var dragableH:Number = dragableSize.h ? dragableSize.h : dragable_mc._height;

		dragable_mc.startDrag(snapToMouse, boundX, boundY-(dragableH-boundH), boundX+boundW-dragableW, boundY);

	}


	private function stopDragging():Void {
		dragger_mc.stopDrag();
	}
	
	
	public function get dragableSize():Object {
		return _dragableSize;
	}	
	
	public function set dragableSize(newDragableSize:Object):Void {
		
		_dragableSize.w = newDragableSize.w ? newDragableSize.w : 0;
		_dragableSize.h = newDragableSize.h ? newDragableSize.h : 0;
		
	}
	

}