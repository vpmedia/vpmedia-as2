// =========================================================================================
// Class: DocumentUtil
// 
// Ryan Taylor
// February 19, 2007
// http://www.boostworthy.com
// =========================================================================================
// 
// +          +          +          +          +          +          +          +          +
// 
// =========================================================================================

class com.boostworthy.utils.DocumentUtil
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// This is a utility class, so the constructor isn't actually used.
	private function DocumentUtil()
	{
	}
	
	// =====================================================================================
	// DOCUMENT FUNCTIONS
	// =====================================================================================
	
	// RegisterClass
	// 
	// Registers the passed document and class together, thus creating a document class.
	// The document class constructor is invoked upon this method being called. 
	public static function RegisterClass(mcDocument:MovieClip, objClass:Object):Void
	{
		// Set the prototype reference to the document classes constructor
		// prototype property.
		mcDocument.__proto__ = objClass.prototype;
		
		// Invoke the document class' constructor within the scope of the document.
		Function(objClass).apply(mcDocument, null);
	}
}