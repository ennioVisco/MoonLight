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

@ExtendWith(InjectionExtension)
@InjectWith(MoonLightScriptInjectorProvider)
class MoonLightScriptParsingTest {
	@Inject
	ParseHelper<Model> parseHelper
	
	@Test
	def void loadModel() {
		//val result = parseHelper.parse('''
		//''')
		//Assertions.assertNotNull(result)
		//val errors = result.eResource.errors
		//Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
	}
}
