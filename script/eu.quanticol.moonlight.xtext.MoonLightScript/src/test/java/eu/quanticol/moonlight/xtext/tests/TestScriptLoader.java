package eu.quanticol.moonlight.xtext.tests;

import static org.junit.jupiter.api.Assertions.*;

import java.io.File;
import java.io.IOException;

import org.junit.jupiter.api.Test;

import eu.quanticol.moonlight.MoonLightScript;
import eu.quanticol.moonlight.xtext.ScriptLoader;

class TestScriptLoader {

	@Test
	void testLoadScriptFromCodeQualitative() throws IOException {
		ScriptLoader loader = new ScriptLoader();
		MoonLightScript script = loader.compileScript("type poiType = BusStop|Hospital|MetroStop|MainSquare|Museum;		\n" + 
				"				signal { bool taxi; int peole; }\n" + 
				"				space { locations {poiType poi; }\n" + 
				"				edges { real length; }\n" + 
				"				}\n" + 
				"				domain boolean;\n" + 
				"				formula aFormula = somewhere [0.0, 1.0] ( taxi );\n");
		assertNotNull(script);
		
	}
		
	@Test
	void testLoadScriptFromCodeWithParameters() throws IOException {
		ScriptLoader loader = new ScriptLoader();
		MoonLightScript script = loader.compileScript("type poiType = BusStop|Hospital|MetroStop|MainSquare|Museum;		\n" + 
				"				signal { bool taxi; int peole; }\n" + 
				"				space { locations {poiType poi; }\n" + 
				"				edges { real length; "
				+ "						int hop; "
				+ "				}\n" + 
				"				}\n" + 
				"				domain boolean;\n" + 
				"				formula aFormula(real distance) = somewhere(hop) [0, distance] ( taxi );\n");
		assertNotNull(script);
		
	}

	@Test
	void testLoadScriptFromFile() throws IOException {
		ScriptLoader loader = new ScriptLoader();
		File file = new File(getClass().getClassLoader().getResource("testscript.mls").getFile());
		MoonLightScript script = loader.loadFile(file.getAbsolutePath());
		assertNotNull(script);
	}

//	@Test
//	void name() {
//		ScriptLoader loader = new ScriptLoader();
//		MoonLightScript script = loader.loadFile("C:\\Users\\Simone\\Documents\\git\\MoonLight\\api_resources\\testscript.mls");
//		System.out.println();
//
//
//	}
}
