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

import pl.milib.core.supers.MIClass;
import pl.milib.data.info.MIEventInfo;
import pl.milib.mc.MCDuplicator;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.DuplicatedMCSAutoY extends MIClass {

	private var dist : Number;
	private var iniPos : Number;
	private var dupl : MCDuplicator;
	private var axisName : String;
	
	public function DuplicatedMCSAutoY(dupl:MCDuplicator, isYAxis:Boolean) {
		this.dupl=dupl;
		dupl.addListener(this);
		axisName=isYAxis ? '_y' : '_x';
		iniPos=dupl.getMC(0)[axisName];		dist=dupl.getMC(1)[axisName]-dupl.getMC(0)[axisName];
		addDeleteWith(dupl);
	}//<>
	
//****************************************************************************
// EVENTS for DupliatedMCSAutoY
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case dupl:
				switch(ev.event){
					case dupl.event_NewMC:
						ev.data.mc[axisName]=iniPos+dist*ev.data.num;
					break;
				}
			break;
		}
	}//<<Events
	
}