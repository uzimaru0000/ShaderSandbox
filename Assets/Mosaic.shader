Shader "Custom/Mosaic" {
	Properties {
		_BaseColor ("BaseColor", Color) = (1,1,1,1)
		_PrimaryColor ("PrimaryColor", Color) = (1,1,1,1)
		_SecondaryColor ("SecondaryColor", Color) = (1,1,1,1)
		_ThirdlyColor ("ThirdlyColor", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Scale ("Scale", Float) = 1.0
		_Threshold ("Threshold", Range(0.0, 1.0)) = 0.5
		_Diff ("Diff", Vector) = (0, 0, 0, 0)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		#include "Random.cginc"

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;

		fixed4 _BaseColor;
		fixed4 _PrimaryColor;
		fixed4 _SecondaryColor;	
		fixed4 _ThirdlyColor;
		half _Scale;
		half _Threshold;
		fixed2 _Diff;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			int p = step(perlinNoise(IN.uv_MainTex * _Scale), _Threshold);
			int s = step(perlinNoise((IN.uv_MainTex + _Diff) * _Scale), pow(_Threshold, 1.2));
			int t = step(perlinNoise((IN.uv_MainTex - _Diff) * _Scale), pow(_Threshold, 1.5));

			fixed4 c = t * _ThirdlyColor + (1 - t) * s * _SecondaryColor + (1 - t) * (1 - s) * p * _PrimaryColor + (1 - t) * (1 - p) * (1 - s) * _BaseColor;
			o.Albedo = c.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
