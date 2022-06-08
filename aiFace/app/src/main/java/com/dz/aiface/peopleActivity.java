package com.dz.aiface;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import org.w3c.dom.Text;

public class peopleActivity extends AppCompatActivity {
    TextView textViewInfo = null;
    Button exitBtn;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_people);

        textViewInfo = (TextView)findViewById(R.id.textViewInfo);
        Intent intent = getIntent();  //获取intent传递
        textViewInfo.setText("你好 " + intent.getStringExtra("name"));

        exitBtn = (Button)findViewById(R.id.exitBtn);
        exitBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                System.exit(0);
            }
        });
    }
}
