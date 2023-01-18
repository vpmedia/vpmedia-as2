import net.manaca.lang.IThrowable;
import net.manaca.lang.Throwable;

/**
 * Error 是 Throwable 的子类，用于指示合理的应用程序不应该试图捕获的严重问题。大多数这样的错误都是异常条件。
 * @author Wersling
 * @version 1.0, 2005-11-25
 */
class net.manaca.lang.error.BasicError extends Throwable implements IThrowable {
	private var className : String = "net.manaca.lang.error.BasicError";
	public function BasicError(message : String, thrower : Object, args : Array) {
		super(message, thrower, args);
	}

	public function cast(Void) : Void {
		Tracer.error(message+" At: "+this.getStackTrace().getThrower().className);
		throw new Error(message+" At: "+this.getStackTrace().getThrower().className);
	}

}