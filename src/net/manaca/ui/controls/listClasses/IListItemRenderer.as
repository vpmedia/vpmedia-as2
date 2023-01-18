import net.manaca.ui.controls.core.IItemRenderer;
/**
 * IListItemRenderer 定义列表项目显示方法
 * @author Wersling
 * @version 1.0, 2006-6-4
 */
interface net.manaca.ui.controls.listClasses.IListItemRenderer extends IItemRenderer{
	/**
	 * 获取行位置
	 */
	public function getRowIndex():Object;
	
	/**
	 * 项目显示状态
	 * @param selected:String - 可能具有以下值："normal"、"highlighted" 和 "selected"
	 */
	public function setSelected(_selected : String);
}