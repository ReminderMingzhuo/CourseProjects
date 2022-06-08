package com.dz.aiface;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.graphics.PixelFormat;
import android.hardware.Camera;
import android.hardware.camera2.CameraManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Toast;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonParseException;

import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Type;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

class Base64Util {
    private static final char last2byte = (char) Integer.parseInt("00000011", 2);
    private static final char last4byte = (char) Integer.parseInt("00001111", 2);
    private static final char last6byte = (char) Integer.parseInt("00111111", 2);
    private static final char lead6byte = (char) Integer.parseInt("11111100", 2);
    private static final char lead4byte = (char) Integer.parseInt("11110000", 2);
    private static final char lead2byte = (char) Integer.parseInt("11000000", 2);
    private static final char[] encodeTable = new char[]{'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'};

    public Base64Util() {
    }

    public static String encode(byte[] from) {
        StringBuilder to = new StringBuilder((int) ((double) from.length * 1.34D) + 3);
        int num = 0;
        char currentByte = 0;

        int i;
        for (i = 0; i < from.length; ++i) {
            for (num %= 8; num < 8; num += 6) {
                switch (num) {
                    case 0:
                        currentByte = (char) (from[i] & lead6byte);
                        currentByte = (char) (currentByte >>> 2);
                    case 1:
                    case 3:
                    case 5:
                    default:
                        break;
                    case 2:
                        currentByte = (char) (from[i] & last6byte);
                        break;
                    case 4:
                        currentByte = (char) (from[i] & last4byte);
                        currentByte = (char) (currentByte << 2);
                        if (i + 1 < from.length) {
                            currentByte = (char) (currentByte | (from[i + 1] & lead2byte) >>> 6);
                        }
                        break;
                    case 6:
                        currentByte = (char) (from[i] & last2byte);
                        currentByte = (char) (currentByte << 4);
                        if (i + 1 < from.length) {
                            currentByte = (char) (currentByte | (from[i + 1] & lead4byte) >>> 4);
                        }
                }

                to.append(encodeTable[currentByte]);
            }
        }

        if (to.length() % 4 != 0) {
            for (i = 4 - to.length() % 4; i > 0; --i) {
                to.append("=");
            }
        }

        return to.toString();
    }
}


class HttpUtil {

    public static String post(String requestUrl, String accessToken, String params)
            throws Exception {
        String contentType = "application/x-www-form-urlencoded";
        return HttpUtil.post(requestUrl, accessToken, contentType, params);
    }

    public static String post(String requestUrl, String accessToken, String contentType, String params)
            throws Exception {
        String encoding = "UTF-8";
        if (requestUrl.contains("nlp")) {
            encoding = "GBK";
        }
        return HttpUtil.post(requestUrl, accessToken, contentType, params, encoding);
    }

    public static String post(String requestUrl, String accessToken, String contentType, String params, String encoding)
            throws Exception {
        String url = requestUrl + "?access_token=" + accessToken;
        return HttpUtil.postGeneralUrl(url, contentType, params, encoding);
    }

    public static String postGeneralUrl(String generalUrl, String contentType, String params, String encoding)
            throws Exception {
        URL url = new URL(generalUrl);
        // 打开和URL之间的连接
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("POST");
        // 设置通用的请求属性
        connection.setRequestProperty("Content-Type", contentType);
        connection.setRequestProperty("Connection", "Keep-Alive");
        connection.setUseCaches(false);
        connection.setDoOutput(true);
        connection.setDoInput(true);

        // 得到请求的输出流对象
        DataOutputStream out = new DataOutputStream(connection.getOutputStream());
        out.write(params.getBytes(encoding));
        out.flush();
        out.close();

        // 建立实际的连接
        connection.connect();
        // 获取所有响应头字段
        Map<String, List<String>> headers = connection.getHeaderFields();
        // 遍历所有的响应头字段
        for (String key : headers.keySet()) {
            System.err.println(key + "--->" + headers.get(key));
        }
        // 定义 BufferedReader输入流来读取URL的响应
        BufferedReader in = null;
        in = new BufferedReader(
                new InputStreamReader(connection.getInputStream(), encoding));
        String result = "";
        String getLine;
        while ((getLine = in.readLine()) != null) {
            result += getLine;
        }
        in.close();
        System.err.println("result:" + result);
        return result;
    }
}



