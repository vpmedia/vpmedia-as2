/**
 * @author Todor Kolev
 */
class gugga.utils.MemberNamesClassification 
{
	public var Variables : Array;
	public var Getters : Array;
	public var Setters : Array;
	public var Methods : Array;
	
	public function get Accessors() : Array
	{
		return Getters.concat(Setters);
	}

	public function get MethodsAndAccessors() : Array
	{
		return Methods.concat(Getters, Setters);
	}
	
	public function MemberNamesClassification(aVariables:Array, aGetters:Array, aSetters:Array, aMethods:Array)
	{
		Variables = (aVariables) ? aVariables : new Array();
		Getters = (aGetters) ? aGetters : new Array();
		Setters = (aSetters) ? aSetters : new Array();
		Methods = (aMethods) ? aMethods : new Array();
	}	
}