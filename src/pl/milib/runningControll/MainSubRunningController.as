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
import pl.milib.runningControll.MainRunningController;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.runningControll.MainSubRunningController extends MainRunningController {

	private var subRunner : MIRunningClass;
	
	public function setSubRunner(subRunner:MIRunningClass):Void {
		this.subRunner.removeListener(this);
		this.subRunner=subRunner;
		this.subRunner.addListener(this);
	}//<<
	
	public function setMainAndSubRunner(mainRunner:MIRunningClass, subRunner:MIRunningClass):Void {
		setMainRunner(mainRunner);		setSubRunner(subRunner);
	}//<<
	
}