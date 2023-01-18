import gugga.application.ISection;
import gugga.application.SectionsTransition;

/**
 * @author Todor Kolev
 */
interface gugga.application.ISectionsController extends ISection 
{
	public function openSection(aSectionPath:String) : SectionsTransition;	
}