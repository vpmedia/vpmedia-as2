import net.manaca.lang.exception.Exception;

/**
 * 基本类型不匹配错误抛出类
 * @author Wersling
 * @version 1.0, 2005-9-1
 */
class net.manaca.lang.exception.IllegalStateException extends Exception
{
	/*
	 * 构造函数
	 * @param 无
	 */
	public function IllegalStateException(message:String, thrower:Object, args:Array) {
		super(message, thrower, args);
	}
}
