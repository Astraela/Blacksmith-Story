Shader "ISA/Textured Outline"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _OutlineWidth ("Outline Width", float) = .25
        _OutlineColor ("Outline Color", Color) = (0,0,0,1)
    }

    CGINCLUDE
	#include "UnityCG.cginc"

	struct appdata
	{
		float4 vertex : POSITION;
        float2 uv : TEXCOORD0;
        float3 normal : NORMAL;
	};

	struct v2f
	{
        float2 uv : TEXCOORD0;
		float4 vertex : SV_POSITION;
	};

	uniform float _OutlineWidth;
	uniform float4 _OutlineColor;
	uniform sampler2D _MainTex;
	float4 _MainTex_ST;

	ENDCG

    SubShader
    {
        Tags {"Queue"="Geometry" "RenderType"="Transparent" "IgnoreProjector" = "True" }
        LOD 100

        Pass
        {
            ZWrite OFF
            Cull Back
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            v2f vert (appdata v)
            {
				appdata original = v;
				v.vertex.xyz += _OutlineWidth * float3(unity_ObjectToWorld[0].x, unity_ObjectToWorld[0].y, unity_ObjectToWorld[0].z) * normalize(v.vertex.xyz);

				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
                float2 worldpos = mul(unity_ObjectToWorld, v.vertex).xy;

                o.uv = TRANSFORM_TEX(worldpos, _MainTex);
				return o;
            }

            fixed4 frag (v2f i) : COLOR
            {
                //i.uv = i.uv.x/i.uv.y;
                fixed4 col = tex2D(_MainTex, i.uv) * _OutlineColor;
                return col;
            }
            ENDCG
        }
    }
}
