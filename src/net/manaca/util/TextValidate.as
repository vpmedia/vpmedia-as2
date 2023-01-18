/**
 * 文本框验证
 * @author Wersling
 * @version 1.0, 2006-3-29
 */
class net.manaca.util.TextValidate {
	/**
	 * 文本框是否为非空
	 */
	static function IsNoEmpty(t:TextField):Boolean{
		return (t.text != undefined && t.text != "");
	}
	
	/**
	 * 全数字
	 */
	static function AllNumber(t:TextField):Boolean{
		return !isNaN(Number(t.text)+1);
	}
}