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
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.^extension.ExtendWith
import eu.quanticol.moonlight.xtext.generator.ScriptToJava
import eu.quanticol.moonlight.compiler.MoonlightCompiler
import eu.quanticol.moonlight.MoonLightScript


@ExtendWith(InjectionExtension)
@InjectWith(MoonLightScriptInjectorProvider)
class TestSensorScript {
  @Inject
  ParseHelper<Model> parseHelper

  @Test
  	def void generateJavaCode() {
  		val result = parseHelper.parse('''
   			monitor SensorNetwork {
                signal { int nodeType; real x; real y; real battery; real temperature; }
             	space {
             	edges { int hop; real weight; }
             	}
             	domain minmax;
             	formula everywhere [0.0, 1.0] #[ (battery - 0.5)  & (temperature > 20)]#;
             }

  		''')
  		val scriptToJava = new ScriptToJava();
  		val generatedCode = scriptToJava.getJavaCode(result,"moonlight.test","Sensor")
  		System.out.println(generatedCode);
  		}

}