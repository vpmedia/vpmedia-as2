import com.bumpslide.example.history.demo2.BaseClip;
import com.bumpslide.util.*;
import mx.controls.Button;

class com.bumpslide.example.history.demo2.BottomBar extends BaseClip
{
	var link_btn:Button;
	
	function onLoad() {
		super.onLoad();
		link_btn.addEventListener('click', Delegate.create( this, linkToThisPage ) );
	}
	
	function linkToThisPage() {
		_root.getURL( 'historyDemo2.html?'+model.history.getSerialized(), '_top');		
	}
}
