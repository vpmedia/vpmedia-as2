/**
 * @author Todor Kolev
 */
interface gugga.common.ICommand 
{
	public function execute():Void;
	public function isReversible():Boolean;
	public function undo():Void;
	public function clone():ICommand;
}