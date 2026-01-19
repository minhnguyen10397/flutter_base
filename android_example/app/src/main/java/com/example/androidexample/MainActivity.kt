package com.example.androidexample

import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.fragment.app.FragmentActivity
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.androidexample.ui.theme.Android_exampleTheme
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

class MainActivity : FragmentActivity() {
    companion object {
        private const val FLUTTER_ENGINE_ID = "flutter_engine_id"
    }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Tạo và cache FlutterEngine
        val flutterEngine = createFlutterEngine()
        FlutterEngineCache.getInstance().put(FLUTTER_ENGINE_ID, flutterEngine)
        
        enableEdgeToEdge()
        setContent {
            Android_exampleTheme {
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    MainScreen(
                        onOpenMiniApp = {
                            val dialog = FlutterDialogFragment.newInstance(FLUTTER_ENGINE_ID)
                            dialog.show(supportFragmentManager, "FlutterDialog")
                        },
                        onCallFlutterMethod = {
                            // Ví dụ: Gọi Flutter method và nhận kết quả
                            callFlutterMethod("getUserInfo") { result ->
                                if (result != null) {
                                    val userInfo = result as? Map<*, *>
                                    android.util.Log.d("FlutterMethod", "User info: $userInfo")
                                    // Có thể hiển thị kết quả trong UI
                                }
                            }
                        },
                        onOpenFlutterActivity = {
                            startActivity(FlutterHostActivity.createIntent(this, FLUTTER_ENGINE_ID))
                        },
                        modifier = Modifier.padding(innerPadding)
                    )
                }
            }
        }
    }
    
    private fun createFlutterEngine(): FlutterEngine {
        val flutterEngine = FlutterEngine(this)
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )
        return flutterEngine
    }
    
    /**
     * Gọi Flutter method và nhận kết quả
     * Ví dụ: callFlutterMethod("getUserInfo") { result -> ... }
     *       callFlutterMethod("calculate", mapOf("a" to 10, "b" to 20)) { result -> ... }
     */
    fun callFlutterMethod(methodName: String, arguments: Any? = null, callback: (Any?) -> Unit) {
        val flutterEngine = FlutterEngineCache.getInstance().get(FLUTTER_ENGINE_ID)
        if (flutterEngine != null) {
            FlutterMethodCaller.callFlutterMethod(
                flutterEngine = flutterEngine,
                methodName = methodName,
                arguments = arguments,
                onSuccess = { result ->
                    callback(result)
                },
                onError = { exception ->
                    android.util.Log.e("FlutterMethodCaller", "Error calling Flutter method: ${exception.message}")
                    callback(null)
                }
            )
        } else {
            android.util.Log.e("FlutterMethodCaller", "FlutterEngine not found")
            callback(null)
        }
    }

    override fun onPause() {
        super.onPause()
        // MainActivity sẽ bị pause khi FlutterActivity start
        // Nhưng với FLAG_NOT_TOUCH_MODAL, MainActivity vẫn có thể nhận một số events
        android.util.Log.d("MainActivity", "onPause called")
    }
    
    override fun onDestroy() {
        super.onDestroy()
        // Có thể giữ engine để tái sử dụng, hoặc destroy nó
        // FlutterEngineCache.getInstance().remove(FLUTTER_ENGINE_ID)
    }
}

@Composable
fun MainScreen(
    onOpenMiniApp: () -> Unit,
    onCallFlutterMethod: () -> Unit,
    onOpenFlutterActivity: () -> Unit,
    modifier: Modifier = Modifier
) {
    val scrollState = rememberScrollState()
    
    Column(
        modifier = modifier
            .fillMaxSize()
            .verticalScroll(scrollState)
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        Text(
            text = "Android Native App",
            style = MaterialTheme.typography.headlineMedium,
            textAlign = TextAlign.Center,
            modifier = Modifier.padding(bottom = 32.dp)
        )
        
        Button(
            onClick = onOpenMiniApp,
            modifier = Modifier.padding(8.dp)
        ) {
            Text(
                text = "Mở Mini App",
                fontSize = 18.sp
            )
        }
        
        Button(
            onClick = onCallFlutterMethod,
            modifier = Modifier.padding(8.dp)
        ) {
            Text(
                text = "Gọi Flutter Method",
                fontSize = 18.sp
            )
        }
        
        Button(
            onClick = onOpenFlutterActivity,
            modifier = Modifier.padding(8.dp)
        ) {
            Text(
                text = "Mở Flutter Activity",
                fontSize = 18.sp
            )
        }
        Text(
            text = "Android Native App",
            style = MaterialTheme.typography.headlineMedium,
            textAlign = TextAlign.Center,
            modifier = Modifier.padding(bottom = 32.dp)
        )

        Button(
            onClick = onOpenMiniApp,
            modifier = Modifier.padding(8.dp)
        ) {
            Text(
                text = "Mở Mini App",
                fontSize = 18.sp
            )
        }

        Button(
            onClick = onCallFlutterMethod,
            modifier = Modifier.padding(8.dp)
        ) {
            Text(
                text = "Gọi Flutter Method",
                fontSize = 18.sp
            )
        }
        Text(
            text = "Android Native App",
            style = MaterialTheme.typography.headlineMedium,
            textAlign = TextAlign.Center,
            modifier = Modifier.padding(bottom = 32.dp)
        )

        Button(
            onClick = onOpenMiniApp,
            modifier = Modifier.padding(8.dp)
        ) {
            Text(
                text = "Mở Mini App",
                fontSize = 18.sp
            )
        }

        Button(
            onClick = onCallFlutterMethod,
            modifier = Modifier.padding(8.dp)
        ) {
            Text(
                text = "Gọi Flutter Method",
                fontSize = 18.sp
            )
        }
        Text(
            text = "Android Native App",
            style = MaterialTheme.typography.headlineMedium,
            textAlign = TextAlign.Center,
            modifier = Modifier.padding(bottom = 32.dp)
        )

        Button(
            onClick = onOpenMiniApp,
            modifier = Modifier.padding(8.dp)
        ) {
            Text(
                text = "Mở Mini App",
                fontSize = 18.sp
            )
        }

        Button(
            onClick = onCallFlutterMethod,
            modifier = Modifier.padding(8.dp)
        ) {
            Text(
                text = "Gọi Flutter Method",
                fontSize = 18.sp
            )
        }
        Text(
            text = "Android Native App",
            style = MaterialTheme.typography.headlineMedium,
            textAlign = TextAlign.Center,
            modifier = Modifier.padding(bottom = 32.dp)
        )

        Button(
            onClick = onOpenMiniApp,
            modifier = Modifier.padding(8.dp)
        ) {
            Text(
                text = "Mở Mini App",
                fontSize = 18.sp
            )
        }

        Button(
            onClick = onCallFlutterMethod,
            modifier = Modifier.padding(8.dp)
        ) {
            Text(
                text = "Gọi Flutter Method",
                fontSize = 18.sp
            )
        }
    }
}

@Preview(showBackground = true)
@Composable
fun MainScreenPreview() {
    Android_exampleTheme {
        MainScreen(onOpenMiniApp = {}, onCallFlutterMethod = {}, onOpenFlutterActivity = {})
    }
}