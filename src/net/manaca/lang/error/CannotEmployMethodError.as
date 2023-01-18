import net.manaca.lang.error.BasicError;

/**
 * 不能调用的方法，这个是在子类不希望继承父类一些方法的时候，如果有对象调用则抛出此错误。
 * @author Wersling
 * @version 1.0, 2005-12-27
 */
class net.manaca.lang.error.CannotEmployMethodError extends BasicError {
	private var className : String = "net.manaca.lang.error.CannotEmployMethodError";
	public function CannotEmployMethodError(message : String, thrower : Object, args : Array) {
		super(message, thrower, args);
	}

}