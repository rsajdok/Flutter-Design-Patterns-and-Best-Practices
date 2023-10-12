package com.example.candy_store

import android.content.Context
import android.content.SharedPreferences
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val FAVES_METHOD_CHANNEL = "com.example.candy_store/faves"
    private lateinit var methodChannel: MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, FAVES_METHOD_CHANNEL)
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getFaves" -> {
                    val faves = getFaves()
                    result.success(faves)
                }

                "addFave" -> {
                    val id = call.argument<String>("id")
                    if (id == null) {
                        result.error("INVALID_VALUE", "id is null", null)
                    } else {
                        toggleFavorite(id, true)
                        result.success(null)
                    }
                }

                "removeFave" -> {
                    val id = call.argument<String>("id")
                    if (id == null) {
                        result.error("INVALID_VALUE", "id is null", null)
                    } else {
                        toggleFavorite(id, false)
                        result.success(null)
                    }
                }

                "isFave" -> {
                    val id = call.argument<String>("id")
                    if (id == null) {
                        result.error("INVALID_VALUE", "id is null", null)
                    } else {
                        val isFave = isFave(id)
                        result.success(isFave)
                    }
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getSharedPreferences(): SharedPreferences {
        return applicationContext.getSharedPreferences("faves", Context.MODE_PRIVATE)
    }

    private fun getFaves(): List<String> {
        val preferences = getSharedPreferences()
        val faves = preferences.getStringSet("faves", HashSet()) ?: HashSet()
        return faves.toList()
    }

    private fun isFave(id: String): Boolean {
        val preferences = getSharedPreferences()
        val faves = preferences.getStringSet("faves", HashSet()) ?: HashSet()
        return faves.contains(id)
    }

    private fun toggleFavorite(id: String, isFavorite: Boolean) {
        val preferences = getSharedPreferences()
        val allFaves = HashSet<String>()
        val faves = preferences.getStringSet("faves", HashSet()) ?: HashSet()
        allFaves.addAll(faves)
        if (isFavorite) {
            allFaves.add(id)
        } else {
            allFaves.remove(id)
        }
        preferences.edit().putStringSet("faves", allFaves).apply()
    }
}
