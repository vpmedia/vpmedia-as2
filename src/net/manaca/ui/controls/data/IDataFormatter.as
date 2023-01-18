/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-22
 */
interface net.manaca.ui.controls.data.IDataFormatter {
	/**
	 * 格式化数据
	 */
	public function format(rawValue);
	
	/**
	 * 反格式化数据
	 */
	public function unformat(formattedValue);
}