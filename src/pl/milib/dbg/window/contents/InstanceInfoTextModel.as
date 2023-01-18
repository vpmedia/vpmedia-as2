/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
import pl.milib.core.MIObjSoul;
import pl.milib.data.LimitedLengthArray;
import pl.milib.data.TextModel;
import pl.milib.dbg.MIDBGUtil;
import pl.milib.util.MILibUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.dbg.window.contents.InstanceInfoTextModel extends TextModel {

	private var obj : Object;
	
	private function InstanceInfoTextModel(obj:Object) {
		super(true, 100);
		this.obj=obj;
	}//<>
	
	private function getText(Void):String {
		lines=new LimitedLengthArray(lines.lengthLimit);
				var zuper=MILibUtil.getSuperByInstance(obj);
		var supers=[zuper];
		while(zuper=MILibUtil.getSuperByConstructor(zuper)){
			supers.push(zuper);
		}
		var supersNames:Array=['<b>'+MIDBGUtil.formatClassNameText(MILibUtil.getClassNameByInstance(obj))+'</b>'];
		for(var i=0;i<supers.length;i++){
			supersNames.push(MIDBGUtil.formatClassNameText(MILibUtil.getClassNameByConstructor(supers[i])));
		}
		lines.push(MILibUtil.getPackageFullNameByInstance(obj)+'.'+supersNames.join(' > '));
		
		var animations:Array=MILibUtil.getObjectMILibObject(obj).animations;
		if(animations.length){
			lines.push('Animations>'+link(animations));
		}
		
		lines.push('\n'+obj.getDBGInfo().join('\n'));
		
		return super.getText();
	}//<<
	
	static public function forInstance(obj:Object):InstanceInfoTextModel {
		var milibObjObj:Object=MILibUtil.getObjectMILibObject(obj);
		if(!milibObjObj.forInstanceInfoTextModel.o){ milibObjObj.forInstanceInfoTextModel=MIObjSoul.forInstance(new InstanceInfoTextModel(obj)); }
		return milibObjObj.forInstanceInfoTextModel.o;
	}//<<
		
	static public function hasInstance(obj:Object):Boolean {
		return MILibUtil.getObjectMILibObject(obj).forInstanceInfoTextModel.o!=null;
	}//<<
		
}