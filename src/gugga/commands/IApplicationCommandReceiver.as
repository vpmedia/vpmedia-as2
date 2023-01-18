import gugga.application.ApplicatiotionNavigationalStateMemento;
/**
 * @author Krasimir
 */
interface gugga.commands.IApplicationCommandReceiver 
{
	
	public function CreateNavigationState():ApplicatiotionNavigationalStateMemento;
	public function NavigateTo(aPath:String);
	public function SetNavigationState(aMemento:ApplicatiotionNavigationalStateMemento);
}