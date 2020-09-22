// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

/* 
着色器 定义Shader名称、路径

*/
Shader "Custom/MappingSurfaceShader"
{
    /* 
    属性定义
        Color  
        2D 
        Cube
        Float
        Range
        Vector
    */
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _Bump("Bump", 2D) = "bump" {}
        _Snow("Snow Level", Range(0, 1)) = 1
        _SnowColor("Snow Color", Color ) = (1.0, 1.0, 1.0, 1.0)
        _SnowDirection("Snow Direction", Vector) = (0, 1, 0) 
        _SnowDepth("Snow Depth", Range(0, 0.3)) = 0.1

    }
    /*
    子着色器：可以多个
        里面定义多个Pass通道
    */ 
    SubShader
    {
        /* 
        标签，硬件通过判定标签来决定什么时候调用该着色器
        "RenderType" = "Transparent"    ： 渲染含有透明效果的物体时调用
        "IgnoreProjector"="True"    ：不被Projectors投影影响
        "ForceNoShadowCasting"="True"   ：从不产生阴影

        "Queue"="xxx"   ：指定渲染顺序队列，Unity做透明和不透明物体混合的话，很可能会遇到不透明物体无法呈现在透明物体之后的情况
        这种情况很可能是由于Shader的渲染顺序不正确导致。Queue指定了物体的渲染顺序，预定义的Queue有：
            Background - 最早被调用的渲染，用来渲染天空盒或者背景
            Geometry - 这是默认值，用来渲染非透明物体（普通情况下，场景中的绝大多数物体应该是非透明的）
            AlphaTest - 用来渲染经过Alpha Test的像素，单独为AlphaTest设定一个Queue是出于对效率的考虑
            Transparent - 以从后往前的顺序渲染透明物体
            Overlay - 用来渲染叠加的效果，是渲染的最后阶段（比如镜头光晕等特效）
        */

        // 渲染非透明物体时调用
        Tags { "RenderType"="Opaque" }
        /*
        Level of Detail
            VertexLit及其系列 = 100
            Decal, Reflective VertexLit = 150
            Diffuse = 200
            Diffuse Detail, Reflective Bumped Unlit, Reflective Bumped VertexLit = 250
            Bumped, Specular = 300
            Bumped Specular = 400
            Parallax = 500
            Parallax Specular = 600
        */
        LOD 200

        // 开始标记： 代码块CG程序
        CGPROGRAM

        // 编译指令： 表面shader 方法名 光照模型Lambert 
        //#pragma surface surf Lambert

        /*
        自定义 CustomDiffuse 光照模型
        按照约定的规则声明一个光照计算的函数名字：LightingCustomDiffuse
        */
        #pragma surface surf CustomDiffuse vertex:vert

        // CG程序要想访问Properties中所定义的变量的话，必须使用和变量相同的名字进行声明
    	sampler2D _MainTex;
    	sampler2D _Bump;
        float _Snow;            // 积雪量
        float4 _SnowColor;      // 积雪颜色
        float4 _SnowDirection;  // 积雪方向
        float _SnowDepth;       // 积雪深度

        /* 
        Input是需要我们去定义的结构体：参与计算的数据
        SurfaceOutput：预定义的输出结构
            struct SurfaceOutput 
            {
                fixed3 Albedo;      // 像素的颜色
                fixed3 Normal;      // 像素的法向值
                fixed3 Emission;    // 像素的发散颜色
                half Specular;      // 像素的镜面高光
                fixed Gloss;        // 像素的发光强度
                fixed Alpha;        // 像素的透明度
            }
        */

        struct Input
        {
            /*
            CG程序中约定贴图变量之前价值uv就代表提取它的uv值
            */
            float2 uv_MainTex;
            float2 uv_Bump;
            float3 worldNormal; INTERNAL_DATA 

        };
    
		void surf (Input IN, inout SurfaceOutput o)
		{
            half4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Normal = UnpackNormal(tex2D(_Bump, IN.uv_Bump));

            if (dot(WorldNormalVector(IN, o.Normal), _SnowDirection.xyz) > lerp(1, -1, _Snow))
            {
                o.Albedo = _SnowColor.rgb;
            } else {
                o.Albedo = c.rgb;
            }

            o.Alpha = c.a;
            
		}

        // 自定义光照模型
        inline float4 LightingCustomDiffuse (SurfaceOutput s, fixed3 lightDir, fixed atten) {
            float difLight = max(0, dot(s.Normal, lightDir));
            float hLambert = difLight * 0.5 + 0.5;
            float4 col;
            col.rgb = s.Albedo * _LightColor0.rgb * (hLambert * atten * 2);
            col.a = s.Alpha;
            return  col;
        }

        /*
        积雪效果实现思路：
        需要积雪等级（用来表示积雪量），雪的颜色，以及积雪的方向。
        基本思路和实现自定义光照模型类似，通过计算原图的点在世界坐标中的法线方向与积雪方向的点积，
        如果大于设定的积雪等级的阈值的话则表示这个方向与积雪方向是一致的，其上是可以积雪的，显示雪的颜色，否则使用原贴图的颜色。
        */
        void vert(inout appdata_full v) {
            float4 sn = mul(transpose(unity_ObjectToWorld), _SnowDirection);
            if (dot(v.normal, sn.xyz) >= lerp(1, -1, (_Snow * 2) / 3))
            {
                v.vertex.xyz += (sn.xyz + v.normal) * _SnowDepth * _Snow;
            }
            
        }

        // 结束标记
        ENDCG 
    }

    // 回滚 需要明白每帧调用
    FallBack "Diffuse"
}
