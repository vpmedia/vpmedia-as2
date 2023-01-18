import net.manaca.ui.controls.listClasses.BaseListData;
import net.manaca.ui.controls.UIComponent;

/**
 * 列表数据对象
 * @author Wersling
 * @version 1.0, 2006-6-4
 */
class net.manaca.ui.controls.listClasses.ListData extends BaseListData {
	private var className : String = "net.manaca.ui.controls.listClasses.ListData";
	/**
	 * 显示的文本
	 */
	public var labelField : String;
	/**
	 * 显示的图标
	 */
	public var icon : String;
	/**
	 * 构造函数
	 * @param labelField:String - 文本
	 * @param icon:String - 图标
	 * @param data:Object - 数据
	 * @param owner:UIComponent - 数据所有者
	 * @param rowIndex:Number 指示数据中列的位置
	 */
	public function ListData(labelField:String,icon:String,data:Object,owner : UIComponent, rowIndex : Number) {
		super(data,owner, rowIndex);
		this.labelField = labelField;
		this.icon = icon;
	}

}