class GsonUtils {
    private static Gson gson = new GsonBuilder().create();

    public static String toJson(Object value) {
        return gson.toJson(value);
    }

    public static <T> T fromJson(String json, Class<T> classOfT) throws JsonParseException {
        return gson.fromJson(json, classOfT);
    }

    public static <T> T fromJson(String json, Type typeOfT) throws JsonParseException {
        return (T) gson.fromJson(json, typeOfT);
    }
}


public class saveFaceActivity extends AppCompatActivity {
    public static final int TAKE_PHOTO = 1;
    Button takePhotoBtn,backBtn,saveBtn;
    ImageView picture;
    private String strImageFile;
    private SurfaceView sv_save_surface;
    private Camera camera;
    Button loginBtn,backMainBtn;
    private String strAccessToken = "";
    String userId = "";
    String userInfo = "";
    EditText editTextName;


    Handler MessageHandle = new Handler() {            //定义handler对象
        public void handleMessage(Message msg) {
            if (msg.what == 0x1234) {                                    //处理 0x1234类型的数据
                Toast.makeText(getApplicationContext(),"保存人脸数据失败1",Toast.LENGTH_SHORT).show();
            } else if (msg.what == 0x1235) {                             //处理 0x1234类型的数据
                Toast.makeText(getApplicationContext(),"保存人脸数据成功",Toast.LENGTH_SHORT).show();
            } else if (msg.what == 0x1236) {                             //处理 0x1234类型的数据
                Toast.makeText(getApplicationContext(),"保存人脸数据失败2:" + (String)msg.obj,Toast.LENGTH_SHORT).show();
            }
        }
    };

