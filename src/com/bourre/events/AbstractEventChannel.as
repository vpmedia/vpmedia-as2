import com.bourre.utils.ClassUtils;

class com.bourre.events.AbstractEventChannel 
	extends String
{
	private function AbstractEventChannel() 
	{
		super( ClassUtils.getFullyQualifiedClassName(this) );
	}
}