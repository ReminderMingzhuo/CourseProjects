package com.dz.aiface;

import androidx.appcompat.app.AppCompatActivity;


import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.graphics.PixelFormat;
import android.hardware.Camera;
import android.media.Image;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

public class startLoginActivity extends AppCompatActivity {
    private SurfaceView sv_main_surface;
    private Camera camera;
    Button loginBtn,backMainBtn;
    ImageView imageView2;
    int loginCount = 10;                         //采集到的图片 验证10次，如果不成功则提示失败
    private String strImageFile = "";            //图片文件名
    private String strAccessToken = "";          //连接令牌



    //人脸搜索
    public String faceSearch() {
        InputStream is = null;
        byte[] data = null;
        String strImage = "";
        try {
            is = new FileInputStream(strImageFile);       //根据图片文件名创建输入流
            data = new byte[is.available()];              //根据流的大小创建byte数组
            is.read(data);
            strImage = Base64Util.encode(data);           //将图片文件内容 进行base64编码
        }catch (Exception ex) {
            System.out.println(ex.toString());
        }

        // 请求url
        String url = "https://aip.baidubce.com/rest/2.0/face/v3/search";
        try {
            Map<String, Object> map = new HashMap<>();
            map.put("image", strImage);                   //image内容
            map.put("liveness_control", "NORMAL");        //活体检测控制
            map.put("group_id_list", "group_repeat");     //组别
            map.put("image_type", "BASE64");              //编码方式: BASE64
            map.put("quality_control", "NORMAL");         //质量控制：普通

            String param = GsonUtils.toJson(map);         //map内容转成json

            String accessToken = strAccessToken;          //获取token

            //提交数据到平台
            String result = HttpUtil.post(url, accessToken, "application/json", param);
            System.out.println(result);
            return result;                               //返回结果
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    Handler MessageHandle = new Handler() {            //定义handler对象
        public void handleMessage(Message msg) {
            if (msg.what == 0x1234) {                             //处理 0x1234类型的数据
                Log.v("aiFace","msgHandler 0x1234");
                Toast.makeText(getApplicationContext(),"识别人脸数据失败1",Toast.LENGTH_SHORT).show();
            } else if (msg.what == 0x1235) {                      //处理 0x1235类型的数据
                Log.v("aiFace","msgHandler 0x1235");
                loginBtn.setEnabled(true);                        //  操作成功，界面按钮可以操作了
                backMainBtn.setEnabled(true);
                Toast.makeText(getApplicationContext(),"识别人脸数据成功"+(String)msg.obj,Toast.LENGTH_SHORT).show();
                //人脸识别正确，跳转到对应的用户activity
                Intent intent = new Intent(startLoginActivity.this,peopleActivity.class);
                intent.putExtra("name",(String)msg.obj);    //将识别出来的用户信息发送到用户activity界面
                startActivity(intent);
            } else if (msg.what == 0x1236) {                             //处理 0x1236类型的数据
                Log.v("aiFace","msgHandler 0x1236");
                Toast.makeText(getApplicationContext(),"识别人脸数据失败2:" + (String)msg.obj,Toast.LENGTH_SHORT).show();
            } else if (msg.what == 0x1237) {                             //处理 0x1237类型的数据
                Log.v("aiFace","msgHandler 0x1237");
                Toast.makeText(getApplicationContext(),"识别人脸数据失败 , 登录失败" ,Toast.LENGTH_SHORT).show();
                loginBtn.setEnabled(true);                               //检测完成，没有有效的人脸，检测失败。界面按钮可以继续操作了。
                backMainBtn.setEnabled(true);
            }
        }
    };

    @Override
    protected void onResume() {
        super.onResume();
        Log.v("aiFace","onResume()");
        loginBtn = (Button)findViewById(R.id.loginBtn);
        backMainBtn = (Button)findViewById(R.id.backMainBtn);         //返回按钮
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_start_login);


        imageView2 = (ImageView)findViewById(R.id.imageView2);        //用户拍照截图显示的imageView
        backMainBtn = (Button)findViewById(R.id.backMainBtn);         //返回按钮
        backMainBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();                            //关闭当前activity
            }
        });
        sv_main_surface = (SurfaceView) findViewById(R.id.sv_main_surface);      //显示视频的view
        //添加surface回调函数
        sv_main_surface.getHolder().addCallback(new SurfaceHolder.Callback() {
            @Override
            //控件创建时，打开照相机
            public void surfaceCreated(SurfaceHolder holder) {
                //打开照相机 (前置)
                camera = Camera.open(1);
                //设置参数
                Camera.Parameters parameters = camera.getParameters();      //获取相机参数
                parameters.setPictureFormat(PixelFormat.JPEG);              //图片格式为:JPG
                parameters.set("jpeg-quality",85);                          //质量：85
                camera.setParameters(parameters);                           //设置参数
                camera.setDisplayOrientation(90);                           //摄像头预览画面 旋转90度
                //将画面展示到SurfaceView
                try {
                    camera.setPreviewDisplay(sv_main_surface.getHolder());      //设置预览
                } catch (IOException e) {
                    e.printStackTrace();
                }
                //开启预览效果
                camera.startPreview();                                         //开始预览
                camera.autoFocus(null);                                    //自动调焦
            }
            @Override//控件改变
            public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
            }
            @Override//控件销毁
            public void surfaceDestroyed(SurfaceHolder holder) {
                   //照相同一时刻只能允许一个软件打开
                    if(camera!=null){
                        camera.stopPreview();                    //停止预览
                        camera.release();                        //释放内存
                        camera=null;
                    }
            }
        });

        loginBtn = (Button)findViewById(R.id.loginBtn);
        loginBtn.setOnClickListener(new View.OnClickListener() {
            Boolean over = false;
            @Override
            public void onClick(View v) {
                loginBtn.setEnabled(false);               //界面按钮不允许操作
                backMainBtn.setEnabled(false);
                Toast.makeText(getApplicationContext(),"开始识别...",Toast.LENGTH_SHORT).show();
                loginCount = 10;                          //人脸识别登录 10次，如果10次还不成功，则取消登录操作
                over = false;
                Log.v("aiFace","start login");
                //网络操作需要放线程里面，否则App闪退
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                                //提交图片到云平台
                                if (strAccessToken == "" || strAccessToken == null)
                                {
                                    strAccessToken = AuthService.getAuth();         //获取 accessToken
                                }
                                if(strAccessToken ==""||strAccessToken ==null)
                                {
                                    Message msg = new Message();            //定义message
                                    msg.what = 0x1236;                        //人脸识别失败，发送错误消息给解码主线程
                                    msg.obj = "获取AccessToker失败";
                                    Log.v("aiFace","bad accessToken");
                                    MessageHandle.sendMessage(msg);
                                    return ;                                        //无有效accessToken则退出
                                }
                                while (true) {
                                    //摄像头拍照
                                    //Log.v("aiFace","****************************");
                                    Log.v("aiFace","start take picture");
                                    Log.v("aiFace",String.format("loginCount= %d",loginCount));
                                    camera.takePicture(null, null, new Camera.PictureCallback() {
                                        @Override
                                        public void onPictureTaken(byte[] bytes, Camera camera) {
                                            //技术：图片压缩技术（如果图片不压缩，图片大小会过大，会报一个oom内存溢出的错误）
                                            Bitmap bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.length);
                                            //采集到的图片旋转90度
                                            Matrix m = new Matrix();
                                            m.setRotate(-90, (float) bitmap.getWidth() / 2, (float) bitmap.getHeight() / 2);
                                            final Bitmap bm = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), m, true);

                                            try {
                                                //用时间做文件名，保存照片文件
                                                strImageFile = getApplicationContext().getFilesDir() + "/" + String.format("%d", System.currentTimeMillis()) + ".jpg";
                                                FileOutputStream fos = new FileOutputStream(strImageFile);

                                                //图片保存路径
                                                bm.compress(Bitmap.CompressFormat.JPEG, 100, fos);
                                                fos.close();
                                                camera.stopPreview();                  //停止预览
                                                imageView2.setImageBitmap(bm);         //imageView控件显示照片
                                                camera.startPreview();                 //开始预览

                                                if (loginCount-- == 0) {               //如果10次都用完了，说明登录失败
                                                    Log.v("aiFace","loginCount = 0,return");
                                                    Message msg = new Message();          //定义message
                                                    msg.what = 0x1237;
                                                    MessageHandle.sendMessage(msg);       //发送类型为0x1237的消息，表示登录失败
                                                    return;
                                                }
                                                Log.v("aiFace","take picture over");
                                                over = true;                             //设置拍照完成
                                            } catch (FileNotFoundException e) {
                                                e.printStackTrace();
                                            } catch (IOException e) {
                                                e.printStackTrace();
                                            }
                                        }
                                    });
                                    while (!over) {        //拍照后再这里等待 ，等照片保存后再处理
                                    }
                                    Log.v("aiFace","ready call faceSearch");
                                    String strReturn = faceSearch();        //开始搜索人脸
                                    Message msg = new Message();            //定义message
                                    if (strReturn == null) {
                                        Log.v("aiFace","strReturn = null");
                                        msg.what = 0x1234;                  //返回类型为null
                                        MessageHandle.sendMessage(msg);
                                    } else {
                                        try {
                                            JSONObject jsonObject = new JSONObject(strReturn);          //解码返回数据
                                            int iError_Code = jsonObject.getInt("error_code");   //获取返回的错误码
                                            String strMsg = "";
                                            if (iError_Code != 0)
                                                strMsg = jsonObject.getString("error_msg");   //获取错误消息

                                            if (iError_Code == 0) {                                     //识别成功
                                                Log.v("aiFace","iError_Code = 0");
                                                JSONObject jsonObject2 = new JSONObject(jsonObject.getString("result"));  //用户信息保存在result里面
                                                JSONArray jsonArray = null;
                                                jsonArray = jsonObject2.getJSONArray("user_list");         //用户信息保存在result里面的user_list里面
                                                String strInfo = "";
                                                if (jsonArray == null) {
                                                    Log.v("aiFace","jsonArray = null," + strMsg);
                                                    msg.what = 0x1236;                        //人脸识别失败，发送错误消息给解码主线程
                                                    msg.obj = strMsg;
                                                    MessageHandle.sendMessage(msg);
                                                }
                                                for (int i = 0; i < jsonArray.length(); i++) {
                                                    double fScore = jsonArray.getJSONObject(i).getDouble("score");   //对score就行比对，积分 > 80，人脸有效
                                                    Log.v("aiFace",String.format("i = %d,fScore=%f",i,fScore));
                                                    if (fScore < 80) continue;
                                                    strInfo = jsonArray.getJSONObject(i).getString("user_info");    //获取到用户信息
                                                    Log.v("aiFace",String.format(">80,info=%s",strInfo));
                                                    msg.what = 0x1235;
                                                    msg.obj = strInfo+String.format("。相似匹配积分:%f。",fScore);
                                                    MessageHandle.sendMessage(msg);           //人脸识别成功，发送用户信息给界面主线程
                                                    return;
                                                }
                                                Log.v("aiFace","no match ok");
                                                msg.what = 0x1236;                        //人脸识别失败，发送错误消息给解码主线程
                                                msg.obj = "没有匹配成功";
                                                MessageHandle.sendMessage(msg);
                                            } else {
                                                Log.v("aiFace","0x1236" + String.format("iError_Code=%d",iError_Code));
                                                msg.what = 0x1236;                        //人脸识别失败，发送错误消息给解码主线程
                                                msg.obj = strMsg;
                                                MessageHandle.sendMessage(msg);
                                            }
                                        }catch (Exception ex) {
                                            //ex.printStackTrace();
                                            Log.v("aiFace","0x1236 2");
                                            msg.what = 0x1236;                        //人脸识别失败，发送错误消息给解码主线程
                                            msg.obj = ex.toString();
                                            MessageHandle.sendMessage(msg);
                                        }
                                    }
                                    over = false;
                                    //连续识别了10次还不成功，则退出线程
                                    if (loginCount < 1) {
                                        Log.v("aiFace","loginCount < 0");
                                        Log.v("aiFace",String.format("loginCount=%d",loginCount));
                                        msg.what = 0x1237;
                                        MessageHandle.sendMessage(msg);       //发送类型为0x1237的消息，表示登录失败
                                        return;
                                    }
                                }
                    }
                }).start();                                                                  //启动线程
            }
        });
    }
}
