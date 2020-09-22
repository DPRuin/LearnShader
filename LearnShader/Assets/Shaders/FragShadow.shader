Shader "Custom/Shadow/FragShadow"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 0)
        _MainTex ("Alpha", 2D) = " white " { }
    }
    
    SubShader
    {
        
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent" "LightMode" = "ForwardBase" }
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Back
        ColorMask RGBA
        ZWrite On
        ZTest LEqual
        
        Pass
        {
            Name "FragShadow"
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            //#pragma multi_Compile_instancing
            #include "UnityCG.cginc"
            
            struct appdata
            {
                float4 vertex: POSITION;
                float4 Color: COLOR;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                float4 texcoord: TEXCOORD;
            };
            
            struct v2f
            {
                float4 vertex: SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
                float4 texcoord1: TEXCOORD1;
            };
            
            fixed4 _Color;
            sampler2D _MainTex;
            half4 _MainTex_ST;
            
            v2f vert(appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                o.texcoord1.xy = v.texcoord.xy;
                
                o.texcoord1.zw = 0;
                float3 vertexValue = float3(0, 0, 0);
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }
            
            fixed4 frag(v2f i): SV_TARGET
            {
                UNITY_SETUP_INSTANCE_ID(i);
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
                fixed4 finalColor;
                float2 uv_MainTex = i.texcoord1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                half4 appendsult = (half4(_Color.rgb, (tex2D(_MainTex, uv_MainTex).a * _Color.a)));
                finalColor = appendsult;
                return finalColor;
            }
            ENDCG
            
        }
    }
}
