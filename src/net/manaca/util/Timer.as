import net.manaca.lang.BObject;
//Source file: D:\\Wersling WAS Framework\\javacode\\was\\util\\Timer.java

//package was.util;


/**
 * 一种线程设施，用于安排以后在后台线程中执行的任务。可安排任务执行一次，或者定期重复执行。 
 * 
 * 与每个 Timer 对象相对应的是单个后台线程，用于顺序地执行所有计时器任务。计时器任务应该迅速完成。如果完成某个计时器任务的时间太长，那么它会“独占”计时器的任务执行线程。因此，这就可能延迟后续任务的执行，而这些任务就可能“堆在一起”，并且在上述令人讨厌的任务最终完成时才能够被快速连续地执行。 
 * 
 * 对 Timer 对象最后的引用完成后，并且 所有未处理的任务都已执行完成后，计时器的任务执行线程会正常终止（并且成为垃圾回收的对象）。但是这可能要很长时间后才发生。默认情况下，任务执行线程并不作为守护线程 来运行，所以它能够阻止应用程序终止。如果调用方想要快速终止计时器的任务执行线程，那么调用方应该调用计时器的 cancel 方法。 
 * 
 * 如果意外终止了计时器的任务执行线程，例如调用了它的 stop 方法，那么所有以后对该计时器安排任务的尝试都将导致 IllegalStateException，就好像调用了计时器的 cancel 方法一样。 
 * 
 * 此类是线程安全的：多个线程可以共享单个 Timer 对象而无需进行外部同步。 
 * 
 * 此类不 提供实时保证：它使用 Object.wait(long) 方法来安排任务。 
 * 
 * 实现注意事项：此类可扩展到大量同时安排的任务（存在数千个都没有问题）。在内部，它使用二进制堆来表示其任务队列，所以安排任务的开销是 O(log n)，其中 n 是同时安排的任务数。 
 * 
 * 实现注意事项：所有构造方法都启动计时器线程。
 * @author Wersling
 * @version 1.0
 */
class net.manaca.util.Timer extends BObject
{
	private var className : String = "net.manaca.util.Timer";
	/**
	 * @roseuid 4382EC59031C
	 */
	
	private var _upMinute:Number;
	private var eventList:Array = new Array();
	
	/** 构造器 */
	public function Timer()
	{
		_upMinute = FormatSec(getTimer());
		setInterval(this, "Jerque", 1000);
	}
	
	/** 刷新 */
	public function Refresh():Void{
		_upMinute = FormatSec(getTimer());
	}
	
	/**
	 * 添加触发器 
	 * @param time 时间长度，单位 秒
	 * @param fun  触发的函数
	 */
	public function AddTrigger(time:Number,_this:Object,fun:Function):Void
	{
		eventList.push({time:time,Obj:_this,fun:_this.fun});
	}
	
	/** 检查触发 */
	private function Jerque():Void
	{
		var nowTime:Number = FormatSec(getTimer());
		var Obj:Object = JerqueList(nowTime - _upMinute);
		if (Obj != undefined){
			Obj.fun.apply(Obj.Obj);
		}
	}
	
	/** 毫秒转为秒 */
	private function FormatSec(n:Number):Number{
		return Math.round(n/1000);
	}
	
	/** 检查列表 */
	private function JerqueList(time:Number):Object
	{
		var i:Number = eventList.length;
		while(--i-(-1))
		{
			if (eventList[i].time == time) return eventList[i];
		}
		return null;
	}
}
