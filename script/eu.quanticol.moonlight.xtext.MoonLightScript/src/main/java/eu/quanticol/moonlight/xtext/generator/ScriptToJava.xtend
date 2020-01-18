package eu.quanticol.moonlight.xtext.generator

import eu.quanticol.moonlight.xtext.moonLightScript.Model
import eu.quanticol.moonlight.xtext.moonLightScript.Monitor
import eu.quanticol.moonlight.xtext.moonLightScript.TypeDefinition
import eu.quanticol.moonlight.xtext.moonLightScript.SemiringExpression
import eu.quanticol.moonlight.xtext.moonLightScript.MinMaxSemiring
import eu.quanticol.moonlight.xtext.moonLightScript.BooleanSemiring
import eu.quanticol.moonlight.xtext.moonLightScript.StrelFormula
import eu.quanticol.moonlight.xtext.moonLightScript.StrelOrFormula

class ScriptToJava {
	
	def getJavaCode( Model model, String packageName , String className ) {
		'''
		/**
		 * Code Generate by MoonLight tool.
		 */ 
		package «packageName»;
		
		import eu.quanticol.moonlight.*;
		import eu.quanticol.moonlight.monitoring.temporal.*;
		import eu.quanticol.moonlight.monitoring.spatiotemporal.*;
		import eu.quanticol.moonlight.signal.*;
		import eu.quanticol.moonlight.util.*;
		import eu.quanticol.moonlight.*;
		import eu.quanticol.moonlight.formula.*;
		import java.util.function.Function;
		import java.util.HashSet;
		import java.util.HashMap;
		
		
		public class «className» extends MoonLightScript {			
			
			
			«FOR m: model.elements.filter(typeof(Monitor))»
			private final SignalDomain<«m.semiring.javaTypeOf»> «m.name.domainVariable» = new «m.semiring.domainOf»();
			«ENDFOR»
			
			«FOR m: model.elements.filter(typeof(Monitor))»
			«m.formula.generateGenerateFormulaBuilderDeclaration("MAIN",m)»
			«FOR f: m.subformulas»
			«f.formula.generateGenerateFormulaBuilderDeclaration(f.name,m)»
			«ENDFOR»
			«ENDFOR»
			
			
			«FOR m: model.elements.filter(typeof(Monitor))»
			«m.generateMonitorDeclaration»
			«ENDFOR»
			
			«FOR generatedEnum: model.elements.filter(typeof(TypeDefinition))»
			public static enum «generatedEnum.name» {
				«FOR e: generatedEnum.elements SEPARATOR ','»	
				«e.name»
				«ENDFOR»
			}
			«ENDFOR»
			
			public «className»() {
				super( new String[] { 
					«FOR m: model.elements.filter(typeof(Monitor)) SEPARATOR ','»«IF !m.isIsSpatial»
					"«m.name»"
					«ENDIF»«ENDFOR»					
				}, 
				new String[] {
					«FOR m: model.elements.filter(typeof(Monitor)) SEPARATOR ","»«IF m.isIsSpatial»
					"«m.name»"
					«ENDIF»«ENDFOR»					
				});	
			}
		
			@Override
			public TemporalScriptComponent<?> selectTemporalComponent( String name ) {
				return null;	
			}				

			public SpatioTemporalScriptComponent<?> selectSpatioTemporalComponent( String name ) {
				return null;	
			}

			public TemporalScriptComponent<?> selectDefaultTemporalComponent( ) {
				return null;	
			}
				
			public SpatioTemporalScriptComponent<?> selectDefaultSpatioTemporalComponent( ) {
				return null;	
			}
		
		
		}
		'''
		
		
	}
	
	def getDomainVariable(String name) {
		'''_domain_«name»'''
	}

	def  generateGenerateFormulaBuilderDeclaration(StrelFormula f, String name, Monitor monitor) {
		if (monitor.isIsSpatial) {
			'''private Function<Record,SpatioTemporalMonitor<Record,Record,«monitor.semiring.javaTypeOf»>> «monitor.name»_FORMULA_«name» = parameters -> null;'''
		} else {
			'''private Function<Record,TemporalMonitor<Record,«monitor.semiring.javaTypeOf»>> «monitor.name»_FORMULA_«name» = parameters -> null;'''
		}
	}
	
	
	def  generateMonitorDeclaration(Monitor monitor) {
		if (monitor.isIsSpatial) {
			'''private SpatioTemporalScriptComponent<«monitor.semiring.javaTypeOf»> MONITOR_«monitor.name» = null;'''
		} else {
			'''private TemporalScriptComponent<«monitor.semiring.javaTypeOf»> MONITOR_«monitor.name» = null;'''
		}
	}
	
	def CharSequence javaTypeOf(SemiringExpression e) {
		switch e {
//		TropicalSemiring: '''Double'''
		MinMaxSemiring: '''Double'''
		BooleanSemiring: '''Boolean'''
//		PairSemiring: '''Pair<«e.left.javaTypeOf»,«e.right.javaTypeOf»>'''
		default: '''?'''			
		}
	}

	def CharSequence domainOf(SemiringExpression e) {
		switch e {
//		TropicalSemiring: '''Double'''
		MinMaxSemiring: '''DoubleDomain'''
		BooleanSemiring: '''BooleanDomain'''
//		PairSemiring: '''Pair<«e.left.javaTypeOf»,«e.right.javaTypeOf»>'''
		default: '''?'''			
		}
	}
	
	def dispatch CharSequence temporalMonitorCode(StrelFormula f, String prefix, String domain) {
		'''null'''
	} 
	
	def dispatch CharSequence temporalMonitorCode(StrelOrFormula f, String prefix, String domain) {
		'''
		null
		'''
	}
	
}