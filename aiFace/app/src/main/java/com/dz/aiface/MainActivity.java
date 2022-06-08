package com.dz.aiface;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;

public class MainActivity extends AppCompatActivity {
    Button exitBtn,startLoginBtn,saveBtn;

    private static final int REQUEST_EXTERNAL_STORAGE = 1;  //请求值
    private static String[] PERMISSIONS_STORAGE = {         //请求内容
            Manifest.permission.READ_EXTERNAL_STORAGE,
            Manifest.permission.WRITE_EXTERNAL_STORAGE
    };

    private static final int REQUEST_CAMERA = 2;       //请求值
    private static String[] PERMISSIONS_CAMERA = {     //请求内容
            Manifest.permission.CAMERA
    };

    //请求权限返回结果
    public void onRequestPermissionsResult(int requestCode,  String[] permissions,  int[] grantResults){
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);

        switch (requestCode) {
            case REQUEST_EXTERNAL_STORAGE:       //存储卡操作权限
                int iOKCount = 0;
                for (int i = 0; i < permissions.length; i++) {
                    if (permissions[i].equals(Manifest.permission.WRITE_EXTERNAL_STORAGE)) {
                        if (grantResults[i] == PackageManager.PERMISSION_GRANTED) {
                            iOKCount++;
                        } else {

                        }
                    }
                    if (permissions[i].equals(Manifest.permission.WRITE_EXTERNAL_STORAGE)) {
                        if (grantResults[i] == PackageManager.PERMISSION_GRANTED) {
                            iOKCount++;
                        } else {

                        }
                    }
                }
                if (iOKCount == permissions.length) {
                    //已经授权成功了
                }
                break;
            case REQUEST_CAMERA:
                if (permissions[0].equals(Manifest.permission.CAMERA)) {
                    if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                        //授权成功了
                    } else  {
                        //授权失败
                    }
                }
                break;
        }
    }

    //动态权限检测
    private void check_permission() {
        if (Build.VERSION.SDK_INT < 23) return;   //安卓6.0以下不需要动态权限，23 = 安卓6.0
        //检查读写sd卡权限
        int permission = ActivityCompat.checkSelfPermission(MainActivity.this, Manifest.permission.WRITE_EXTERNAL_STORAGE);
        //如果没有权限，则请求权限
        if (permission != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(
                    MainActivity.this,
                    PERMISSIONS_STORAGE,
                    REQUEST_EXTERNAL_STORAGE
            );
        }

        //检查Camera权限
        permission = ActivityCompat.checkSelfPermission(MainActivity.this, Manifest.permission.CAMERA);
        //如果没有权限，则请求权限
        if (permission != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(
                    MainActivity.this,
                    PERMISSIONS_CAMERA,
                    REQUEST_CAMERA
            );
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        saveBtn = (Button)findViewById(R.id.saveBtn);
        saveBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //进入到人脸保存activity
                Log.v("aiFace","enter save Face Activity");
                Intent intent = new Intent();
                intent.setClass(MainActivity.this, saveFaceActivity.class);
                startActivity(intent);
            }
        });

        startLoginBtn = (Button)findViewById(R.id.startLoginBtn);
        startLoginBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //进入到 人脸识别登录activity
                Intent intent = new Intent();
                intent.setClass(MainActivity.this, startLoginActivity.class);
                startActivity(intent);
            }
        });

        exitBtn = (Button)findViewById(R.id.exitBtn);
        exitBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                System.exit(0);           //退出app
            }
        });

        //启动后检查权限
        new Thread() {
            public void run() {
                check_permission();       //检查动态权限
            }
        }.start();
    }
}
