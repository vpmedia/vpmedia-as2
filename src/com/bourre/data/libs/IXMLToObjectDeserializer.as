import com.bourre.data.libs.XMLToObject;

interface com.bourre.data.libs.IXMLToObjectDeserializer 
{
	public function setOwner( owner : XMLToObject ) : Void;
	public function deserialize( target, node:XMLNode ) : Void;
}