/*
 * generated by Xtext 2.18.0.M3
 */
package eu.quanticol.moonlight.xtext.tests

import com.google.inject.Inject
import eu.quanticol.moonlight.xtext.moonLightScript.Model
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import eu.quanticol.moonlight.xtext.generator.ScriptToJava
import eu.quanticol.moonlight.compiler.MoonlightCompiler
import eu.quanticol.moonlight.MoonLightScript

@ExtendWith(InjectionExtension)
@InjectWith(MoonLightScriptInjectorProvider)
class TestCompiler {
	@Inject
	ParseHelper<Model> parseHelper
	
	@Test
	def void loadModel() {
		val result = parseHelper.parse('''
			type poiType = BusStop|Hospital|MetroStop|MainSquare|Museum;		
			
			monitor City {
				signal { bool taxi; int peole; }
				space { locations {poiType poi; }
				edges { real length; }
				}
				domain boolean;
				formula somewhere [0.0, 1.0] #[ taxi ]#;
			}
			
			monitor Temporal( int a, int b) {
				signal { bool x; real y; int z; }
				domain boolean;
				formula eventually [a,b] #[ y>0 ]#;
			}
		''')
		Assertions.assertNotNull(result)
		val errors = result.eResource.errors
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
	}
	
	@Test
	def void generateJavaCode() {
		val result = parseHelper.parse('''
			type poiType = BusStop|Hospital|MetroStop|MainSquare|Museum;		
			
			monitor City {
				signal { bool taxi; int peole; }
				space { locations {poiType poi; }
				edges { real length; }
				}
				domain boolean;
				formula somewhere [0.0, 1.0] #[ taxi ]#;
			}
			
		''')
		val scriptToJava = new ScriptToJava();		
		val generatedCode = scriptToJava.getJavaCode(result,"moonlight.test","CityMonitor")
		Assertions.assertNotNull(generatedCode)
	}
	
	@Test
	def void compileAndLoadClass() {
		val result = parseHelper.parse('''
			type poiType = BusStop|Hospital|MetroStop|MainSquare|Museum;		
			
			monitor City {
				signal { bool taxi; int peole; }
				space { locations {poiType poi; }
				edges { real length; }
				}
				domain boolean;
				formula somewhere [0.0, 1.0] #[ taxi ]#;
			}

			monitor City2 {
				signal { bool taxi; int peole; }
				space { locations {poiType poi; }
				edges { real length; }
				}
				domain boolean;
				formula somewhere [0.0, 1.0] #[ taxi ]#;
			}
			
		''')
		val scriptToJava = new ScriptToJava();		
		val generatedCode = scriptToJava.getJavaCode(result,"moonlight.test","CityMonitor")
		System.out.println(generatedCode);
		val comp = new MoonlightCompiler();
		val script = comp.getIstance("moonlight.test","CityMonitor",generatedCode.toString,typeof(MoonLightScript))
		Assertions.assertEquals(2, script.spatioTemporalMonitors.length)
	}	
	
	@Test
	def void testMonitorNameOrdered() {
		
	}	
}
