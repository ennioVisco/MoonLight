package eu.quanticol.moonlight;

import static org.junit.jupiter.api.Assertions.*;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.function.BiFunction;

import org.junit.jupiter.api.Test;

import eu.quanticol.moonlight.signal.DataHandler;
import eu.quanticol.moonlight.signal.GraphModel;
import eu.quanticol.moonlight.signal.LocationService;
import eu.quanticol.moonlight.signal.LocationServiceList;
import eu.quanticol.moonlight.signal.Record;
import eu.quanticol.moonlight.signal.RecordHandler;
import eu.quanticol.moonlight.signal.SpatialModel;
import eu.quanticol.moonlight.signal.SpatialTemporalSignal;
import eu.quanticol.moonlight.xtext.ScriptLoader;

class TestSensorScript {
	
	private static RecordHandler edgeRecordHandler = new RecordHandler(DataHandler.REAL);
	private static RecordHandler signalRecordHandkler = new RecordHandler(DataHandler.INTEGER);
	
	
	private static String code = "signal { int nodeType; }\n" +
			"             	space {\n" + 
			"             	edges { int hop;}\n" + 
			"             	}\n" + 
			"             	domain boolean;\n" + 
			"             	formula aFormula = somewhere [0, 1] ( nodeType==1 );";

	@Test
	void test() throws IOException {		
		ScriptLoader sl = new ScriptLoader();
		MoonLightScript script = sl.compileScript(code);
		assertTrue( script.isSpatialTemporal() );
		MoonLightSpatialTemporalScript spatialTemporalScript = script.spatialTemporal();
		SpatialTemporalScriptComponent<?> stc = spatialTemporalScript.selectDefaultSpatialTemporalComponent();
        List<Integer> typeNode = Arrays.asList( 1, 3, 3, 3, 3);
        SpatialTemporalSignal<Record> signal = createSpatioTemporalSignal(typeNode.size(), 0, 1, 20.0,
                (t, l) -> signalRecordHandkler.fromObjectArray(typeNode.get(l)));
        SpatialTemporalSignal<?> res = stc.monitorFromDouble(createLocService(0.0, 1, 20.0, getGraphModel()), signal);
        assertEquals(true, res.getSignals().get(0).valueAt(0.0));        
        double[][][] oArray = stc.monitorToArrayFromDouble(createLocService(0.0, 1, 20.0, getGraphModel()), signal);
        assertEquals(1.0, oArray[0][0][1]);
//		stc.monitorToObjectArray(graph, signalTimeArray, signalValues, parameters)
	}

	
	private LocationService<Record> createLocService(double start, double dt, double end,SpatialModel<Record> graph) {
        LocationServiceList<Record> locService = new LocationServiceList<Record>();
        double time = start;
        while (time < end) {
            double current = time;
            locService.add(time, graph);
            time += dt;
        }
        locService.add(end,graph);
        return locService;
    }
	
	private SpatialModel<Record> getGraphModel() { //metto alla fine tutti i metodi privati di servizio.
		GraphModel<Record> m = new GraphModel<>(5);
		m.add(0, edgeRecordHandler.fromDoubleArray(1.0), 2);
		m.add(0, edgeRecordHandler.fromDoubleArray(1.0), 4);
		m.add(1, edgeRecordHandler.fromDoubleArray(1.0), 2);
		m.add(1, edgeRecordHandler.fromDoubleArray(1.0), 3);
		m.add(1, edgeRecordHandler.fromDoubleArray(1.0), 4);
		m.add(2, edgeRecordHandler.fromDoubleArray(1.0), 0);
		m.add(2, edgeRecordHandler.fromDoubleArray(1.0), 1);
		m.add(2, edgeRecordHandler.fromDoubleArray(1.0), 3);
		m.add(2, edgeRecordHandler.fromDoubleArray(1.0), 4);
		m.add(3, edgeRecordHandler.fromDoubleArray(1.0), 1);
		m.add(3, edgeRecordHandler.fromDoubleArray(1.0), 2);
		m.add(4, edgeRecordHandler.fromDoubleArray(1.0), 0);
		m.add(4, edgeRecordHandler.fromDoubleArray(1.0), 1);
		m.add(4, edgeRecordHandler.fromDoubleArray(1.0), 2);
		return m;
    }
	
    private static <T> SpatialTemporalSignal<T> createSpatioTemporalSignal(int size, double start, double dt, double end, BiFunction<Double, Integer, T> f) {
        SpatialTemporalSignal<T> s = new SpatialTemporalSignal(size);

        for(double time = start; time < end; time += dt) {
            double finalTime = time;
            s.add(time, (i) -> {
                return f.apply(finalTime, i);
            });
        }

        s.add(end, (i) -> {
            return f.apply(end, i);
        });
        return s;
    }

	
}
