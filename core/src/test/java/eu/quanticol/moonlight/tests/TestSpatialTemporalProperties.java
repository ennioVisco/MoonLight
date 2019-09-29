package eu.quanticol.moonlight.tests;

import eu.quanticol.moonlight.formula.AtomicFormula;
import eu.quanticol.moonlight.formula.DoubleDomain;
import eu.quanticol.moonlight.formula.Parameters;
import eu.quanticol.moonlight.monitoring.SpatioTemporalMonitoring;
import eu.quanticol.moonlight.signal.Signal;
import eu.quanticol.moonlight.signal.SpatialModel;
import eu.quanticol.moonlight.signal.SpatioTemporalSignal;
import eu.quanticol.moonlight.util.Pair;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.function.BiFunction;
import java.util.function.DoubleFunction;
import java.util.function.Function;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

/**
 * @author loreti
 *
 */
class TestSpatialTemporalProperties {

    @Test
    void testSPTsignalGraphBuild() {
        int size = 10;
        HashMap<String, Function<Parameters, Function<Double, Double>>> atomic = new HashMap<>();
        atomic.put("simpleAtomic", p -> (x -> (x - 2)));
        SpatialModel<Double> model = TestUtils.createSpatialModel(size, (x, y) -> (y == (((x + 1) % size)) ? 1.0 : null));
        SpatioTemporalSignal<Double> signal = TestUtils.createSpatioTemporalSignal(size, 0, 0.1, 10, (t, l) -> t * l);
        SpatioTemporalMonitoring<Double, Double, Double> monitor = new SpatioTemporalMonitoring<>(
                atomic,
                new HashMap<>(),
                new DoubleDomain(),
                true);

        BiFunction<DoubleFunction<SpatialModel<Double>>, SpatioTemporalSignal<Double>, SpatioTemporalSignal<Double>> m = monitor.monitor(new AtomicFormula("simpleAtomic"), null);
        SpatioTemporalSignal<Double> sout = m.apply(t -> model, signal);
        ArrayList<Signal<Double>> signals = sout.getSignals();
        for (int i = 0; i < 10; i++) {
            assertEquals(i * 5.0 - 2, signals.get(i).valueAt(5.0), 0.0001);
        }
        assertNotNull(model);
    }

    @Test
    void testSPTsignalGraphBuild2() {
        int size = 10;
        HashMap<String, Function<Parameters, Function<Pair<Double, Double>, Double>>> atomic = new HashMap<>();
        atomic.put("simpleAtomic", p -> (x -> (x.getFirst() + x.getSecond() - 2)));
        SpatialModel<Double> model = TestUtils.createSpatialModel(size, (x, y) -> (y == (((x + 1) % size)) ? 1.0 : null));
        SpatioTemporalSignal<Pair<Double, Double>> signal = TestUtils.createSpatioTemporalSignal(size, 0, 0.1, 10, (t, l) -> new Pair<>(t * l / 2, t * l / 2));
        SpatioTemporalMonitoring<Double, Pair<Double, Double>, Double> monitor = new SpatioTemporalMonitoring<>(
                atomic,
                new HashMap<>(),
                new DoubleDomain(),
                true);

        BiFunction<DoubleFunction<SpatialModel<Double>>, SpatioTemporalSignal<Pair<Double, Double>>, SpatioTemporalSignal<Double>> m = monitor.monitor(new AtomicFormula("simpleAtomic"), null);
        SpatioTemporalSignal<Double> sout = m.apply(t -> model, signal);
        ArrayList<Signal<Double>> signals = sout.getSignals();
        for (int i = 0; i < 10; i++) {
            assertEquals(i * 5.0 - 2, signals.get(i).valueAt(5.0), 0.0001);
        }
        assertNotNull(model);
    }

    @Test
    void testGraphSPTsignalBuildWithMaps() {
        int size = 10;
        HashMap<Pair<Integer, Integer>, Double> map = new HashMap<>();
        map.put(new Pair<>(0, 2), 1.0);
        map.put(new Pair<>(0, 1), 1.0);
        map.put(new Pair<>(2, 3), 1.0);
        map.put(new Pair<>(1, 3), 5.0);
    }

}