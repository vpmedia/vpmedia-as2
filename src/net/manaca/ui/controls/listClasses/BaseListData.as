import net.manaca.ui.controls.UIComponent;
/**
 * 基本的列表数据
 * @author Wersling
 * @version 1.0, 2006-6-4
 */
class net.manaca.ui.controls.listClasses.BaseListData {
	private var className : String = "net.manaca.ui.controls.listClasses.BaseListData";
	/**
	 * 数据所有者
	 */
	public var owner:UIComponent;
	/**
	 * 指示列中的位置
	 */
	public var rowIndex : Number;
	/**
	 * 数据
	 */
	public var data : Object;
	/**
	 * 构造函数
	 * @param data:Object - 数据
	 * @param owner:UIComponent - 数据所有者
	 * @param rowIndex:Number 指示数据中列的位置
	 */
	public function BaseListData(data:Object,owner:UIComponent,rowIndex:Number) {
		this.data = data;
		this.owner = owner;
		this.rowIndex = rowIndex;
	}
}