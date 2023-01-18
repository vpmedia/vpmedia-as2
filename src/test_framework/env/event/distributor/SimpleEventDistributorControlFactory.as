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


import test_framework.env.event.distributor.EventDistributorControl;
import test_framework.env.event.distributor.EventDistributorControlFactory;
import test_framework.env.event.distributor.SimpleEventDistributorControl;

/**
 * {@code SimpleEventDistributorControlFactory} creates instances of class
 * {@link SimpleEventDistributorControl}
 * 
 * @author Martin Heidegger
 */
class test_framework.env.event.distributor.SimpleEventDistributorControlFactory implements EventDistributorControlFactory {
	
	/**
	 * Creates a new instance of class {@code SimpleEventDistributorControl}.
	 * 
	 * @param type the distributor and listener type of the new event distributor
	 * control
	 * @return an instance of class {@code SimpleEventDistributorControl} that is
	 * configured with the given {@code type}
	 */
	public function createEventDistributorControl(type:Function):EventDistributorControl {
		return new SimpleEventDistributorControl(type);
	}
	
}