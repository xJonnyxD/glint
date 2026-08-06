package com.glintapp.glint

import io.flutter.embedding.android.FlutterFragmentActivity

/**
 * Hereda de FlutterFragmentActivity, no de FlutterActivity, porque el plugin
 * local_auth necesita un FragmentActivity para mostrar el diálogo de huella o
 * rostro: BiometricPrompt es un fragmento de AndroidX.
 *
 * Con FlutterActivity, `authenticate()` fallaba siempre con
 * `no_fragment_activity` y el desbloqueo biométrico no llegaba a aparecer.
 */
class MainActivity : FlutterFragmentActivity()
