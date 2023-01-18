import net.manaca.lang.IThrowable;
import net.manaca.lang.Throwable;
import net.manaca.io.file.FlashSlide;

/**
 * Exception 类及其子类是 Throwable 的一种形式，它指出了合理的应用程序想要捕获的条件。
 * @author Wersling
 * @version 1.0, 2005-11-25
 */
class net.manaca.lang.exception.Exception extends Throwable implements IThrowable {
	private var className : String = "net.manaca.lang.exception.Exception";
	public function Exception(message : String, thrower : Object, args : Array) {
		super(message, thrower, args);
	}

	public function cast(Void) : Void {
		Tracer.warn(message +" At: "+ this.getStackTrace().getThrower()["className"]);
		var args = this.getStackTrace().getArguments();
		trace("         args : ");
		for(var i in args) trace('                  key: ' + i + ', value: ' + args[i]); 
	}
}