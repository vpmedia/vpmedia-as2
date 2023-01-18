import net.manaca.ui.controls.listClasses.BaseUIListItemRenderer;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-6-9
 */
class net.manaca.ui.controls.listClasses.IconsUIListItemRenderer extends BaseUIListItemRenderer {
	private var className : String = "net.manaca.ui.controls.listClasses.IconsUIListItemRenderer";
	public function IconsUIListItemRenderer() {
		super();
	}
	public function updateChildComponent() : Void {
		var _w:Number = _selected_mc._width;
		var _h:Number = _selected_mc._height;
		_labelHolder._width = _w;
		_labelHolder._x = 0;
		_labelHolder._y = _h - 16;
		
		_iconHolder._y = 0;
		_iconHolder._x = Math.max(int((_w-_iconHolder._width)/2),0);
	}
	
	public function getPreferredWidth() : Number {
		return 50;
	}

	public function getPreferredHeight() : Number {
		return 70;
	}
}