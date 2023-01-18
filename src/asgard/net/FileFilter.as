 /*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import vegas.core.CoreObject;

/**
 * The FileFilter class is used to indicate what files on the user's system are shown in the file-browsing dialog box that 
 * is displayed when {@code FileReference.browse()} or {@code FileReferenceList.browse()} is called. 
 * FileFilter instances are passed to a browse() function. 
 * If you use a FileFilter instance, extensions and file types that aren't specified in the FileFilter instance are filtered out; that is, they are not available to the user to select for uploading. If no FileFilter object is passed to browse(), all files are shown in the dialog box.
 * 
 * <p>You can use FileFilter instances in one of two ways :
 * <ul>
 * <li>A description with Windows file extensions only</li>
 * <li>A description with Windows file extensions and Macintosh file types</li>
 * </ul>
 * </p>
 * <p>The two formats are not interchangeable within a single browse() call. You must use one or the other.</p>
 * <p>You can pass one or more FileFilter instances to {@code FileReference.browse()} or {@code FileReferenceList.browse()}. 
 * The following examples show different ways to create and pass {@code FileFilter} instances to a {@code browse()} call (for Windows only). 
 * The first example creates FileFilter instances outside of the browse() call:</p>
 * {@code
 * var imagesFilter:FileFilter = new FileFilter("Images", "*.jpg;*.gif;*.png") ;
 * var docFilter:FileFilter    = new FileFilter("Documents", "*.pdf;*.doc;*.txt") ;
 * var myFileReference:FileReference = new FileReference() ;
 * myFileReference.browse([imagesFilter, docFilter]) ;
 * }
 * <p>The second example creates FileFilter instances within the browse() call:</p>
 * {@code
 * myFileReference.browse( [ new FileFilter("Images", "*.jpg;*.gif;*.png"), new FileFilter("Flash Movies", "*.swf") ] );
 * }
 * The list of extensions in the FileFilter.extension property is used to filter the files in Windows, 
 * depending on the file selected by the user. 
 * It is not actually displayed in the dialog box; to display the file types for users, you must list the file 
 * types in the description string as well as in the extension list. 
 * The description string is displayed in the dialog box in Windows. 
 * (It is not used on the Macintosh.) On the Macintosh, if you supply a list of Macintosh file types, that list is used to filter the files. 
 * If not, the list of Windows extensions is used.
 * @author eKameleon
 */
class asgard.net.FileFilter extends CoreObject 
{

	/**
	 * Creates a new FileFilter instance.
	 * @param description The description string that is visible to users when they select files for uploading.
	 * @param extension A list of file extensions that indicate which Windows file formats are visible to users when they select files for uploading.
	 * @param macType A list of Macintosh file types that indicate which file types are visible to users when they select files for uploading.
	 */	
	public function FileFilter( description:String, extension:String, macType:String ) 
	{
		this.description = description || "" ;
		this.extension   = extension   || "" ;
		this.macType     = macType     || "" ;
	}
	
	/**
	 * The description string for the filter.
	 * The description is visible to the user in the dialog box that opens when 
	 * {@code FileReference.browse()} or {@code FileReferenceList.browse()} is called. 
	 * The description string contains a string, such as "Images (*.gif, *.jpg, *.png)", 
	 * that can help instruct the user on what file types can be uploaded or downloaded. 
	 * Note that the actual file types that are supported by this FileReference object are stored in the extension  property.
	 */
	public var description:String ;

	/**
	 * The list o file extensions.
	 * This list indicates the types of files that you want to show in the file-browsing dialog box. 
	 * (The list is not visible to the user; the user sees only the value of the description property.) 
	 * The extension property contains a semicolon-delimited list of Windows file extensions, with a wildcard (*) preceding each extension, as shown in the following string: "*.jpg;*.gif;*.png".
	 */
	public var extension:String ;
	
	/**
	 * The list of Macintosh file types.
	 * This list indicates the types of files that you want to show in the file-browsing dialog box. 
	 * (This list itself is not visible to the user; the user sees only the value of the description property.) 
	 * The macType property contains a semicolon-delimited list of Macintosh file types, as shown in the following string: "JPEG;jp2_;GIFF".
	 */
	public var macType:String ;

}