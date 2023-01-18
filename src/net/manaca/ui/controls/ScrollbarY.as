import net.manaca.ui.controls.skin.IScrollbarSkin;
import net.manaca.ui.controls.skin.SkinFactory;
import net.manaca.ui.awt.Dimension;
import net.manaca.lang.event.ButtonEvent;
import net.manaca.util.Delegate;
import net.manaca.lang.event.Event;
import net.manaca.ui.controls.skin.mnc.ScrollbarYSkin;
import net.manaca.ui.controls.SimpleScrollbar;
/**
 * 滚动条值发生变化时
 */
[Event(Event.SCROLL)]
/**
 * 抽象的滚动条对象，定义一个滚动条所需要的方法
 * @author Wersling
 * @version 1.0, 2006-5-18
 */
class net.manaca.ui.controls.ScrollbarY extends SimpleScrollbar {
	private var className : String = "net.manaca.ui.controls.ScrollbarY";
	private var _skin:IScrollbarSkin;

	private var _up_but : net.manaca.ui.controls.Button;
	private var _down_but : net.manaca.ui.controls.Button;
	private var _drag_but : net.manaca.ui.controls.Button;
	
	public function ScrollbarY(target : MovieClip, new_name : String) {
		super(target, new_name);
//		_skin = SkinFactory.getInstance().getDefault().createScrollbarSkin();
		_skin = new ScrollbarYSkin();

		_preferredSize = new Dimension(16,100);
		paintAll();
		init();
	}
	
	private function init() : Void {
		_up_but = _skin.getUpButton();
		_down_but = _skin.getDownButton();
		_drag_but = _skin.getDragButton();
		
		_up_but.addEventListener(ButtonEvent.PRESS,Delegate.create(this,onUpBut));
		_down_but.addEventListener(ButtonEvent.PRESS,Delegate.create(this,onDownBut));
		
		_drag_but.addEventListener(ButtonEvent.PRESS,Delegate.create(this,onStartDrag));
		_drag_but.addEventListener(ButtonEvent.RELEASE,Delegate.create(this,onStopDrag));
		_drag_but.addEventListener(ButtonEvent.RELEASE_OUT_SIDE,Delegate.create(this,onStopDrag));
		
		updateDragButton();
	}
	
	//更新拖动按钮
	private function updateDragButton():Void{
		if((_maxPos-_minPos) <= _pageSize || this.getSize().getHeight() < 42){
			 _drag_but.setVisible(false);
		}else{
			 _drag_but.setVisible(true);
			 
			 var _h = int((_pageSize/(_maxPos-_minPos))*_skin.getDragArea().getHeight());
			if(_h<10) _h = 10;
			 _drag_but.setSize(this.getSize().getWidth(),_h);
			
			
			var _dragArea_height = _skin.getDragArea().getHeight();
			var _dragArea_y = _skin.getDragArea().getY();
			var y:Number = (scrollPosition / (_maxPos - _minPos-_pageSize)) * (_dragArea_height-_h) + _dragArea_y;
			
			 _drag_but.setLocation(0,int(y));
		}
	}
		
	private function onUpBut() : Void {
		scrollPosition = previousScroll ;
	}

	private function onDownBut() : Void {
		scrollPosition = nextScroll;
	}
	
	private function onStartDrag() : Void {
		if(!_isDrag){
			var top = _skin.getDragArea().getY();
			var bottom =  _skin.getDragArea().getHeight()+top-_drag_but.getSize().getHeight();
			

			_drag_but.getDisplayObject().startDrag(false,0,top,0,bottom);
			
			_isDrag = true;
			_drag_but.getDisplayObject().onMouseMove = Delegate.create(this,onChangeDrag);
		}
	}
	private function onChangeDrag() : Void {
		if(_isDrag){
			_drag_but.setLocation(_drag_but.getDisplayObject()._x,_drag_but.getDisplayObject()._y);
			scrollPosition = int(accountScrollPosition())+_minPos;
		}
	}
	private function onStopDrag() : Void {
		if(_isDrag){
			_drag_but.getDisplayObject().stopDrag();
			_drag_but.getDisplayObject().onMouseMove = null;
			delete _drag_but.getDisplayObject().onMouseMove;
			_isDrag = false;
		}
	}
	
	private function accountScrollPosition():Number{
		var _drag_but_height = _drag_but.getSize().getHeight();
		var _drag_but_y = _drag_but.getLocation().getY();
		var _dragArea_height = _skin.getDragArea().getHeight();
		var _dragArea_y = _skin.getDragArea().getY();
		
		return ((_drag_but_y - _dragArea_y)/(_dragArea_height-_drag_but_height))*(_maxPos-_minPos-_pageSize);
	}

}