/**
 * @author Krasimir
 */
interface gugga.commands.IPopupCommandReciever 
{
	public function openPopup(aPopupContentPath:String, aPopupXPosition:Number, aPopupYPosition:Number);
	public function closePopup();
}