    //注册人脸数据
    public String face_add(String userId,String userInfo) {
        // 请求url
        InputStream is = null;
        byte[] data = null;
        String strImage = "";
        try {
            is = new FileInputStream(strImageFile);       //将图片文件保存到byte数组中
            data = new byte[is.available()];
            is.read(data);
            strImage = Base64Util.encode(data);           //对byte数组进行base64编码
        }catch (Exception ex) {
            //ex.printStackTrace();
            System.out.println(ex.toString());
        }

        String url = "https://aip.baidubce.com/rest/2.0/face/v3/faceset/user/add";
        try {
            Map<String, Object> map = new HashMap<>();
            map.put("image", strImage);                        //image类型：base64编码后的数据
            map.put("group_id", "group_repeat");               //组id
            map.put("user_id", userId);                        //用户id
            map.put("user_info", userInfo);                    //用户信息
            map.put("liveness_control", "NORMAL");             //活体控制：普通
            map.put("image_type", "BASE64");                   //图像类型：BASE64
            map.put("quality_control", "NORMAL");              //活体类型：普通
            map.put("action_type","REPLACE");                  //相同类型：替换

            String param = GsonUtils.toJson(map);              //参数转成json

            //调用api
            String result = HttpUtil.post(url, strAccessToken, "application/json", param);
            System.out.println(result);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_save_face);

        picture = (ImageView)findViewById(R.id.savepicture);
        editTextName = (EditText)findViewById(R.id.editTextName);

        backBtn = (Button)findViewById(R.id.backBtn);
        backBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();                      //关闭窗体
            }
        });

        sv_save_surface = (SurfaceView) findViewById(R.id.sv_save_surface);
        //添加surface回调函数
        sv_save_surface.getHolder().addCallback(new SurfaceHolder.Callback() {
            @Override
            //控件创建时，打开照相机
            public void surfaceCreated(SurfaceHolder holder) {
                //打开照相机 1表示前置摄像头
                camera = Camera.open(1);
                //设置参数
                Camera.Parameters parameters=camera.getParameters();
                parameters.setPictureFormat(PixelFormat.JPEG);
                parameters.set("jpeg-quality",85);
                camera.setParameters(parameters);
                camera.setDisplayOrientation(90);                //画面旋转90度
                //将画面展示到SurfaceView
                try {
                    camera.setPreviewDisplay(sv_save_surface.getHolder());      //设置预览区域
                } catch (IOException e) {
                    e.printStackTrace();
                }

                camera.startPreview();            //开启预览效果
                camera.autoFocus(null);       //自动对焦
            }
            @Override//控件改变
            public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
            }
            @Override//控件销毁
            public void surfaceDestroyed(SurfaceHolder holder) {
                //照相同一时刻只能允许一个软件打开
                if(camera!=null){
                    camera.stopPreview();
                    camera.release();//释放内存
                    camera=null;
                }
            }
        });

        takePhotoBtn = (Button)findViewById(R.id.takePhotoBtn);
        takePhotoBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                 camera.takePicture(null, null, new Camera.PictureCallback() {
                        @Override
                        public void onPictureTaken(byte[] bytes, Camera camera) {
                            //创建bitmap对象，保存照片数据
                            Bitmap bitmap= BitmapFactory.decodeByteArray(bytes,0,bytes.length);
                            //旋转图片90度
                            Matrix m = new Matrix();
                            m.setRotate(-90,(float) bitmap.getWidth() / 2, (float) bitmap.getHeight() / 2);
                            //旋转后的图片保存到新的bm
                            final Bitmap bm = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), m, true);

                            try {
                                //图片保存路径
                                strImageFile = getApplicationContext().getFilesDir()+"/"+String.format("%d",System.currentTimeMillis())+".jpg";
                                FileOutputStream fos = new FileOutputStream(strImageFile);

                                bm.compress(Bitmap.CompressFormat.JPEG,100,fos);     //压缩
                                fos.close();                                                 //关闭文件
                                camera.stopPreview();                                        //停止摄像头预览
                                picture.setImageBitmap(bm);                                  //界面picture显示照片
                                camera.startPreview();                                       //开始摄像头预览
                            } catch (FileNotFoundException e) {
                                e.printStackTrace();
                            }catch (IOException e) {
                                e.printStackTrace();
                            }
                        }
                    });
            }
        });

        saveBtn = (Button)findViewById(R.id.saveBtn);
        saveBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (strImageFile == null) {
                    Toast.makeText(getApplicationContext(),"请先拍照",Toast.LENGTH_SHORT).show();
                    return;
                }
                if (strImageFile.length() < 1) {
                    Toast.makeText(getApplicationContext(),"请先拍照",Toast.LENGTH_SHORT).show();
                    return;
                }
                userInfo = editTextName.getText().toString();
                if (userInfo.length() < 1) {
                    Toast.makeText(getApplicationContext(),"请输入姓名",Toast.LENGTH_SHORT).show();
                    return;
                }
                //网络操作耗时，需要放到线程里面执行
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        //提交图片到云平台
                        if (strAccessToken == "")                                  //如果accessToken为空
                        {
                            strAccessToken = AuthService.getAuth();                //获取AccessToken
                        }
                        if(strAccessToken ==""||strAccessToken ==null)
                        {
                            return;
                        }
                        userId = "userId_"+String.format("%d",System.currentTimeMillis());     //用useID_和时间 组合成userId

                        String strReturn = face_add(userId,userInfo);                           //注册增加 人脸
                        if (strReturn == null) {
                            Message msg = new Message();          //定义message
                            msg.what = 0x1234;                    //操作错误，返回0x1234
                            MessageHandle.sendMessage(msg);
                        }
                        JSONObject jsonObject = null;             //创建json对象
                        try {
                           jsonObject =  new JSONObject(strReturn);         //解析返回的数据
                           String strresult = jsonObject.getString("error_msg");       //解析error_msg
                           Message msg = new Message();          //定义message
                           if (strresult.contains("SUCCESS"))
                              msg.what = 0x1235;                             //注册成功
                           else {
                               msg.what = 0x1236;                            //注册失败
                               msg.obj = strresult;                          // 错误原因字符串也一起发送出去
                           }
                           MessageHandle.sendMessage(msg);                   //发送消息到主界面线程处理
                        }catch (Exception ex) {
                            ex.printStackTrace();
                        }
                    }
                }).start();
            }
        });


    }
}
