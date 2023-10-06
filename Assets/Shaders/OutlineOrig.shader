Shader "ISA/UV Outline"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
		_OutlineColor ("Outline color", Color) = (0,0,0,1)
		_OutlineWidth ("Outlines width", Range (0.0, 2.0)) = 1.1
    }
    
	CGINCLUDE
	#include "UnityCG.cginc"
 
    struct appdata
    {
        float4 vertex : POSITION;
        float2 uv : TEXCOORD0;
    };

    struct v2f
    {
        float2 uv : TEXCOORD0;
        float4 pos : POSITION;
    };

    uniform float _OutlineWidth;
    uniform float4 _OutlineColor;
    half _Glossiness;
    half _Metallic;
    fixed4 _Color;
    sampler2D _MainTex;

    ENDCG
    
    SubShader
    {

        Tags {"Queue"= "Geometry" "RenderType"="Transparent" "IgnoreProjector" = "True" }
        LOD 100
        pass{
            ZWrite OFF
            Cull Back
			CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag


            float4 _MainTex_ST;
            v2f vert(appdata v)
			{
				appdata original = v;
				v.vertex.xyz += _OutlineWidth * normalize(v.vertex.xyz);

				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;

			}

			fixed4 frag(v2f i) : SV_TARGET
			{
                fixed4 col = tex2D(_MainTex, i.uv) * _OutlineColor;
                return col;
			}
            ENDCG
        }

        Tags { "Queue"="Alphatest" }

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
        };


        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
