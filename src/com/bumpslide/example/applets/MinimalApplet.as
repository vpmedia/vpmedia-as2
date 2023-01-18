/**
* This is a barebones MTASC Applet
* 
* @mtasc -swf com/bumpslide/example/applets/MinimalApplet.swf -header 500:400:31:eeeedd -main 
*/
class com.bumpslide.example.applets.MinimalApplet
{	
	static function main( mc:MovieClip ) : Void {
		mc.createTextField('message_txt', mc.getNextHighestDepth(), 10, 10, 500, 100);
		mc.message_txt.text = "Hello, World";
	}
}