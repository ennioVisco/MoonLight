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
class TestRandomFormulaeScript {
  @Inject
  ParseHelper<Model> parseHelper

  @Test
  def void loadModel() {
  		val result = parseHelper.parse('''
			signal { real x; real y; real z;}
			domain minmax;
			formula aFormula = globally  [73.01,98.272] ( x > 0 );
  		''')
    Assertions.assertNotNull(result)
    val errors = result.eResource.errors
    Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
  }

  @Test
  	def void generateJavaCode() {
  		val result = parseHelper.parse('''
			signal { real x; real y; real z;}
			domain minmax;
			formula aFormula = globally  [73.01,98.272] ( x > 0);
  		''')
  		val scriptToJava = new ScriptToJava();
  		val generatedCode = scriptToJava.getJavaCode(result,"moonlight.test","RandomFormulae")
  		System.out.println(generatedCode);
		val comp = new MoonlightCompiler();
		comp.getIstance("moonlight.test","RandomFormulae",generatedCode.toString,typeof(MoonLightScript))
  		}

}