// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X

Shader "Custom/Light_strip"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Main_Color("Main_Color", 2D) = "white" {}
		_RGB("RGB", Color) = (0.1415094,0.1415094,0.1415094,0)
		_Quanxi("Quanxi", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _RGB;
		uniform sampler2D _Main_Color;
		uniform float4 _Main_Color_ST;
		uniform sampler2D _Quanxi;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Main_Color = i.uv_texcoord * _Main_Color_ST.xy + _Main_Color_ST.zw;
			float4 tex2DNode5 = tex2D( _Main_Color, uv_Main_Color );
			float mulTime18 = _Time.y * 0.1;
			float2 temp_cast_0 = (mulTime18).xx;
			float2 uv_TexCoord16 = i.uv_texcoord * float2( 0,0.5 ) + temp_cast_0;
			float4 clampResult19 = clamp( ( ( unity_DeltaTime.y * _RGB ) * tex2DNode5 * tex2DNode5.a * tex2D( _Quanxi, uv_TexCoord16 ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Emission = clampResult19.rgb;
			o.Alpha = 1;
			clip( tex2DNode5.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17400
1927;34;1906;995;610.0895;1639.667;1.3;True;True
Node;AmplifyShaderEditor.SimpleTimeNode;18;-375.5281,-1384.232;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DeltaTime;10;-332.9748,-1172.977;Inherit;True;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;4;-341.741,-766.2687;Inherit;False;Property;_RGB;RGB;2;0;Create;True;0;0;False;0;0.1415094,0.1415094,0.1415094,0;0.7139021,0.1539789,0.6831063,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-127.0487,-1440.737;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0,0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-2.68988,-982.9105;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;5;-293.0626,-472.0807;Inherit;True;Property;_Main_Color;Main_Color;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;120.6458,-1455.128;Inherit;True;Property;_Quanxi;Quanxi;3;0;Create;True;0;0;False;0;-1;05aa43dbbeddb24419e5b5b6e734d595;05aa43dbbeddb24419e5b5b6e734d595;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;308.7889,-864.5261;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;19;750.389,-1056.301;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;8;975.3447,-753.9924;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Customize/Light_strip;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Opaque;;AlphaTest;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;1;0,0.4037895,1,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;1;18;0
WireConnection;11;0;10;2
WireConnection;11;1;4;0
WireConnection;14;1;16;0
WireConnection;6;0;11;0
WireConnection;6;1;5;0
WireConnection;6;2;5;4
WireConnection;6;3;14;0
WireConnection;19;0;6;0
WireConnection;8;2;19;0
WireConnection;8;10;5;4
ASEEND*/
//CHKSM=CE786D89B297B98093C87C519EC7A5E14E193B8F