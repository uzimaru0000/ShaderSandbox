Shader "Unlit/BurningShip"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Sampling ("Sampling", Int) = 5
		_Base ("Base", Vector) = (0, 0, 0, 0)
		_Scale ("Scale", float) = 1
		_Z0 ("Z0", Vector) = (0, 0, 0, 0)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			int _Sampling;
			float2 _Base;
			float _Scale;
			fixed2 _Z0;

			fixed2 complexPow2(fixed2 c) {
				fixed x = c.x * c.x - c.y * c.y;
				fixed y = 2 * c.x * c.y;
				return fixed2(x, y);
			}

			fixed complexSeqLength(fixed2 c) {
				return sqrt(c.x * c.x + c.y * c.y);
			}

			int calc(float2 c) {
				fixed2 z = _Z0;
				for(int i = 0; i < _Sampling; i++) {
					z = complexPow2(fixed2(abs(z.x), abs(z.y))) + c;
					if (complexSeqLength(z) > 2) return i;
				}

				return i;
			}

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed n = 1.0 - (fixed) calc((i.uv - float2(0.5, 0.5)) / _Scale + _Base) / _Sampling;
				fixed4 col = fixed4(n, n, n, 1.0);
				return col;
			}
			ENDCG
		}
	}
}
