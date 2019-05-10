package com.example.testes_canais;

import java.lang.Thread;
import java.lang.Runnable;

import android.os.Bundle;
import android.os.Handler;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  String CANAL_TESTE = "testeEvento";
  String CANAL_METODO = "testeMetodo";
  int tempo = 0;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    
    

    new MethodChannel(getFlutterView(), CANAL_METODO).setMethodCallHandler(
      new MethodChannel.MethodCallHandler() {
        @Override
        public void onMethodCall(MethodCall call, MethodChannel.Result result) {
          // if (call.method.equals("demoFunction")) { // INFO: method check
          //   String argument = call.argument("data"); // INFO: get arguments
          //   demoFunction(result, argument); // INFO: method call, every method call should pass result parameter
          // } else 
          if (call.method.equals("metodo")) {
            String argument = call.argument("data");
            result.success("Olá, " + argument + ". O tempo atual é " + Integer.toString(tempo));
          } else {
            result.notImplemented(); // INFO: not implemented
          }
        }
      }
    );

    new EventChannel(getFlutterView(), CANAL_TESTE).setStreamHandler(
      new EventChannel.StreamHandler() {
        Handler handler;
        Runnable runnable;

        @Override
        public void onListen(Object args, final EventChannel.EventSink events) {
          System.out.println("TESTE: escuta iniciada");
          tempo = 0;
          handler = new Handler();
          runnable = new Runnable() {
            @Override
            public void run() {
              tempo++;
              System.out.println(tempo);
              events.success(tempo);
              handler.postDelayed(runnable, 1000);
            }
          };
          events.success(tempo);
          handler.postDelayed(runnable, 1000);
        }

        @Override
        public void onCancel(Object args) {
          System.out.println("TESTE: escuta cancelada");
          handler.removeCallbacks(runnable);
        }
      }
    );

  }
}
