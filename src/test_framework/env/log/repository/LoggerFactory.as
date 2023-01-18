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
 

import test_framework.env.log.Logger;

/**
 * {@code LoggerFactory} is used to obtain loggers.
 *
 * <p>What loggers are returned depends on the specific implementation.
 *
 * @author Simon Wacker
 */
interface test_framework.env.log.repository.LoggerFactory  {
	
	/**
	 * Returns a logger.
	 *
	 * @return a logger
	 */
	public function getLogger(name:String):Logger;
	
}