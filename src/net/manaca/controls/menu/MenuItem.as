import net.manaca.ui.UIListCell;

/**
 * 
 * @author Wersling
 * @version 1.0, 2005-12-5
 */
class net.manaca.controls.menu.MenuItem extends UIListCell {
	private var className : String = "net.manaca.controls.menu.MenuItem";
	private var _Text:TextField;
	private var _childItemIcon:MovieClip;
	/**
	 * 构造函数
	 * @param 无
	 */
	public function MenuItem() {
		super();
	}
	public function onLoad():Void{
		super.onLoad();
		_childItemIcon._visible = false;
		Init();
	}
	private function Init():Void
	{
		super.init();
		_Text.text = Item.attributes.label;
		if(Item.childNodes.length > 0) _childItemIcon._visible = true;
	}
	private function onRelease():Void
	{
		dispatchEvent({type:"onListCellRelease",target:this});
		// 在这里设置当点击过后所触发的事件

	}
}