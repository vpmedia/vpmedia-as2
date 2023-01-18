import gugga.application.Section;
import gugga.application.SectionsController;
import gugga.components.ISectionLoader;

/**
 * @author Todor Kolev
 */
class gugga.application.TransitionInfo 
{
	public var SectionsController : SectionsController;
	public var CurrentSection : Section;
	public var DetachCurrentSectionAfterClose : Boolean;
	public var TargetSection : Section;
	public var TargetSectionLoader : ISectionLoader;
	public var DoLoadTargetSection : Boolean;
	public var SectionPathRest : String;

	public function TransitionInfo(aSectionsController:SectionsController, 
		aCurrentSection:Section, aDetachCurrentSectionAfterClose:Boolean,
		aTargetSection:Section, aTargetSectionLoader:ISectionLoader, aDoLoadTargetSection:Boolean,
		aSectionPathRest:String) 
	{
		this.SectionsController = aSectionsController;
		this.CurrentSection = aCurrentSection;
		this.DetachCurrentSectionAfterClose = aDetachCurrentSectionAfterClose;
		this.TargetSection = aTargetSection;
		this.TargetSectionLoader = aTargetSectionLoader;
		this.DoLoadTargetSection = aDoLoadTargetSection;
		this.SectionPathRest = aSectionPathRest;
	}	
}