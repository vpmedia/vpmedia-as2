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

import pl.milib.core.supers.MIRunningClass;
import pl.milib.managers.EnterFrameRenderManager;
import pl.milib.mc.service.MIMC;
import pl.milib.util.MILibUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.abstract.AbstractContentMCA extends MIRunningClass {

	/*abstract*/ public var ID : String;
	public var mimc : MIMC;
	
	public function AbstractContentMCA() {
		EnterFrameRenderManager.getInstance().addRenderMethod(this, unsetupMC, true);
	}//<>
	
	/*abstract*/public function doSetupMC(Void):Void {}//<<	/*abstract optional*/public function doUnsetupMC(Void):Void {}//<<
	
	public function setupMC(mc:MovieClip):Void {
		mimc=MIMC.forInstance(mc);
		mimc['_contentClass']=this;
		MILibUtil.getMCMILibMC(mc).contentClass=this;
		doSetupMC();
	}//<<
	
	private function unsetupMC(Void):Void {
		if(!mimc.mc){
//			logError_UnexpectedSituation(arguments, '!mimc.mc');
//			doUnsetupMC();
//			delete mimc;
		}
	}//<<
	
	public function getID(Void):String {
		return ID;
	}//<<
	
	private function doFinish(Void):Boolean {
		unsetupMC();
		return true;
	}//<<
	
	static public function getMCCotent(mc:MovieClip):AbstractContentMCA {
		return AbstractContentMCA(MILibUtil.getMCMILibMC(mc).contentClass);
	}//<<
	
}