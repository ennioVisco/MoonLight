/*******************************************************************************
 * MoonLight: a light-weight framework for runtime monitoring
 * Copyright (C) 2018 
 *
 * See the NOTICE file distributed with this work for additional information
 * regarding copyright ownership.  
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *******************************************************************************/
package eu.quanticol.moonlight.formula;

/**
 *
 */
public class DoubleDomain implements DomainModule<Double> {

	@Override
	public Double conjunction(Double x, Double y) {
		return Math.min(x, y);
	}

	@Override
	public Double disjunction(Double x, Double y) {
		return Math.max(x, y);
	}

	@Override
	public Double negation(Double x) {
		return -x;
	}

	@Override
	public Double min() {
		return Double.NEGATIVE_INFINITY;
	}

	@Override
	public Double max() {
		return Double.POSITIVE_INFINITY;
	}

	@Override
	public Double[] createArray(int size) {
		return new Double[size];
	}

}
