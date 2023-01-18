
/**
* XML객체를 오브젝트로 파싱해줍니다.
* @author 홍준수
*/

class com.acg.xml.DotXMLParser
{
	
	/**
	* XML을 파싱해서 오브젝트로 리턴합니다.
	* @param source 소스 XML
	* @return 오브젝트화된 XML
	*/
	
	public static function parse(source):Object
	{
		if (source == null)
			return null;

		var node:XMLNode;

		if(typeof(source) == "string")
		{
			var xmlObject:XML = new XML ();
			xmlObject.ignoreWhite = true;
			xmlObject.parseXML (source);
			node = xmlObject;
		}
		else if(source instanceof XMLNode)
		{
			node = source;
		}
		else
		{
			return null;
		}

		var dotXML:Object = new Object ();
		for (var a:String in node.attributes) //attributes
		{
			dotXML[a] = node.attributes[a];
		}
		
		if(node.nodeType == 3) //text node
		{
			dotXML._name = node.nodeName;
			dotXML._value = node.nodeValue;
		}
		else if ((node.childNodes.length > 0) && (node.childNodes[0].nodeType == 3)) 
		{	
			dotXML._name =  node.nodeName;
			dotXML._value = DotXMLParser.__parseChildrenAsText(node); 
		}
		else
		{
			for(var i:Number = 0; i < node.childNodes.length; i++)
			{
				var child:XMLNode = node.childNodes[i];
				var childName:String = child.nodeName;
				var children:Array = dotXML[childName];
				if (!(children instanceof Array))
				{
					children = dotXML[childName] = new Array ();
				}
				children.push(parse(child));
			}
		}
		
		return dotXML;
	}
		
	private static function __parseChildrenAsText(node:XMLNode):String
	{
		var nodeString:String = "";
		
		for(var i:Number = 0; i < node.childNodes.length; i++)
		{
			var childNode:XMLNode = node.childNodes[i];
			if (childNode.nodeType == 3)
			{
				nodeString += childNode.nodeValue;
			}
			else
			{
				nodeString += childNode.toString();
			}
		}
		return nodeString;
	}
}
