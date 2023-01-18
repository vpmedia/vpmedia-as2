import net.manaca.lang.exception.Exception;

/**
 * 基本参数错误抛出类
 * @author Wersling
 * @version 1.0, 2005-9-1
 */
class net.manaca.lang.exception.IllegalArgumentException extends Exception
{
	/*
	 * 构造函数
	 * @param 无
	 */
	public function IllegalArgumentException(message:String, thrower:Object, args:Array)
	{
		super(message, thrower, args);

	}
}
