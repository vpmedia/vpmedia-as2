import net.manaca.lang.event.IEventDispatcher;
/**
 * 一个基本的数据提供对象接口，如果组件对数据进行绑定，数据提供者在数据发生改变的时候必须
 * 通过 dataChanged 事件 通知组件。
 * 主要用于List、DataGrid等对象，用于数据于显示同步和组件之间的数据同步。
 * @author Wersling
 * @version 1.0, 2006-5-22
 */
interface net.manaca.ui.controls.data.IDataProvider extends IEventDispatcher{
	/**
	 * 通知组件数据更新
	 */
	public function updateViews():Void;
}