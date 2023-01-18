import net.manaca.ui.controls.skin.IScrollbarSkin;
import net.manaca.ui.controls.skin.SkinFactory;
import net.manaca.ui.awt.Dimension;
import net.manaca.lang.event.ButtonEvent;
import net.manaca.util.Delegate;
import net.manaca.lang.event.Event;
import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.skin.mnc.ScrollbarXSkin;
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
class net.manaca.ui.controls.ScrollbarX extends SimpleScrollbar {
	private var className : String = "net.manaca.ui.controls.ScrollbarX";
	private var _skin:IScrollbarSkin;
	
	private var _up_but : net.manaca.ui.controls.Button;
	private var _down_but : net.manaca.ui.controls.Button;
	private var _drag_but : net.manaca.ui.controls.Button;
	public function ScrollbarX(target : MovieClip, new_name : String) {
		super(target, new_name);
//		_skin = SkinFactory.getInstance().getDefault().createScrollbarSkin();
		_skin = new ScrollbarXSkin();
		_preferredSize = new Dimension(100,16);
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
		if((_maxPos-_minPos) <= _pageSize || this.getSize().getWidth() < 42){
			 _drag_but.setVisible(false);
		}else{
			 _drag_but.setVisible(true);
			 
			var _h = int((_pageSize/(_maxPos-_minPos))*_skin.getDragArea().getWidth());
			if(_h<10) _h = 10;
			 _drag_but.setSize(_h,this.getSize().getHeight());

			var _dragArea_width = _skin.getDragArea().getWidth();
			var _dragArea_x = _skin.getDragArea().getX();
			
			var x:Number = (scrollPosition / (_maxPos - _minPos-_pageSize)) * (_dragArea_width-_h) + _dragArea_x;

			 _drag_but.setLocation(int(x),0);
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
			var left = _skin.getDragArea().getX();
			var rigth = _skin.getDragArea().getWidth()+left-_drag_but.getSize().getWidth();
			
			_drag_but.getDisplayObject().startDrag(false,left,0,rigth,0);

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
		var _drag_but_width = _drag_but.getSize().getWidth();
		var _drag_but_x = _drag_but.getLocation().getX();
		var _dragArea_width = _skin.getDragArea().getWidth();
		var _dragArea_x = _skin.getDragArea().getX();
		
		return ((_drag_but_x - _dragArea_x)/(_dragArea_width-_drag_but_width))*(_maxPos-_minPos-_pageSize);
	}
	

}