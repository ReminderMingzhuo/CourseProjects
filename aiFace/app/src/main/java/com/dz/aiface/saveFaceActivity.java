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
        // ?????????URL???????????????
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("POST");
        // ???????????????????????????
        connection.setRequestProperty("Content-Type", contentType);
        connection.setRequestProperty("Connection", "Keep-Alive");
        connection.setUseCaches(false);
        connection.setDoOutput(true);
        connection.setDoInput(true);

        // ??????????????????????????????
        DataOutputStream out = new DataOutputStream(connection.getOutputStream());
        out.write(params.getBytes(encoding));
        out.flush();
        out.close();

        // ?????????????????????
        connection.connect();
        // ???????????????????????????
        Map<String, List<String>> headers = connection.getHeaderFields();
        // ??????????????????????????????
        for (String key : headers.keySet()) {
            System.err.println(key + "--->" + headers.get(key));
        }
        // ?????? BufferedReader??????????????????URL?????????
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


    Handler MessageHandle = new Handler() {            //??????handler??????
        public void handleMessage(Message msg) {
            if (msg.what == 0x1234) {                                    //?????? 0x1234???????????????
                Toast.makeText(getApplicationContext(),"????????????????????????1",Toast.LENGTH_SHORT).show();
            } else if (msg.what == 0x1235) {                             //?????? 0x1234???????????????
                Toast.makeText(getApplicationContext(),"????????????????????????",Toast.LENGTH_SHORT).show();
            } else if (msg.what == 0x1236) {                             //?????? 0x1234???????????????
                Toast.makeText(getApplicationContext(),"????????????????????????2:" + (String)msg.obj,Toast.LENGTH_SHORT).show();
            }
        }
    };

    //??????????????????
    public String face_add(String userId,String userInfo) {
        // ??????url
        InputStream is = null;
        byte[] data = null;
        String strImage = "";
        try {
            is = new FileInputStream(strImageFile);       //????????????????????????byte?????????
            data = new byte[is.available()];
            is.read(data);
            strImage = Base64Util.encode(data);           //???byte????????????base64??????
        }catch (Exception ex) {
            //ex.printStackTrace();
            System.out.println(ex.toString());
        }

        String url = "https://aip.baidubce.com/rest/2.0/face/v3/faceset/user/add";
        try {
            Map<String, Object> map = new HashMap<>();
            map.put("image", strImage);                        //image?????????base64??????????????????
            map.put("group_id", "group_repeat");               //???id
            map.put("user_id", userId);                        //??????id
            map.put("user_info", userInfo);                    //????????????
            map.put("liveness_control", "NORMAL");             //?????????????????????
            map.put("image_type", "BASE64");                   //???????????????BASE64
            map.put("quality_control", "NORMAL");              //?????????????????????
            map.put("action_type","REPLACE");                  //?????????????????????

            String param = GsonUtils.toJson(map);              //????????????json

            //??????api
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
                finish();                      //????????????
            }
        });

        sv_save_surface = (SurfaceView) findViewById(R.id.sv_save_surface);
        //??????surface????????????
        sv_save_surface.getHolder().addCallback(new SurfaceHolder.Callback() {
            @Override
            //?????????????????????????????????
            public void surfaceCreated(SurfaceHolder holder) {
                //??????????????? 1?????????????????????
                camera = Camera.open(1);
                //????????????
                Camera.Parameters parameters=camera.getParameters();
                parameters.setPictureFormat(PixelFormat.JPEG);
                parameters.set("jpeg-quality",85);
                camera.setParameters(parameters);
                camera.setDisplayOrientation(90);                //????????????90???
                //??????????????????SurfaceView
                try {
                    camera.setPreviewDisplay(sv_save_surface.getHolder());      //??????????????????
                } catch (IOException e) {
                    e.printStackTrace();
                }

                camera.startPreview();            //??????????????????
                camera.autoFocus(null);       //????????????
            }
            @Override//????????????
            public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
            }
            @Override//????????????
            public void surfaceDestroyed(SurfaceHolder holder) {
                //????????????????????????????????????????????????
                if(camera!=null){
                    camera.stopPreview();
                    camera.release();//????????????
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
                            //??????bitmap???????????????????????????
                            Bitmap bitmap= BitmapFactory.decodeByteArray(bytes,0,bytes.length);
                            //????????????90???
                            Matrix m = new Matrix();
                            m.setRotate(-90,(float) bitmap.getWidth() / 2, (float) bitmap.getHeight() / 2);
                            //?????????????????????????????????bm
                            final Bitmap bm = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), m, true);

                            try {
                                //??????????????????
                                strImageFile = getApplicationContext().getFilesDir()+"/"+String.format("%d",System.currentTimeMillis())+".jpg";
                                FileOutputStream fos = new FileOutputStream(strImageFile);

                                bm.compress(Bitmap.CompressFormat.JPEG,100,fos);     //??????
                                fos.close();                                                 //????????????
                                camera.stopPreview();                                        //?????????????????????
                                picture.setImageBitmap(bm);                                  //??????picture????????????
                                camera.startPreview();                                       //?????????????????????
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
                    Toast.makeText(getApplicationContext(),"????????????",Toast.LENGTH_SHORT).show();
                    return;
                }
                if (strImageFile.length() < 1) {
                    Toast.makeText(getApplicationContext(),"????????????",Toast.LENGTH_SHORT).show();
                    return;
                }
                userInfo = editTextName.getText().toString();
                if (userInfo.length() < 1) {
                    Toast.makeText(getApplicationContext(),"???????????????",Toast.LENGTH_SHORT).show();
                    return;
                }
                //???????????????????????????????????????????????????
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        //????????????????????????
                        if (strAccessToken == "")                                  //??????accessToken??????
                        {
                            strAccessToken = AuthService.getAuth();                //??????AccessToken
                        }
                        if(strAccessToken ==""||strAccessToken ==null)
                        {
                            return;
                        }
                        userId = "userId_"+String.format("%d",System.currentTimeMillis());     //???useID_????????? ?????????userId

                        String strReturn = face_add(userId,userInfo);                           //???????????? ??????
                        if (strReturn == null) {
                            Message msg = new Message();          //??????message
                            msg.what = 0x1234;                    //?????????????????????0x1234
                            MessageHandle.sendMessage(msg);
                        }
                        JSONObject jsonObject = null;             //??????json??????
                        try {
                           jsonObject =  new JSONObject(strReturn);         //?????????????????????
                           String strresult = jsonObject.getString("error_msg");       //??????error_msg
                           Message msg = new Message();          //??????message
                           if (strresult.contains("SUCCESS"))
                              msg.what = 0x1235;                             //????????????
                           else {
                               msg.what = 0x1236;                            //????????????
                               msg.obj = strresult;                          // ??????????????????????????????????????????
                           }
                           MessageHandle.sendMessage(msg);                   //????????????????????????????????????
                        }catch (Exception ex) {
                            ex.printStackTrace();
                        }
                    }
                }).start();
            }
        });


    }
}
